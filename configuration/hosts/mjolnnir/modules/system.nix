{user, ...}: {
  system.primaryUser = user;

  system.defaults = {
    controlcenter.BatteryShowPercentage = true;

    dock = {
      mru-spaces = false;
      show-recents = false;
      expose-group-apps = true; # Group windows by application
      persistent-apps = [
        "/System/Applications/Launchpad.app"
        "/Applications/Safari.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Mail.app"
      ];
    };

    finder = {
      FXPreferredViewStyle = "Nlsv";    # Set default view style to list view
      NewWindowTarget = "Home";         # Set default new window target to home folder
      _FXShowPosixPathInTitle = true;   # show full path in finder title
      ShowPathbar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true; # Show all file extensions
      AppleShowAllFiles = true;      # Show hidden files
    };

    screencapture.location = "~/Pictures/screenshots";

    menuExtraClock.ShowSeconds = true;

    trackpad = {
      Clicking = true;
      Dragging = true;
      TrackpadRightClick = true;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      StandardHideDesktopIcons = true;
    };
  };
}