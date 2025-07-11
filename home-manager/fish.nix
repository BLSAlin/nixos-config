{config, ...}: {

  programs.fish = {
    enable = true;
    generateCompletions = true;


    shellAbbrs =
      let
        flakeDir = "~/Projects/nix/nixos-config";
      in {

        nxrb = "sudo nixos-rebuild switch --flake ${flakeDir}";
        update-flake = "nix flake update ${flakeDir}";

        hms = "home-manager switch --flake ${flakeDir}";
#         pkgs = "nvim ${flakeDir}/nixos/packages";

        vim = "nvim"

        ll = "ls -alh";
        ff = "fastfetch";
      };
  };
}
