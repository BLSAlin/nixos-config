{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.bls.pkgs.hardware.dslrCamera;
  hasNixosCameraOptions = lib.hasAttrByPath [ "boot" "extraModulePackages" ] options;
  startWebcam = pkgs.writeShellScriptBin "start-webcam" ''
    systemctl restart webcam
  '';
in
{
  options.bls.pkgs.hardware.dslrCamera = {
    enable = lib.mkEnableOption "DSLR camera webcam service";

    videoDevice = lib.mkOption {
      type = lib.types.str;
      default = "/dev/video0";
      description = "Video device written by the DSLR webcam service.";
    };

    usbVendorId = lib.mkOption {
      type = lib.types.strMatching "[0-9a-fA-F]{4}";
      description = "Four-digit USB vendor ID that starts the webcam service.";
    };

    usbProductId = lib.mkOption {
      type = lib.types.strMatching "[0-9a-fA-F]{4}";
      description = "Four-digit USB product ID that starts the webcam service.";
    };
  };

  config = lib.optionalAttrs hasNixosCameraOptions (lib.mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];

    boot.kernelModules = [
      "v4l2loopback"
    ];

    boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 max_buffers=2 card_label="DSLR Camera"
    '';

    environment.systemPackages =
      with pkgs;
      lib.mkOrder 700 [
        gphoto2
        ffmpeg
      ];

    systemd.services.webcam = {
      enable = true;
      script = ''
        ${pkgs.gphoto2}/bin/gphoto2 --stdout --capture-movie |
        ${pkgs.ffmpeg}/bin/ffmpeg -i - \
            -vcodec rawvideo -pix_fmt yuv420p -f v4l2 ${cfg.videoDevice}
      '';
    };

    services.udev.extraRules = ''
      ACTION=="add",  \
      SUBSYSTEM=="usb", \
      ATTR{idVendor}=="${cfg.usbVendorId}", \
      ATTR{idProduct}=="${cfg.usbProductId}",  \
      RUN+="${startWebcam}/bin/start-webcam"
    '';
  });
}
