{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  options.alcaide.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.alcaide.style.catppuccin.enable {
    catppuccin = {
      enable = true;
      cache.enable = true;

      accent = "sapphire";
      flavor = "mocha";
    };
  };
}
