{
  imports = [
    ./sound.nix
    ./users.nix
    ./networking.nix
    ./virtmanager.nix
    ./openssh.nix
    ./printing.nix
    ./xone.nix
    ./smb-drive.nix

    # Hardware fixes
    ./amdgpu-hardware-fix.nix

    # Services
    ./jellyfin-service.nix
  ];
}
