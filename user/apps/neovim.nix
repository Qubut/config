{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast_dark = "hard";
        italic = {
          strings = false;
          comments = true;
        };
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      cursorline = true;
      shiftwidth = 4;
      tabstop = 4;
      expandtab = true;
      smartindent = true;
      wrap = false;
      termguicolors = true;
      signcolumn = "yes";
      updatetime = 100;
      mouse = "a";
    };

    keymaps = [
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options.silent = true; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options.silent = true; }
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
    ];

    plugins = {
      lualine.enable = true;

      treesitter = {
        enable = true;
        folding = true;
        nixvimInjections = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash c cpp lua nix python rust tsx typescript vim regex
        ];
      };

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          nixd.enable = true;

          rust_analyzer = {  # ← renamed (no hyphen)
            enable = true;
            installCargo = false;  # ← change to true if you want nixvim to install cargo
            installRustc = false;  # ← silences warnings
          };

          ts_ls.enable = true;
          pyright.enable = true;

          # If we EVER add atopile LSP later:
          # atopile = {
          #   enable = true;
          #   package = null;  # prevents auto-install attempt if needed
          # };
        };

        keymaps = {
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            gd = "definition";
            gr = "references";
            K = "hover";
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };

    extraConfigLua = ''
      vim.diagnostic.config({ virtual_text = false })
    '';
  };

  # Updated: obsolete finalPackage → build.package
  home.packages = [ config.programs.nixvim.build.package ];
}
