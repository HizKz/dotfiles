#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage: ./add-o24-keyboard.sh [--variant external|jis|macbook-style] [--dry-run]

Add a connected physical keyboard to the o24 profile.

Options:
  --variant VARIANT  Layout variant to add (default: external)
  --dry-run          Show the selected device without changing karabiner.json
  -h, --help         Show this help
EOF
}

variant=external
dry_run=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --variant)
      if [ "$#" -lt 2 ]; then
        echo "error: --variant requires a value" >&2
        usage >&2
        exit 2
      fi
      variant=$2
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$variant" in
  external | jis | macbook-style) ;;
  *)
    echo "error: unsupported variant: $variant" >&2
    usage >&2
    exit 2
    ;;
esac

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
config_path=${O24_CONFIG_PATH:-$script_dir/karabiner.json}
layout_path=${O24_LAYOUT_PATH:-$script_dir/o24-layouts.json}
karabiner_cli_path=${O24_KARABINER_CLI_PATH:-/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli}
config_dir=$(CDPATH= cd -- "$(dirname -- "$config_path")" && pwd -P)

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required" >&2
  exit 1
fi

if [ ! -x "$karabiner_cli_path" ]; then
  echo "error: karabiner_cli is not executable: $karabiner_cli_path" >&2
  exit 1
fi

if ! jq empty "$config_path"; then
  echo "error: invalid Karabiner configuration: $config_path" >&2
  exit 1
fi

if ! jq -e --arg variant "$variant" '
  (.base | type == "array") and
  (.variants[$variant] | type == "array")
' "$layout_path" >/dev/null; then
  echo "error: invalid o24 layout template: $layout_path" >&2
  exit 1
fi

profile_count=$(jq '[.profiles[] | select(.name == "o24")] | length' "$config_path")
if [ "$profile_count" -ne 1 ]; then
  echo "error: expected exactly one o24 profile, found $profile_count" >&2
  exit 1
fi

original_path=$(mktemp "${TMPDIR:-/tmp}/o24-karabiner-original.XXXXXX")
generated_path=
cleanup() {
  rm -f "$original_path"
  if [ -n "$generated_path" ]; then
    rm -f "$generated_path"
  fi
}
trap cleanup EXIT HUP INT TERM

cp -p "$config_path" "$original_path"

if [ -n "${O24_CONNECTED_DEVICES_PATH:-}" ]; then
  if ! connected_devices=$(jq -c '.' "$O24_CONNECTED_DEVICES_PATH"); then
    echo "error: invalid connected devices JSON: $O24_CONNECTED_DEVICES_PATH" >&2
    exit 1
  fi
else
  if ! connected_devices=$("$karabiner_cli_path" --list-connected-devices); then
    echo "error: failed to list connected devices" >&2
    exit 1
  fi
fi

if ! candidates=$(printf '%s\n' "$connected_devices" | jq -c --slurpfile config "$original_path" '
  [
    $config[0].profiles[]
    | select(.name == "o24")
    | .devices[]?.identifiers
    | select(.vendor_id != null and .product_id != null)
    | { vendor_id, product_id }
  ] as $registered
  |
  [
    .[]
    | select(.device_identifiers.is_keyboard == true)
    | select((.device_identifiers.is_virtual_device // false) | not)
    | select(
        .device_identifiers.vendor_id != null and
        .device_identifiers.product_id != null
      )
    | {
        manufacturer: (.manufacturer // "Unknown"),
        product: (.product // "Unknown keyboard"),
        identifiers: (
          {
            is_keyboard: true,
            vendor_id: .device_identifiers.vendor_id,
            product_id: .device_identifiers.product_id
          }
          + if .device_identifiers.is_pointing_device == true then
              { is_pointing_device: true }
            else
              {}
            end
        ),
        endpoint_score: (
          if .device_identifiers.is_pointing_device == true then 1 else 0 end
        )
      }
    | select(
        .identifiers as $identifiers
        | $registered
        | any(
            .vendor_id == $identifiers.vendor_id and
            .product_id == $identifiers.product_id
          )
        | not
      )
  ]
  | sort_by(.identifiers.vendor_id, .identifiers.product_id, .endpoint_score)
  | unique_by(.identifiers.vendor_id, .identifiers.product_id)
  | map(del(.endpoint_score))
'); then
  echo "error: karabiner_cli returned invalid connected devices JSON" >&2
  exit 1
fi

candidate_count=$(printf '%s\n' "$candidates" | jq 'length')
if [ "$candidate_count" -eq 0 ]; then
  echo "No unregistered physical keyboards are connected."
  exit 0
fi

printf '%s\n' "$candidates" | jq -r '
  to_entries[]
  | "\(.key + 1)) \(.value.manufacturer) / \(.value.product) " +
    "(vendor=\(.value.identifiers.vendor_id), product=\(.value.identifiers.product_id))"
'
printf 'Select a keyboard [1-%s]: ' "$candidate_count" >&2
if ! IFS= read -r selection; then
  echo "cancelled: no keyboard was selected" >&2
  exit 2
fi

case "$selection" in
  '' | *[!0-9]*)
    echo "error: selection must be a number" >&2
    exit 2
    ;;
esac

if [ "$selection" -lt 1 ] || [ "$selection" -gt "$candidate_count" ]; then
  echo "error: selection is out of range" >&2
  exit 2
fi

selected_index=$((selection - 1))
selected_device=$(printf '%s\n' "$candidates" | jq -c ".[$selected_index]")
selected_identifiers=$(printf '%s\n' "$selected_device" | jq -c '.identifiers')
selected_label=$(printf '%s\n' "$selected_device" | jq -r '
  "\(.manufacturer) / \(.product) " +
  "(vendor=\(.identifiers.vendor_id), product=\(.identifiers.product_id))"
')

if [ "$dry_run" = true ]; then
  echo "dry-run: would add $selected_label as variant $variant"
  exit 0
fi

if ! cmp -s "$config_path" "$original_path"; then
  echo "error: karabiner.json changed while selecting a device; no changes were written" >&2
  exit 1
fi

generated_path=$(mktemp "$config_dir/.karabiner.json.XXXXXX")

jq \
  --slurpfile layout "$layout_path" \
  --arg variant "$variant" \
  --argjson identifiers "$selected_identifiers" \
  '
    ($layout[0].base + $layout[0].variants[$variant]) as $modifications
    | (.profiles[] | select(.name == "o24") | .devices) += [
        {
          identifiers: $identifiers,
          simple_modifications: $modifications
        }
      ]
  ' "$original_path" >"$generated_path"

jq empty "$generated_path"
"$karabiner_cli_path" --format-json "$generated_path"
jq empty "$generated_path"

if ! cmp -s "$config_path" "$original_path"; then
  echo "error: karabiner.json changed while selecting a device; no changes were written" >&2
  exit 1
fi

chmod "$(stat -f '%Lp' "$original_path")" "$generated_path"
mv "$generated_path" "$config_path"
generated_path=

echo "added: $selected_label as variant $variant"
