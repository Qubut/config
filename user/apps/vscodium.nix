{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      ruff
      pyright
      # pylyzer
    ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      vscode-icons-team.vscode-icons
      pkief.material-icon-theme
      mkhl.direnv
      jnoortheen.nix-ide
      b4dm4n.vscode-nixpkgs-fmt
      tamasfe.even-better-toml
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      charliermarsh.ruff
      ms-python.python
      ms-python.debugpy
      ms-python.isort
      ms-python.black-formatter
      # ms-python.vscode-pylance
      ms-python.mypy-type-checker
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-pyright.pyright
      rust-lang.rust-analyzer
      fill-labs.dependi
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers
      redhat.vscode-yaml
      hashicorp.terraform
      bbenoist.nix
      arrterian.nix-env-selector
      scalameta.metals
      scala-lang.scala
      haskell.haskell
      denoland.vscode-deno
      codezombiech.gitignore
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
    ];
    haskell = {
      enable = true;
      hie = {
        enable = true;
        executablePath = "${pkgs.haskellPackages.implicit-hie}/bin/gen-hie";
      };
    };
    profiles.default.userSettings = {
      "typst-lsp.experimentalFormatterMode" = "on";
      "typst-lsp.serverPath" = "${pkgs.tinymist}/bin/tinymist";
      "workbench.iconTheme" = "material-icon-theme";
      "python.defaultInterpreterPath" = "\${workspaceFolder}/.devenv/state/venv/bin/python";
      "python.analysis.extraPaths" = [ "\${workspaceFolder}/src" ];
      "python.languageServer" = "Pyright";
      "python.analysis.autoImportCompletions" = true;
      "python.analysis.autoSearchPaths" = true;
      "python.analysis.inlayHints.functionReturnTypes" = true;
      "python.analysis.inlayHints.variableTypes" = true;
      "python.analysis.nodeExecutable" = "${pkgs.nodejs_24}/bin/node";
      "python.analysis.typeCheckingMode" = "standard";
      "python.analysis.completeFunctionParens" = true;
      "python.linting.enabled" = true;
      "python.linting.ruffEnabled" = true;
      "svelte-enable-ts-plugin" = true;
      "languageServerHaskell.enableHIE" = true;
      "languageServerHaskell.hieExecutablePath" = "${pkgs.haskellPackages.implicit-hie}/bin/gen-hie";
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      # Whitespace
      "files.trimTrailingWhitespace" = true;
      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "diffEditor.ignoreTrimWhitespace" = false;
      "jupyter.askForKernelRestart" = false;
      "workbench.editorAssociations" = {
        "{git,gitlens,git-graph}:/**/*.{md,csv,svg}" = "default";
      };
      "explorer.fileNesting.enabled" = true;
      "explorer.fileNesting.patterns" = {
        "*.ts" = "\${capture}.js, \${capture}.typegen.ts";
        "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
        "*.jsx" = "\${capture}.js";
        "*.tsx" = "\${capture}.ts, \${capture}.typegen.ts";
        "tsconfig.json" = "tsconfig.*.json";
        "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb";
        "*.sqlite" = "\${capture}.\${extname}-*";
        "*.db" = "\${capture}.\${extname}-*";
        "*.sqlite3" = "\${capture}.\${extname}-*";
        "*.db3" = "\${capture}.\${extname}-*";
        "*.sdb" = "\${capture}.\${extname}-*";
        "*.s3db" = "\${capture}.\${extname}-*";
        "*.mts" = "\${capture}.typegen.ts";
        "*.cts" = "\${capture}.typegen.ts";
      };
      "[nix]" = {
        "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt";
      };
      "rust-analyzer.linkedProjects" = [ "\${workspaceFolder}/Cargo.toml" ];
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.rustc.source" = "discover";
    };
  };
}
