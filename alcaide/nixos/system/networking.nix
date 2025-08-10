{
  lib,
  config,
  ...
}: {
  options.alcaide.system.networking.enable = lib.mkEnableOption "networking config";

  config = lib.mkIf config.alcaide.system.networking.enable {
    networking.networkmanager.enable = true;
  };
}
