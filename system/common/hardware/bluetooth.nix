{pkgs, ...}: {
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
}
