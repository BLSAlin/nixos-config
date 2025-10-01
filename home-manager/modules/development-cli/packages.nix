{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Development
    jdk17
    dotnet-sdk_9

    ripgrep
  ];
}
