{pkgs, ...}: let
  nu-grammar = pkgs.tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0+rev=358c4f5";
    src = pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "tree-sitter-nu";
      rev = "0bb9a602d9bc94b66fab96ce51d46a5a227ab76c";
      hash = "sha256-A5GiOpITOv3H0wytCv6t43buQ8IzxEXrk3gTlOrO0K0=";
    };
  };
in {
  filetype.extension.nu = "nu";

  plugins.treesitter = {
    enable = true;
    nixvimInjections = true;

    languageRegister.nu = "nu";
    grammarPackages = [nu-grammar] ++ pkgs.vimPlugins.nvim-treesitter.allGrammars;

    settings = {
      indent.enable = true;
      highlight.enable = true;
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = false;
          node_decremental = "<A-CR>";
          node_incremental = "<CR>";
          # scope_incremental = "grc";
        };
      };
    };
  };

  extraFiles = {
    "/queries/nu/highlights.scm".text = builtins.readFile "${nu-grammar}/queries/nu/highlights.scm";
    "/queries/nu/injections.scm".text = builtins.readFile "${nu-grammar}/queries/nu/injections.scm";
  };

  extraConfigLua = /* lua */
    ''
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.nu = {
        filetype = "nu",
      }
    '';
}
