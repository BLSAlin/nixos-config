{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.hardware.amdGpu;
  hasAmdGpu = lib.hasAttrByPath [ "hardware" "amdgpu" "opencl" "enable" ] options;
in
{
  options.bls.pkgs.hardware.amdGpu.enable = lib.mkEnableOption "AMD GPU OpenCL and ROCm tools";

  config = lib.optionalAttrs hasAmdGpu (lib.mkIf cfg.enable {
    nixpkgs.config.rocmSupport = true;
    hardware.amdgpu.opencl.enable = lib.mkDefault true;

    environment.systemPackages =
      with pkgs;
      lib.mkOrder 852 [
        rocmPackages.amdsmi
        rocmPackages.rocm-smi
      ];
  });
}
