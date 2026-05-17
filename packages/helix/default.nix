{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.helix;
  defaultEditor = config.bls.editor.default;
  hasSessionVariables =
    builtins.hasAttr "environment" options && builtins.hasAttr "sessionVariables" options.environment;
  editorCommand = if defaultEditor == "helix" then "hx" else defaultEditor;
in
{
  options.bls.pkgs.helix.enable = lib.mkOption {
    type = lib.types.bool;
    default = defaultEditor == "helix";
    defaultText = lib.literalExpression ''config.bls.editor.default == "helix"'';
    description = "Enable preferred Helix editor configuration.";
  };

  imports = [
    ./home-manager.nix
  ];

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
    ]
  );
}
