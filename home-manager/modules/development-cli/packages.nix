{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 5000;

    newSession = true;

    mouse = true;

    keyMode = "vi";

    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
    '';

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
  };

  home.packages = with pkgs; [
    # Development
    jdk17
    dotnet-sdk_9

    git-credential-manager

    ripgrep
  ];
}
