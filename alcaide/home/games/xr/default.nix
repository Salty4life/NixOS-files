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

    home.packages = with pkgs; [
      wayvr
    ];

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

    # https://github.com/wlx-team/wayvr/wiki
    xdg.configFile."wayvr" = {
      source = ./wayvr;
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
