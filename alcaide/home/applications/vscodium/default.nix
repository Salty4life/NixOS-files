{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
 let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (inputs.nix-vscode-extensions.extensions.${system}) vscode-marketplace;
    in
{
  options.alcaide.applications.vscodium.enable = lib.mkEnableOption "vscodium config";

  config = lib.mkIf config.alcaide.applications.vscodium.enable {
    
    programs.vscodium = {
      enable = true;

      profiles.default = {
        extensions = with vscode-marketplace; [
            blueglassblock.better-json5
            editorconfig.editorconfig
            ms-python.python
            esbenp.prettier-vscode
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
  };
}
