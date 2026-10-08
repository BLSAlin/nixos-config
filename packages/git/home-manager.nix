{
  config,
  lib,
  options,
  user,
  ...
}:
let
  support = import ../module-support.nix { inherit lib; };
in
{
  config = lib.mkIf config.bls.pkgs.git.enable (
    lib.optionalAttrs (support.hasHomeManager options) {
      home-manager.users.${user} = { pkgs, ... }: {
        programs.git = {
          enable = lib.mkDefault true;
          settings = {
            user = {
              email = lib.mkDefault "alin.andrei.balasa@blsalin.dev";
              name = lib.mkDefault "Alin Andrei Balasa";
            };
            credential = {
              "https://git.blsalin.dev".username = lib.mkDefault "BLSAlin";
              helper = lib.mkDefault "manager";
              credentialStore = lib.mkDefault "secretservice";
            };
          };
        };
        home.packages =
          with pkgs;
          lib.mkMerge [
            (lib.mkOrder 620 [
              gh
              forgejo-cli
            ])
            (lib.mkOrder 635 [ git-credential-manager ])
          ];
      };
    }
  );
}
