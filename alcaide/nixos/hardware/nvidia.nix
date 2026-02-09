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
      mesa
      vulkan-tools
      clinfo
      libva-utils
      lact
      nvtopPackages.nvidia # (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
      cudatoolkit
      lact
    ];

    # LACT daemon activation
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    nixpkgs.config.cudaSupport = true;

  };
}
