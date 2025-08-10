{
  lib,
  config,
  pkgs,
  ...
}: {
  options.alcaide.hardware.bluetooth.enable = lib.mkEnableOption "bluetooth config";

  config = lib.mkIf config.alcaide.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
      settings.General = {
        Experimental = true; # Enables Battery level readings on Bluetooth devices

        # idk
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
    };

    services.blueman.enable = true;

    hardware.xpadneo.enable = true;
  };
}
