{ config, pkgs, lib, ... }:
{

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

    enableLazy = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    colorschemes.gruvbox = {
      enable = true;
      settings = {
        contrast_dark = "hard";
        italic = { strings = false; comments = true; };
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
      updatetime = 100;  # faster CursorHold
      mouse = "a";
    };

    keymaps = [
      # Basics
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options.silent = true; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options.silent = true; }
      # Split navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
    ];

    plugins = {
      lualine.enable = true;
      nix.enable = true;  # nix filetype + highlighting

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
          nil_ls.enable = true;  # nix
          nixd.enable = true;    # better nix LSP
          rust-analyzer.enable = true;
          ts_ls.enable = true;
          pyright.enable = true;
        };
        keymaps = {
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            "gd" = "definition";
            "gr" = "references";
            "K" = "hover";
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
      extraPlugins = with pkgs.vimPlugins; [ vim-nix ];
    };

    # Fallback for things not yet exposed as options
    extraConfigLua = ''
      -- Example: disable inline diagnostics (personal taste)
      vim.diagnostic.config({ virtual_text = false })
    '';
  };

  # Optional: make nvim available in systemPackages even if someone disables the module
  environment.systemPackages = [ config.programs.nixvim.finalPackage ];
}
