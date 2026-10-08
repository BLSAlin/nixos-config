{
  config,
  lib,
  options,
  pkgs,
  user,
  ...
}:
let
  packageSupport = import ../module-support.nix { inherit lib; };

  cfg = config.bls.pkgs.tmux;

  hasHomeManager = packageSupport.hasHomeManager options;
in
{
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs hasHomeManager {
      home-manager.users.${user} = { pkgs, ... }: {
        programs.tmux = {
          enable = lib.mkDefault true;
          prefix = lib.mkDefault "C-Space";
          keyMode = lib.mkDefault "emacs";
          mouse = lib.mkDefault true;
          baseIndex = lib.mkDefault 1;
          clock24 = lib.mkDefault true;
          historyLimit = lib.mkDefault 100000;
          escapeTime = lib.mkDefault 0;
          newSession = lib.mkDefault true;

          plugins = lib.mkDefault (
            with pkgs;
            [
              tmuxPlugins.sensible
              tmuxPlugins.yank
              tmuxPlugins.resurrect
              {
                plugin = tmuxPlugins.continuum;
                extraConfig = "set -g @continuum-save-interval '15'";
              }
            ]
          );

          extraConfig = lib.mkDefault ''
            # Terminal / true color
            set -g default-terminal "tmux-256color"
            set -ga terminal-overrides ",*256col*:Tc"
            set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
            set-environment -g COLORTERM "truecolor"

            # Behavior
            set -g renumber-windows on
            set -g focus-events on
            set -g monitor-activity on
            set -g visual-activity off

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

            # Session switching
            bind Tab choose-tree -s

            # Reload config
            bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

            # Pane status line (top of each pane)
            set -g pane-border-status top
            set -g pane-border-lines heavy
            set -g pane-border-format " #[fg=colour250]#{pane_index}: #{pane_title}"
            set -g pane-border-style "fg=#555555"
            set -g pane-active-border-style "fg=#e5a00d"

            # Status bar
            set -g status-style "bg=#000000,fg=#d4d4d4"
            set -g status-left " #S#{?window_zoomed_flag, [Z],} "
            set -g status-right ""
            set -g window-status-format " #I:#W "
            set -g window-status-current-format " #I:#W "
            set -g window-status-current-style "fg=#000000,bg=#e5a00d,bold"
            set -g window-status-activity-style "fg=#e5a00d,bg=#000000"
          '';
        };
      };
    }
  );
}
