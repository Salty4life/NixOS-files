{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.hardware.amdgpu.enable = lib.mkEnableOption "amdgpu config";

  config = lib.mkIf config.alcaide.hardware.amdgpu.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    # Enables the kernel modules for the graphics
    hardware = {
      firmware = with pkgs; [ linux-firmware ];
      amdgpu = {
        overdrive.enable = true;
        initrd.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          libva
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      glxinfo
      vulkan-tools
      clinfo
      libva-utils
      lact
      amdgpu_top
      nvtopPackages.amd # (h)top like task monitor for AMD, Adreno, Intel and NVIDIA GPUs
    ];

    # LACT daemon activation
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
