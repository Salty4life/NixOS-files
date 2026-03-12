{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.davinci-resolve.enable = lib.mkEnableOption "davinci-resolve config";

  config = lib.mkIf config.alcaide.applications.davinci-resolve.enable {

    home.packages = with pkgs; [
      davinci-resolve
    ];

    # Force X11 mode and set other useful env vars globally for the session
    home.sessionVariables = {
      # Force DaVinci Resolve (Qt) to use X11/XCB instead of Wayland
      QT_QPA_PLATFORM = "xcb";
    };

    # Create a wrapper desktop entry that always launches in X11 mode
    # This overrides the default .desktop file shipped with the package
    xdg.desktopEntries.davinci-resolve = {
      name = "DaVinci Resolve";
      genericName = "Video Editor";
      exec = "env QT_QPA_PLATFORM=xcb davinci-resolve %U";
      icon = "davinci-resolve";
      comment = "Professional video editing, color correction and audio post-production";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
      terminal = false;
      startupNotify = true;
    };

  };
}
