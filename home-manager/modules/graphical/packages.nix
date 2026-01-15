{pkgs, ...}: let
    extraLinuxPackages = with pkgs; [
      # Utilities
      obs-studio
      ptyxis

      # Browsers
      microsoft-edge
      ungoogled-chromium
    ];

    extraDarwinPackages = with pkgs; [

    ];

    extraPackages = if pkgs.stdenv.isLinux then extraLinuxPackages else extraDarwinPackages;
  in {
    nixpkgs.config.allowUnfree = true;
    services.kdeconnect.enable = if pkgs.stdenv.isLinux then true else false;

    programs.vscode = {
      enable = true;

      # profiles.default = {
      #     enableUpdateCheck = false;
      #     enableExtensionUpdateCheck = false;

      #     userSettings = {
      #       "workbench.colorTheme" = "Pitch Black";
      #       "editor.fontFamily" = "JetBrains Mono";
      #       "editor.fontSize" = 14;
      #       "geminicodeassist.project"= "northern-bonbon-t3m6w";
      #     };

      #     extensions = with pkgs; [
      #       vscode-extensions.ms-vscode-remote.remote-ssh
      #       vscode-extensions.ms-vscode-remote.remote-ssh-edit
      #     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #       {
      #         name = "vscode-pitch-black-theme";
      #         publisher = "viktorqvarfordt";
      #         version = "1.3.0";
      #         sha256 = "1JDm/cWNWwxa1gNsHIM/DIvqjXsO++hAf0mkjvKyi4g=";
      #       }
      #       {
      #         name = "geminicodeassist";
      #         publisher = "google";
      #         version = "2.59.0";
      #         sha256 = "MF6w8DSOzWXFSk1GWouTWj+8/BwwyhkTzrNXI0eSNKQ=";
      #       }
      #     ];

      # };
    };

    home.packages = with pkgs; [
      # Development tools
      jetbrains.idea-ultimate
      jetbrains.rider

      #Entertaiment
      spotify
      # jellyfin-media-player # Disabled because of CVE on qt5 qtwebengine
      zotero

      brave
    ] ++ extraPackages;
}
