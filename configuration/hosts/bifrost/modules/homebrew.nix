{ pkgs, ... }: {
  homebrew = {
    enable = true;
    casks = [
      "macfuse"

      "microsoft-office"
      "rectangle"
      "ghostty"

      "jellyfin"
    ];
}
