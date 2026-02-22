{pkgs, lib, user, ...}: let
  keyAsString = path: lib.splitString "\n" (builtins.readFile path);
  
  orcHome = "/Users/orc";
  colimaDir = "/Users/orc/colima";

  in {
  users = {
    users.orc = {
      uid = 499;
      gid = 499;
      description = "Trusty docker worker account";

      home = orcHome;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = keyAsString ../../../pub-keys/orc/key.pub;
    };

    groups = {
      servicegroup = {
        gid = 499;
        description = "Group for service accounts.";
        name = "servicegroup";
        members = ["orc", ${user}];
      };
    };

  };

  users.knownUsers = [
    "orc"
  ];

  system.activationScripts.postActivation.text = ''
    echo "Processing 'orc' service user setup..."
    
    # Create the home and working directory if they don't exist
    if [ ! -d "${colimaDir}" ]; then
      mkdir -p "${colimaDir}"
      echo "Created ${colimaDir}"
    fi

    # Ensure correct ownership
    chown -R orc:servicegroup "${orcHome}"
    chmod 700 "${orcHome}"

    # Hide the user from the login screen and Users & Groups UI
    dscl . create /Users/orc IsHidden 1
    
    # Hide the home folder from Finder to keep /Users clean
    chflags hidden "${orcHome}"
  '';

}
