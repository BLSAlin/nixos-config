{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  home.packages = with pkgs; [
    # Development
    jdk17
    dotnet-sdk_9

    git-credential-manager

    ripgrep

    ruby
    ruby-lsp
    gcc
    gnumake
    bazel
    autoconf
    coreutils
    parallel
    watchman
  ];
}
