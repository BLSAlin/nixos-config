{ pkgs, stateVersion, user, ...}: {

  imports = [
    ./modules/default.nix
    ../../common-darwin-server/configuration.nix
  ];

  programs.zsh.enable = true;

  programs.fish.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };

}