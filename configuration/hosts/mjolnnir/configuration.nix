{stateVersion, user, ...}: {

  imports = [
    ./modules/default.nix
    ../../common/configuration.nix
  ];

  programs.zsh.enable = true;

  # This needs to be added here as well because of how nix-darwin deals with default shells
  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.variables = {
    EDITOR = "nvim";
  };
}