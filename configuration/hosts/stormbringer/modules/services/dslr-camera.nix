{ pkgs, config, ... }: 
let
  startWebcam = pkgs.writeShellScriptBin "start-webcam" ''
    systemctl restart webcam
  '';
in 
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];

  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 max_buffers=2 card_label="DSLR Camera"
  '';

  environment.systemPackages = with pkgs; [
    gphoto2
    ffmpeg
  ];

  systemd.services.webcam = {
    enable = true;
    script = ''
        ${pkgs.gphoto2}/bin/gphoto2 --stdout --capture-movie |
        ${pkgs.ffmpeg}/bin/ffmpeg -i - \
            -vcodec rawvideo -pix_fmt yuv420p -f v4l2 /dev/video0
    '';
  };

  services.udev.extraRules = ''
    ACTION=="add",  \
    SUBSYSTEM=="usb", \
    ATTR{idVendor}=="04a9", \
    ATTR{idProduct}=="32d9",  \
    RUN+="${startWebcam}/bin/start-webcam"
  '';
}