{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  cfg = config.bls.pkgs.helix;
  defaultEditor = config.bls.editor.default;
  helixSettings = {
    theme = "ayu_evolve";
  };
  helixLanguages = {
    language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
  };
  hasSessionVariables =
    builtins.hasAttr "environment" options && builtins.hasAttr "sessionVariables" options.environment;
  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";
  editorCommand = if defaultEditor == "helix" then "hx" else defaultEditor;
in
{
  options.bls.pkgs.helix.enable = lib.mkOption {
    type = lib.types.bool;
    default = defaultEditor == "helix";
    defaultText = lib.literalExpression ''config.bls.editor.default == "helix"'';
    description = "Enable preferred Helix editor configuration.";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          pkgs.helix
        ];
      }

      (lib.mkIf (defaultEditor == "helix") {
        environment =
          if hasSessionVariables then
            {
              sessionVariables = {
                EDITOR = lib.mkOverride 900 editorCommand;
                VISUAL = lib.mkOverride 900 editorCommand;
              };
            }
          else
            {
              variables = {
                EDITOR = lib.mkOverride 900 editorCommand;
                VISUAL = lib.mkOverride 900 editorCommand;
              };
            };
      })

      (lib.optionalAttrs hasHomeManager {
        home-manager.users.${user}.programs.helix = {
          enable = lib.mkDefault true;
          settings = lib.mkDefault helixSettings;
          languages.language = lib.mkDefault [
            {
              name = "nix";
              auto-format = true;
              formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
            }
          ];
        };
      })
    ]
  );
}
