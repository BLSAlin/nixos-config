{pkgs, inputs, ...}: {
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # Utilities
    fastfetch
    git
    wget
    zip
    unzip
    file
    tree
    curl
    rclone
    btop
    htop
    bat

    vim

    # Agenix
    # inputs.agenix.packages."${system}".default
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    powerline-fonts
  ];
}
