{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.alcaide.hardware.slimetora;

  slimetora = pkgs.stdenv.mkDerivation rec {
    pname = "slimetora";
    version = "1.5.3"; # check https://github.com/OCSYT/SlimeTora/releases for latest

    src = pkgs.fetchurl {
      # TODO: confirm exact Linux asset filename on the releases page and update this
      url = "https://github.com/OCSYT/SlimeTora/releases/download/v${version}/SlimeTora-linux-x64.zip";
      sha256 = "sha256-u6DssNUvnuk53dhflB+lu6vaDOJSvL1Z3hbw0USgNp0="; # `nixos-rebuild switch` will print the real one on first build
    };

    nativeBuildInputs = with pkgs; [
      unzip
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
    ];

    buildInputs =
      with pkgs;
      [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        expat
        gdk-pixbuf
        glib
        gtk3
        libdrm
        libGL
        libnotify
        libsecret
        libxkbcommon
        mesa
        nspr
        nss
        pango
        systemd
      ]
      ++ (with pkgs.xorg; [
        libX11
        libXcomposite
        libXdamage
        libXext
        libXfixes
        libXrandr
        libxcb
        libXtst
        libxshmfence
      ]);

    sourceRoot = ".";

    installPhase = ''
            runHook preInstall
            mkdir -p $out/opt/slimetora $out/bin
            cp -r ./build/SlimeTora-linux-x64/* $out/opt/slimetora/
            chmod +x $out/opt/slimetora/SlimeTora
            makeWrapper $out/opt/slimetora/SlimeTora $out/bin/slimetora \
              --add-flags "--no-sandbox"

            install -Dm644 /dev/stdin $out/share/applications/slimetora.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=SlimeTora
      Comment=Bridge HaritoraX trackers to SlimeVR server
      Exec=slimetora
      Icon=slimetora
      Categories=Utility;
      EOF
            runHook postInstall
    '';

    meta = with lib; {
      description = "Connects HaritoraX trackers to the SlimeVR server";
      homepage = "https://github.com/OCSYT/SlimeTora";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "slimetora";
    };
  };
in
{
  options.alcaide.hardware.slimetora = {
    enable = lib.mkEnableOption "SlimeTora bridge for HaritoraX full-body trackers";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      slimetora
      pkgs.slimevr-server # already in nixpkgs, needed as the receiving server
    ];

    # users.users.salty.extraGroups = [ "dialout" ]; # for GX(6/2) dongle serial access

    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", GROUP="dialout", MODE="0660"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", GROUP="dialout", MODE="0660"
    '';
  };
}
