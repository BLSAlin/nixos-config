{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  cfg = config.bls.pkgs.git;

  hasHomeManager =
    builtins.hasAttr "home-manager" options && builtins.hasAttr "users" options."home-manager";
in
{
  options.bls.pkgs.git.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable preferred git configuration.";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.git = {
          enable = cfg.enable;
        };

        environment.systemPackages = with pkgs; [
          git-credential-manager
        ];
      }

      (lib.optionalAttrs hasHomeManager {
        home-manager.users.${user} = {
          programs.git = {
            enable = cfg.enable;

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

        };
      })
    ]
  );
}
