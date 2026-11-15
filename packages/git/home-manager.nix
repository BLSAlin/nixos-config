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
              "https://git.blsalin.dev" = {
                username = lib.mkDefault "BLSAlin";
                # Reset the inherited GCM helper for this Forgejo host. Preserve
                # OAuth expiry/refresh metadata in the platform's secure store.
                helper = lib.mkDefault [
                  ""
                  (
                    if pkgs.stdenv.hostPlatform.isDarwin then
                      "${pkgs.git}/bin/git-credential-osxkeychain"
                    else
                      "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret"
                  )
                  "${pkgs.git-credential-oauth}/bin/git-credential-oauth"
                ];
              };
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
