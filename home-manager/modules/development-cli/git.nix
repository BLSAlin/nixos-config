{
  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "alin.andrei.balasa@blsalin.dev";
        name = "Alin Andrei Balasa";
      };

      credential = {
        helper = "manager";
        "https://git.blsalin.dev".username = "BLSAlin";
        credentialStore = "cache";
      };
    };
  };
}
