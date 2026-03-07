{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 50000;
    escapeTime = 0;
    newSession = true;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-save-interval '15'";
      }
    ];

    extraConfig = ''
      # Terminal / true color
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Splits in current path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Reorder windows
      bind -n S-Left swap-window -t -1\; select-window -t -1
      bind -n S-Right swap-window -t +1\; select-window -t +1

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # Status bar
      set -g status-style "bg=#000000,fg=#d4d4d4"
      set -g status-left " #S "
      set -g status-right ""
      set -g window-status-format " #I:#W "
      set -g window-status-current-format " #I:#W "
      set -g window-status-current-style "fg=#000000,bg=#e5a00d,bold"
    '';
  };
}
