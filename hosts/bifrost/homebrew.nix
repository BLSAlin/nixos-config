{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    casks = [
      "macfuse"

      "microsoft-office"
      "rectangle"
      "ghostty"

      "jellyfin"
    ];

    brews = [
      "ffmpeg"
    ];
  };
}
