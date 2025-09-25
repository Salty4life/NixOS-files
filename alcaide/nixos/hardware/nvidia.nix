{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.hardware.nvidia.enable = lib.mkEnableOption "nvidia config";

  config = lib.mkIf config.alcaide.hardware.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    # Enables the kernel modules for the graphics
    hardware = {
      graphics.enable = true;
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
    environment.systemPackages = with pkgs; [
      cudatoolkit
      lact
    ];
    # GUI tools
    systemd.packages = with pkgs; [
      lact
    ];

    nixpkgs.config.cudaSupport = true;
  };
}
