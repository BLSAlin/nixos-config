{pkgs, inputs, ...}: {
   programs.neovim = {
     enable = true;
     viAlias = true;
     vimAlias = true;
     defaultEditor = true;
   };

   environment.systemPackages = with pkgs; [
    cifs-utils
   ]
}