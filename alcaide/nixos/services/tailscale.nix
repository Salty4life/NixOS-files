{
  lib,
  config,
  ...
}: {
  options.alcaide.services.tailscale.enable = lib.mkEnableOption "tailscale config";

  config = lib.mkIf config.alcaide.services.tailscale.enable {
    services.tailscale = {
      enable = true;
      extraUpFlags = ["--accept-routes"];
    };
  };
}
