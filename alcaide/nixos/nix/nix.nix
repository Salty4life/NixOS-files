{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.nix.nix.enable = lib.mkEnableOption "nix config";

  config = lib.mkIf config.alcaide.nix.nix.enable {
    nix.settings.experimental-features = "nix-command flakes pipe-operators";
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
