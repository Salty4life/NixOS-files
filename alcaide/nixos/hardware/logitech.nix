{
  lib,
  config,
  pkgs,
  ...
}: {
  options.alcaide.hardware.logitech.enable = lib.mkEnableOption "logitech config";

  config = lib.mkIf config.alcaide.hardware.logitech.enable {
    environment.systemPackages = with pkgs; [
      solaar
      logiops
    ];

    hardware.logitech.wireless.enable = true;
  };
}
