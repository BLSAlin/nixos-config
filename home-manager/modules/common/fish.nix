{lib, ...}: {

  programs.fish = {
    enable = true;
    generateCompletions = true;

    interactiveShellInit = ''
      set fish_greeting
      fish_default_key_bindings
    '';

    shellAbbrs =
      let
        flakeDir = "~/Projects/nix/nixos-config";
      in {
        # Nix
        ns = "sudo nixos-rebuild switch --flake ${flakeDir}";
        nfu = "nix flake update ${flakeDir}";
        hms = "home-manager switch --flake ${flakeDir}";

        # Git
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gpl = "git pull";
        gd = "git diff";
        gl = "git log --oneline --graph";
        gco = "git checkout";
        gb = "git branch";
        gst = "git stash";

        # Tool replacements
        vim = "nvim";
        grep = "rg";
        cat = "bat";

        # General
        ll = "ls -alh";
        ff = "fastfetch";
      };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [ "--layout=reverse" ];
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault "nvim";
    VISUAL = lib.mkDefault "nvim";
  };
}
