{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.printing;
  hasPrinting = lib.hasAttrByPath [ "services" "printing" "enable" ] options;
  driverPackages = {
    brother = with pkgs; [
      brlaser
      brgenml1lpr
      brgenml1cupswrapper
    ];
    hp = [ pkgs.hplip ];
    epson = [ pkgs.epson-escpr ];
  };
in
{
  options.bls.printing = {
    enable = lib.mkEnableOption "printing support";

    drivers = lib.mkOption {
      type = lib.types.listOf (lib.types.enum [
        "brother"
        "hp"
        "epson"
      ]);
      default = [ ];
      example = [
        "brother"
        "hp"
      ];
      description = "Printer driver families whose packages are installed for CUPS.";
    };
  };

  config = lib.optionalAttrs hasPrinting (lib.mkIf cfg.enable {
    services.printing.enable = lib.mkDefault true;
    services.printing.drivers = lib.concatMap (name: driverPackages.${name}) (lib.unique cfg.drivers);
  });
}
