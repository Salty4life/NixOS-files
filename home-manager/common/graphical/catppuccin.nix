{
  osConfig,
  #inputs,
  #pkgs,
  ...
}: {
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

  #catppuccinStylusSettings = inputs.catppuccin-userstyles-nix.stylusSettings.${pkgs.system} {
  #global userstyle settings
  # global = {
  #  lightFlavor = "latte";
  # darkFlavor = "mocha";
  #accentColor = "red";
  #};

  # per-userstyle settings
  #    "Userstyle GitHub Catppuccin" = {
  #     darkFlavor = "frappe";
  #    accentColor = "mauve";
  # };
  #};
}
