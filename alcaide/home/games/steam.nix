{
  lib,
  config,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.steam-config-nix.homeModules.default
  ];

  options.alcaide.games.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.alcaide.games.steam.enable {
    programs.steam.config = {
      enable = true;
      closeSteam = true;

      apps = {
        # vrchat
        "438100" = {
          compatTool = "GE-Proton";
          launchOptions = pkgs.writeShellScriptBin "vrchat-wrapper" ''
            unset TZ
            export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc"

            if [[ "$*" != *"--no-vr"* ]]; then
                export PROTON_ENABLE_WAYLAND=1
            fi

            exec "$@"
          '';
        };

        xdg.autostart.entries = lib.singleton (
          pkgs.makeDesktopItem {
            name = "steam-silent";
            destination = "/";
            desktopName = "Steam Silent";
            noDisplay = true;
            exec = "${lib.getExe osConfig.programs.steam.package} -silent";
          }
          + /steam-silent.desktop
        );
      };
    };
  };
}
