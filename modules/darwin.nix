{ config, ... }:
{
  imports = [ ./darwin-desktop.nix ];
  programs.zsh.enable = true;
  environment.variables.EDITOR = config.bls.editor.command;
}
