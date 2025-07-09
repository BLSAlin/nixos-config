{ pkgs, ... }:
{
    imports =
    [
        ./openssh.nix
    ];

    fonts.packages = with pkgs; [
        jetbrains-mono
        font-awesome
        noto-fonts
        noto-fonts-emoji
    ];
}
