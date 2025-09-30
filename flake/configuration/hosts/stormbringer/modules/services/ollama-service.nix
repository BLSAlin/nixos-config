{pkgs, lib, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = false;
    user = "ollama";
    group = "ollama";

    package = pkgs.ollama-rocm.override {
    	acceleration = "rocm";	
    };
  };

  services.open-webui = {
    enable = true;
    openFirewall = true;
    environment = {
      ENABLE_OAUTH_SIGNUP = "true";
      OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
      OAUTH_UPDATE_PICTURE_ON_LOGIN = "true";
    };
    host = "0.0.0.0";
    environmentFile = ../../../../secrets/open-webui.env;
  };
}
