{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.hardware.amdgpu.enable = lib.mkEnableOption "amdgpu config";

  config = lib.mkIf config.alcaide.hardware.amdgpu.enable {
    services.xserver.videoDrivers = [ "amdgpu" ];

    # Enables the kernel modules for the graphics
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      clinfo
      lact
    ];

    # GUI tools
    systemd.packages = with pkgs; [
      lact
    ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
