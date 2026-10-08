{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  home.packages =
    with pkgs;
    lib.mkMerge [
      (lib.mkOrder 630 [
        jdk17
        dotnet-sdk_9
      ])
      (lib.mkOrder 640 [
        # Development

        ripgrep

        ruby
        ruby-lsp
        gcc
        gnumake
        bazel
        autoconf
        coreutils
        parallel
        watchman

        claude-code
        codex
        python3
        uv

        inputs.ticket.packages.${pkgs.stdenv.hostPlatform.system}.ticket

        librepods
      ])
    ];
}
