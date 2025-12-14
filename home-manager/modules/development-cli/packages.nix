{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };


  home.packages = with pkgs; [
    # Development
    jdk17
    dotnet-sdk_9

    git-credential-manager

    ripgrep
  ];
}
