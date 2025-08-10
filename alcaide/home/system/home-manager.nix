{
  lib,
  config,
  ...
}: {
  options.alcaide.system.home-manager.enable = lib.mkEnableOption "home-manager config";

  config = lib.mkIf config.alcaide.system.home-manager.enable {
    # TODO: Set your username
    home = {
      username = "salty";
      homeDirectory = "/home/salty";
    };

    # Enable home-manager and git
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.05";
  };
}
