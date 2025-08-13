{
  lib,
  config,
  ...
}: {
  options.alcaide.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.alcaide.profiles.minimal.enable {
    alcaide = {
      nix.nix.enable = true;
      services.tailscale.enable = true;
      programs.nh.enable = true;
      system = {
        boot.enable = true;
        locale.enable = true;
        networking.enable = true;
        home-manager.enable = true;
      };
    };
  };
}
