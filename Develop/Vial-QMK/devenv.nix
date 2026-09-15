{ 
  pkgs,
  ...
}:
{
  packages = [
    pkgs.git
    pkgs.gnumake
    pkgs.qmk
    pkgs.dfu-util
    pkgs.avrdude
    pkgs.gcc-arm-embedded
  ];

  env.QMK_HOME = "$PWD/Vial-QMK";

  enterShell = ''
    echo "⚡ QMK Development Environment Loaded ⚡"
  '';
}
