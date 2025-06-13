{osConfig, ...}: {
  # Catppuccin system config
  catppuccin = {
    enable = true;
    flavor = "mocha";

    gtk = {
      enable = true;
      flavor = "mocha";
      accent = "sapphire";
      size = "standard";
      tweaks = ["normal"];
      icon.enable = true;
    };

    cursors = {
      inherit (osConfig.catppuccin) flavor;
      enable = true;
      accent = "dark";
    };
  };
}
