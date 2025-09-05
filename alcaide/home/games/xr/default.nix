{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.alcaide.games.xr;
in
{
  options.alcaide.games.xr = {
    enable = lib.mkEnableOption "xr config";

    enterVrHook = lib.mkOption {
      type = types.str;
      default = "";
      description = "Command to run before entering VR";
    };

    exitVrHook = lib.mkOption {
      type = types.str;
      default = "";
      description = "Command to run after exiting VR";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries =
      let
        vr-session-manager = pkgs.writeShellApplication {
          name = "vr-session-manager";
          runtimeInputs = with pkgs; [
            libnotify
            systemd
          ];
          text =
            builtins.readFile ./vr-session-manager.sh
            |>
              lib.replaceStrings
                [
                  "# __ENTER_VR_HOOK__"
                  "# __EXIT_VR_HOOK__"
                ]
                [
                  cfg.enterVrHook
                  cfg.exitVrHook
                ];
        };

        baseEntry = {
          type = "Application";
          terminal = false;
          categories = [ "Utility" ];
          startupNotify = false;
        };
      in
      {
        start-vr-session = {
          name = "Start VR Session";
          exec = "${lib.getExe vr-session-manager} start";
        }
        // baseEntry;

        stop-vr-session = {
          name = "Stop VR Session";
          exec = "${lib.getExe vr-session-manager} stop";
        }
        // baseEntry;
      };

    # https://lvra.gitlab.io/docs/distros/nixos/#recommendations
    xdg.configFile."openvr/openvrpaths.vrpath" = {
      text = ''
        {
          "config" :
          [
            "~/.local/share/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "~/.local/share/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite"
          ],
          "version" : 1
        }
      '';
      force = true;
    };

    # https://github.com/galister/wlx-overlay-s/wiki
    xdg.configFile."wlxoverlay" = {
      source = ./wlx-overlay-s;
      recursive = true;
      force = true;
    };

    # https://lvra.gitlab.io/docs/fossvr/opencomposite/#rebinding-controls
    xdg.dataFile =
      let
        steamDir = "Steam/steamapps/common";
      in
      {
        "${steamDir}/VRChat/OpenComposite/oculus_touch.json".source =
          ./opencomposite/vrchat/oculus_touch.json;
      };
  };
}
