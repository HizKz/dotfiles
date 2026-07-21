{
  plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      skip_confirm_for_simple_edits = true;
      constrain_cursor = "name";
      columns = [ "icon" ];
      keymaps."<CR>" = {
        desc = "Open entry from sidebar or enter directory";
        callback.__raw = "function() require('config.oil_sidebar').select_entry() end";
      };
      view_options = {
        show_hidden = true;
        natural_order = true;
        is_always_hidden = "function(name) return name == '.DS_Store' end";
      };
      win_options = {
        signcolumn = "no";
        number = false;
        relativenumber = false;
        wrap = false;
        cursorcolumn = false;
        foldcolumn = "0";
        spell = false;
        list = false;
      };
    };
  };

  extraFiles."lua/config/oil_sidebar.lua".source = ./lua/oil_sidebar.lua;
  extraConfigLuaPost = ''
    require("config.oil_sidebar").setup()
  '';
}
