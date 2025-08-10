{
  lib,
  config,
  ...
}: {
  options.alcaide.programs.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.alcaide.programs.nh.enable {
    programs.nh = {
      enable = true;
      flake = "/home/salty/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
