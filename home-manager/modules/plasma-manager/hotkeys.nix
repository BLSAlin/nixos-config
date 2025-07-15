{
  programs.plasma = {
    krunner = {
      position = "center";
      launch = "Meta+Space";
    };

    spectacle.shortcuts.captureRectangularRegion = "Meta+Shift+S";
    spectacle.shortcuts.launch = "Print";

    desktop.mouseActions.middleClick = "paste";

    shortcuts = {
      "services/systemsettings.desktop"."_launch" = ["Tools" "Meta+I"];
    };
  };
}
