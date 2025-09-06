{
  lib,
  config,
  ...
}:
{
  options.alcaide.services.xr.enable = lib.mkEnableOption "xr config";

  config = lib.mkIf config.alcaide.services.xr.enable {
    services.wivrn = {
      enable = true;
      openFirewall = true;
      defaultRuntime = true;

      config = {
        enable = true;
        json = {
          bitrate =
            let
              Mbps = 100;
            in
            Mbps * 1000000;

          encoders = lib.singleton {
            encoder = "vaapi";
            codec = "av1";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          };
        };
      };
    };
  };
}
