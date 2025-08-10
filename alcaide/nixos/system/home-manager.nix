{
  lib,
  inputs,
  self,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.alcaide.system.home-manager.enable = lib.mkEnableOption "home-manager config";

  config = lib.mkIf config.alcaide.system.home-manager.enable {
    home-manager = {
      extraSpecialArgs = {inherit inputs self;};
      useGlobalPkgs = true;
    };
  };
}
