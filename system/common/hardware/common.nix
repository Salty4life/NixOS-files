{pkgs, ...}: {
  # Enables OpenTabletDriver and it's deamon (yes I know it's on the bluetooth file, this is definitely gonna bite me in the ass if I forget to clean it)
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  boot.kernelModules = ["asus-nb-wmi"];
  environment.systemPackages = with pkgs; [
    solaar
    logiops
    asusctl
  ];

  hardware.logitech.wireless.enable = true;

  programs.rog-control-center = {
    enable = true;
    autoStart = true;
  };
}
