{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.alcaide.applications.vscodium.enable {
    home.packages = with pkgs; [
      nixfmt
    ];
    programs.vscode.profiles.default = {
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        jnoortheen.nix-ide
      ];

      userSettings = {
        "nix.enableLanguageServer" = true;

        "nix.hiddenLanguageServerErrors" = [
          "textDocument/codeAction"
          "textDocument/completion"
          "textDocument/definition"
          "textDocument/documentHighlight"
          "textDocument/documentLink"
          "textDocument/documentSymbol"
          "textDocument/hover"
          "textDocument/inlayHint"
        ];

        "nix.serverPath" = "${lib.getExe pkgs.nixd}";

        "nix.serverSettings.nixd.formatting.command" = [
          "${lib.getExe pkgs.nixfmt-rfc-style}"
        ];

        "nix.serverSettings.nixd.options.nixos.expr" =
          "(builtins.getFlake \"${config.programs.nh.flake}\").nixosConfigurations.<name>.options";
      };
    };
  };
}
