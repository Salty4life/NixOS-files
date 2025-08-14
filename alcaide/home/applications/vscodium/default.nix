{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.alcaide.applications.vscodium.enable = lib.mkEnableOption "vscodium config";

  config = lib.mkIf config.alcaide.applications.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
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
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";
    };

    home.file."${config.xdg.configHome}/VSCodium/User/settings.json".force = true;
  };
}
