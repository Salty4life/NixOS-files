{
  lib,
  config,
  osConfig,
  pkgs,
  inputs,
  ...
}: {
  options.alcaide.applications.vscodium.enable = lib.mkEnableOption "vscodium config";

  config = lib.mkIf config.alcaide.applications.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          jnoortheen.nix-ide
          blueglassblock.better-json5
          editorconfig.editorconfig
          ms-python.python
          prettiercode.code-prettier
          tamasfe.even-better-toml
        ];

        userSettings = {
          "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;
          "files.associations" = {
            "*.poiTemplateCollection" = "hlsl";
          };
          "files.enableTrash" = false;
          "git.confirmSync" = false;
          "git.detectSubmodules" = false;
          "git.repositoryScanMaxDepth" = 3;
          "scm.alwaysShowRepositories" = true;
          "window.titleBarStyle" = "custom";
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.startupEditor" = "none";
          # https://github.com/nix-community/vscode-nix-ide
          "nix.serverPath" = "nixd";
          "nix.serverSettings.nixd.formatting.command" = ["alejandra" "-" "--quiet"];
          "nix.serverSettings.nixd.options.nixos.expr" = "(builtins.getFlake \"${osConfig.programs.nh.flake}\").nixosConfigurations.<name>.options";

        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";
    };
  };
}
