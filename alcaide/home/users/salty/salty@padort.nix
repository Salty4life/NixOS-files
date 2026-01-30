{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (config.home) username;
  inherit (osConfig.networking) hostName;
in
lib.mkIf (username == "salty" && hostName == "padort") {
  alcaide = {
    profiles.graphical.enable = true;
    games.xr.enable = true;
    applications = {
      blender.enable = true;
      krita.enable = true;
    };
  };
}
