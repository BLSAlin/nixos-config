{ stdenv, fetchurl, autoPatchelfHook }:
stdenv.mkDerivation rec {
  pname = "idplug-classic";
  version = "450linux"

  src = fetchurl {
    url = "https://hub.mai.gov.ro/cei/info/descarca-middleware?versiune=${version}";
    hash = "sha256-AAA"
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [

  ];

  runtimeDependenciesPath = lib.makeLibraryPath [
    stdenv.cc.cc
  ];

  unpackPhase = true;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./usr/* $out/


    wrapProgram $out/bin/idplugclassic/idplug-uihost \
      --prefix PATH : "$binPath" \
      --prefix LD_LIBRARY_PATH : "$runtimeDependenciesPath" \

    substituteInPlace $out/share/applications/idplugmanager.desktop \
      --replace "/usr/bin/idplugclassic/identitymanager" "identitymanager" \
      --replace "/usr/share/idplugclassic/res/icon.png" "${placeholder "out"}/share/icons"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.idemia.com";
    description = ''IDEMIA's IDplug Classic Software
      This package contains binaries from IDEMIA's IDplug Classic Software
    '';
    platforms = platforms.linux;
    license = licenses.unfree;
    mainProgram = $out/bin/idplugclassic/identitymanager;
  };
}
