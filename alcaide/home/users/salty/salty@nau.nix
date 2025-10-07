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
lib.mkIf (username == "salty" && hostName == "nau") {
  alcaide = {
    profiles.graphical.enable = true;
    games.xr.enable = true;
  };
}
