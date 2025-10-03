{
  programs.git = {
    enable = true;
    userName = "Alin Andrei Balasa";
    userEmail = "alin.andrei.balasa@blsalin.dev";
    extraConfig.credential = {
      helper = "manager";
      "https://git.blsalin.dev".username = "BLSAlin";
      credentialStore = "cache";
    };
  };
}
