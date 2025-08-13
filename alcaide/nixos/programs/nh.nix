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
        home-manager.sharedModules = lib.singleton (
      { config, osConfig, ... }:
      {programs.nh = {
          enable = true;
          package = lib.mkDefault osConfig.programs.nh.package;
          flake = "${config.home.homeDirectory}/nix-files";
        };
  }
  );
  };
  }

