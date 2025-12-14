{pkgs, ...}: {
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableAccounts = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisplayBookmarksToolbar = "newtab";
      SearchBar = "unified";

      Preferences = {
        "browser.profiles.enabled" = "true";

        "extensions.pocket.enable" = "lock-false";
        "extensions.screenshots.disable" = "lock-true";
        "browser.formfill.enable" = "lock-false";
        "browser.search.suggest.enabled" = "true";
        "browser.search.suggest.enabled.private" = "true";
        "browser.urlbar.suggest.searches" = "true";
        "browser.urlbar.showSearchSuggestionsFirst" = "false";


        "browser.newtabpage.activity-stream.feeds.section.topstories" = "lock-false";
        "browser.newtabpage.activity-stream.feeds.snippets" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = "lock-false";
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = "lock-false";
        "browser.newtabpage.activity-stream.showSponsored" = "lock-false";
        "browser.newtabpage.activity-stream.system.showSponsored" = "lock-false";
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = "lock-false";


        "browser.startup.homepage" = "about:home";
        "browser.search.defaultenginename" = "BLS Search";
        "browser.search.order.1" = "BLS Search";

        "browser.contextual-password-manager-enabled" = false;
      };

      SearchEngines = {
        Add = [
          {
            Alias = "@np";
            Description = "Search in NixOS Packages";
            IconURL = "https://nixos.org/favicon.png";
            Method = "GET";
            Name = "NixOS Packages";
            URLTemplate = "https://search.nixos.org/packages?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
          }
          {
            Alias = "@no";
            Description = "Search in NixOS Packages";
            IconURL = "https://nixos.org/favicon.png";
            Method = "GET";
            Name = "NixOS Options";
            URLTemplate = "https://search.nixos.org/options?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
          }
          {
            Alias = "@bls";
            Description = "Search using BLS Search";
            Method = "GET";
            Name = "BLS Search";
            URLTemplate = "https://search.blsalin.dev/?q={searchTerms}";
          }
        ];
        Default = "BLS Search";
        DefaultPrivate = "BLS Search";
      };

      ExtensionSettings = {
        # https://addons.mozilla.org/firefox/downloads/latest/ADDON_NAME/addon-ADDON_ACCOUNT_ID-latest.xpi
#       Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/addon-12533945-latest.xpi";
          default_area = "menu_panel";
        };

#       UBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-11423598-latest.xpi";
        };


#       Return YouTube Dislikes
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/addon-17129231-latest.xpi";
        };
      };

    };
  };
}
