{
  lib,
  config,
  self,
  ...
}: {
  options.alcaide.users.salty.enable = lib.mkEnableOption "user salty";

  config = lib.mkIf config.alcaide.users.salty.enable {
    users.users.salty = {
      uid = 1000;
      isNormalUser = true;
      description = "salty";
      extraGroups = ["networkmanager" "wheel"];
    };
    
    alcaide.system.home-manager.enable = true;

    home-manager.users.salty = {
      imports = [
        self.homeModules.alcaide
      ];

      home = {
        username = "salty";
        homeDirectory = "/home/salty";
        inherit (config.system) stateVersion;
      };
    };
  };
}
