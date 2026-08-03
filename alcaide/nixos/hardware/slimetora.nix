{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.alcaide.hardware.slimetora;

  slimetora-app = pkgs.stdenv.mkDerivation rec {
    pname = "slimetora-app";
    version = "1.5.3";

    src = pkgs.fetchurl {
      url = "https://github.com/OCSYT/SlimeTora/releases/download/v${version}/SlimeTora-linux-x64.zip";
      sha256 = "sha256-u6DssNUvnuk53dhflB+lu6vaDOJSvL1Z3hbw0USgNp0=";
    };

    nativeBuildInputs = with pkgs; [
      unzip
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
      addDriverRunpath
      asar
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
        stdenv.cc.cc.lib
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

    autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

    sourceRoot = ".";

    installPhase = ''
            runHook preInstall
            mkdir -p $out/opt/slimetora
            cp -r ./build/SlimeTora-linux-x64/* $out/opt/slimetora/
            chmod -R u+w $out/opt/slimetora
            chmod +x $out/opt/slimetora/SlimeTora

            asar extract $out/opt/slimetora/resources/app.asar $out/opt/slimetora/resources/app
            rm $out/opt/slimetora/resources/app.asar

            # placeholder mount points for the bwrap binds in the `slimetora` wrapper
            touch $out/opt/slimetora/config.json
            mkdir -p $out/opt/slimetora/logs
            
            # Wrapped copy carries the gapps env (GTK theme/icon/schema vars)
            # and --no-sandbox. Kept separate from bin/ on purpose: the outer
            # bwrap script (below) is the thing users actually run.
            makeWrapper $out/opt/slimetora/SlimeTora $out/opt/slimetora/.slimetora-wrapped \
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

    postFixup = ''
      addDriverRunpath $out/opt/slimetora/SlimeTora
    '';

    meta = with lib; {
      description = "Connects HaritoraX trackers to the SlimeVR server";
      homepage = "https://github.com/OCSYT/SlimeTora";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };

  slimetora = pkgs.writeShellScriptBin "slimetora" ''
    STATE_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/slimetora"
    mkdir -p "$STATE_DIR/logs"
    touch "$STATE_DIR/config.json"
    exec ${pkgs.bubblewrap}/bin/bwrap \
      --dev-bind / / \
      --bind "$STATE_DIR/config.json" "${slimetora-app}/opt/slimetora/config.json" \
      --bind "$STATE_DIR/logs" "${slimetora-app}/opt/slimetora/logs" \
      "${slimetora-app}/opt/slimetora/.slimetora-wrapped" "$@"
  '';
in
{
  options.alcaide.hardware.slimetora = {
    enable = lib.mkEnableOption "SlimeTora bridge for HaritoraX full-body trackers";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: { inherit slimetora slimetora-app; })
    ];

    environment.systemPackages = [
      slimetora
      slimetora-app # provides the .desktop entry
      pkgs.slimevr
    ];

    networking.firewall.allowedUDPPorts = [ 6969 ];

    services.udev.packages = [ pkgs.slimevr ];

    services.udev.extraRules = ''
      SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", GROUP="dialout", MODE="0660"
      SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", GROUP="dialout", MODE="0660"
    '';
  };
}
