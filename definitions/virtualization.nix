{
  config,
  lib,
  options,
  ...
}:
let
  hasVirtualizationOptions =
    lib.hasAttrByPath [ "virtualisation" "libvirtd" "enable" ] options
    && lib.hasAttrByPath [ "programs" "virt-manager" "enable" ] options;
in
{
  options.bls.virtualization.enabled = lib.mkEnableOption "libvirtd and virt-manager";

  config = lib.optionalAttrs hasVirtualizationOptions (
    lib.mkIf config.bls.virtualization.enabled {
      virtualisation.libvirtd.enable = lib.mkDefault true;
      programs.virt-manager.enable = lib.mkDefault true;
    }
  );
}
