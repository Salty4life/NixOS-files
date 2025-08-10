{
  config,
  osConfig,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  options.alcaide.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.alcaide.style.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;
      cursors = {
        inherit (osConfig.catppuccin) flavor;
        enable = true;
        accent = "dark";
      };
    };
  };
}
