{
  lib,
  config,
  pkgs,
  ...
}: {
  options.alcaide.hardware.asus.enable = lib.mkEnableOption "asus config";

  config = lib.mkIf config.alcaide.hardware.asus.enable {
    boot.kernelModules = ["asus-nb-wmi" "asus-armoury"];
    environment.systemPackages = with pkgs; [
      asusctl
    ];

    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };
  };
}
