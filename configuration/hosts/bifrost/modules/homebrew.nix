{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "macfuse"

      "microsoft-office"
      "rectangle"
      "ghostty"

      "ffmpeg"
      "jellyfin"
    ];
  };
}
