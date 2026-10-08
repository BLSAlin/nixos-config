{ lib, home-manager }:
system:
let
  c = system.config;
  linux = system.pkgs.stdenv.hostPlatform.isLinux;
  # Hidden options include removed compatibility aliases whose apply functions throw.
  project =
    opts: value:
    if lib.isOption opts then
      value
    else if builtins.isAttrs value then
      lib.mapAttrs (name: v: project (opts.${name} or { }) v) (
        lib.filterAttrs (
          name: _: (opts.${name}.visible or true) != false && (opts.${name}.isDefined or true)
        ) value
      )
    else
      value;
  selectWith =
    opts: paths: value:
    lib.genAttrs paths (
      path:
      project (lib.attrByPath (lib.splitString "." path) { } opts) (
        lib.attrByPath (lib.splitString "." path) null value
      )
    );
  select = selectWith system.options;
  homeOptions =
    (home-manager.lib.homeManagerConfiguration {
      pkgs = system.pkgs;
      modules = [
        {
          home = {
            username = "alin";
            homeDirectory = if linux then "/home/alin" else "/Users/alin";
            stateVersion = c.home-manager.users.alin.home.stateVersion;
          };
        }
      ];
    }).options;
  packages = map (p: {
    derivation = p.drvPath;
    output = toString p;
    priority = p.meta.priority or 5;
    outputsToInstall = p.meta.outputsToInstall or null;
  });
  clean =
    value:
    if lib.isDerivation value then
      {
        derivation = value.drvPath;
        output = toString value;
      }
    else if builtins.isPath value then
      toString value
    else if builtins.isFunction value then
      "<function>"
    else if builtins.isAttrs value then
      lib.mapAttrs (_: clean) (removeAttrs value [ "_module" ])
    else if builtins.isList value then
      map clean value
    else
      value;
  files =
    fs:
    lib.mapAttrs (name: v: {
      inherit (v)
        target
        text
        executable
        recursive
        onChange
        force
        ;
      # The only relocated literal user file; generated sources retain their identities.
      source =
        if lib.hasSuffix "starship.toml" name then builtins.readFile v.source else toString v.source;
    }) fs;
in
clean {
  systemDerivation = c.system.build.toplevel.drvPath;
  system = select [
    "system.stateVersion"
    "networking.hostName"
    "time.timeZone"
    "nix.settings"
    "environment.variables"
    "environment.sessionVariables"
    "environment.shells"
    "nixpkgs.config"
  ] c;
  systemPackages = packages c.environment.systemPackages;
  fonts = packages c.fonts.packages;
  users = lib.mapAttrs (
    _:
    select [
      "name"
      "uid"
      "gid"
      "group"
      "extraGroups"
      "description"
      "home"
      "shell"
      "isNormalUser"
      "isSystemUser"
      "openssh.authorizedKeys.keys"
    ]
  ) c.users.users;
  groups = c.users.groups;
  knownUsers = c.users.knownUsers or null;
  home = lib.mapAttrs (_: h: {
    activationDerivation = h.home.activationPackage.drvPath;
    settings = selectWith homeOptions [
      "home.username"
      "home.homeDirectory"
      "home.stateVersion"
      "home.sessionVariables"
      "home.sessionPath"
      "programs.fish"
      "programs.fzf"
      "programs.git.enable"
      "programs.git.package"
      "programs.git.settings"
      "programs.tmux"
      "programs.helix"
      "programs.direnv.enable"
      "programs.direnv.nix-direnv.enable"
      "programs.direnv.enableFishIntegration"
      "programs.starship"
      "programs.firefox.enable"
      "programs.firefox.package"
      "programs.firefox.configPath"
      "programs.firefox.policies"
      "programs.firefox.profiles"
      "programs.vscode.enable"
      "programs.vscode.package"
      "programs.vscode.profiles"
      "services.kdeconnect.enable"
    ] h;
    packages = packages h.home.packages;
    files = files h.home.file;
    activation = lib.mapAttrs (_: entry: entry.data) h.home.activation;
    systemd = if linux then h.systemd.user else null;
    launchd = if linux then null else h.launchd;
  }) c.home-manager.users;
  linux = lib.optionalAttrs linux {
    settings = select [
      "boot.loader.systemd-boot"
      "boot.loader.efi"
      "boot.loader.grub.enable"
      "boot.initrd.availableKernelModules"
      "boot.initrd.kernelModules"
      "boot.kernelModules"
      "boot.extraModulePackages"
      "boot.extraModprobeConfig"
      "fileSystems"
      "i18n"
      "networking.hostName"
      "networking.domain"
      "networking.networkmanager"
      "networking.firewall"
      "networking.nameservers"
      "networking.hosts"
      "networking.useDHCP"
      "security.wrappers"
      "hardware.bluetooth"
      "hardware.amdgpu"
      "hardware.xone"
      "hardware.cpu.amd"
      "services.openssh"
      "services.avahi"
      "services.printing"
      "services.pipewire"
      "services.pulseaudio"
      "services.blueman"
      "services.flatpak"
      "services.udev.extraRules"
      "services.displayManager"
      "services.desktopManager"
      "services.xserver.enable"
      "services.jellyfin"
      "services.sunshine"
      "programs.steam"
      "programs.gamemode"
      "programs.gamescope"
      "programs.nix-ld"
      "programs.virt-manager"
      "virtualisation.libvirtd"
    ] c;
    kernel = c.boot.kernelPackages.kernel.drvPath;
    swap = map (select [
      "device"
      "size"
      "priority"
      "options"
      "randomEncryption"
    ]) c.swapDevices;
    interfaces = lib.mapAttrs (
      _:
      select [
        "name"
        "useDHCP"
        "ipv4"
        "ipv6"
        "wakeOnLan"
        "mtu"
        "macAddress"
        "tempAddress"
        "virtual"
      ]
    ) c.networking.interfaces;
    services = lib.mapAttrs (
      _:
      select [
        "enable"
        "script"
        "preStart"
        "postStart"
        "preStop"
        "postStop"
        "reload"
        "serviceConfig"
        "unitConfig"
        "wantedBy"
        "requiredBy"
        "after"
        "before"
        "wants"
        "requires"
        "environment"
        "path"
        "restartTriggers"
        "reloadTriggers"
      ]
    ) c.systemd.services;
    units = lib.mapAttrs (_: u: u.text) c.systemd.units;
    activation = c.system.activationScripts;
    etc = lib.mapAttrs (_: e: {
      inherit (e)
        text
        source
        mode
        user
        group
        ;
    }) c.environment.etc;
  };
  darwin = lib.optionalAttrs (!linux) {
    settings = select [
      "system.defaults.dock"
      "system.defaults.finder"
      "system.defaults.NSGlobalDomain"
      "system.defaults.screencapture"
      "system.defaults.menuExtraClock"
      "system.defaults.trackpad"
      "system.defaults.WindowManager"
      "system.defaults.controlcenter"
      "system.primaryUser"
      "homebrew.enable"
      "homebrew.brews"
      "homebrew.casks"
      "homebrew.taps"
      "homebrew.masApps"
      "homebrew.onActivation"
      "homebrew.global"
      "homebrew.prefix"
      "homebrew.enableFishIntegration"
      "nix-homebrew"
      "security.pam.services"
      "launchd.daemons"
      "launchd.agents"
      "system.activationScripts"
    ] c;
  };
}
