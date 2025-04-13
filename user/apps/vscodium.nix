{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      vscode-icons-team.vscode-icons
      mkhl.direnv
      jnoortheen.nix-ide
      b4dm4n.vscode-nixpkgs-fmt
      tamasfe.even-better-toml
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      ms-python.vscode-pylance
      ms-python.python
      ms-python.debugpy
      ms-python.pylint
      # pylyzer.pylyzer
      ms-python.isort
      ms-python.black-formatter
      bbenoist.nix
      scalameta.metals
      scala-lang.scala
      haskell.haskell
      denoland.vscode-deno
    ];
    haskell = {
      enable = true;
      hie = {
        enable = true;
        executablePath = "${pkgs.haskellPackages.implicit-hie}/bin/gen-hie";
      };
    };
    userSettings = {
      "workbench.iconTheme" = "vscode-icons";
      "python.linting.pylintArgs" = [ "--extension-pkg-whitelist=cv2" "--generate-members" ];
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
    };
  };
}
