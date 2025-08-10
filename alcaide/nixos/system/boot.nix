{
  lib,
  config,
  ...
}: {
  options.alcaide.system.boot.enable = lib.mkEnableOption "boot config";

  config = lib.mkIf config.alcaide.system.boot.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
