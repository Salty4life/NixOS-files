{
  lib,
  config,
  ...
}: {
  options.alcaide.hardware.otd.enable = lib.mkEnableOption "otd config";

  config = lib.mkIf config.alcaide.hardware.otd.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
