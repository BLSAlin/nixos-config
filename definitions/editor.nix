{ config, lib, ... }:
{
  options.bls.editor = {
    default = lib.mkOption {
      type = lib.types.str;
      default = "helix";
      description = "Default editor preference.";
    };

    choices = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.command = lib.mkOption {
            type = lib.types.str;
            description = "Command used when this editor is selected.";
          };
        }
      );
      default = {
        helix.command = "hx";
      };
      description = "Known editor choices and their command names.";
    };

    command = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = config.bls.editor.choices.${config.bls.editor.default}.command;
      defaultText = lib.literalExpression ''
        config.bls.editor.choices.${config.bls.editor.default}.command
      '';
      description = "Resolved command for the selected default editor.";
    };
  };
}
