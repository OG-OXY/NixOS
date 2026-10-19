{
 ...
}:
{
  flake.nixosModules.xdg-data-dirs = { pkgs, ... }:
  let
    # Define your user name and HDD path for convenience
    userName = "ty";
    hddPath = "/home/${userName}/HDD";
  
    # Create a generated user-dirs.dirs file content or write it out
    userDirsFile = pkgs.writeText "xdg-data-dirs.conf" ''
      XDG_DOWNLOAD_DIR="${hddPath}/Downloads"
      XDG_DOCUMENTS_DIR="${hddPath}/Documents"
      XDG_PICTURES_DIR="${hddPath}/Pictures"
      XDG_VIDEOS_DIR="${hddPath}/Videos"
    '';
    
    # If you end up wanting desktop, music dirs in the future add these lines after videos above.
    #XDG_MUSIC_DIR="${hddPath}/Music"
    #XDG_DESKTOP_DIR="${hddPath}/Desktop"
  in
  {
    # 1. Systemd tmpfiles to handle both the .config file and the directory symlinks
    systemd.tmpfiles.rules = [
      # Ensure the .config directory exists for the user
      "d /home/${userName}/.config 0755 ${userName} users -"

      # Link the user-dirs.dirs file into place (L+ forces overwrite if it exists)
      "L+ /home/${userName}/.config/user-dirs.dirs - - - - ${userDirsFile}"

      # Symlink your main user directories from home straight to your 2TB HDD
      "L+ /home/${userName}/Downloads - - - - ${hddPath}/Downloads"
      "L+ /home/${userName}/Documents - - - - ${hddPath}/Documents"
      "L+ /home/${userName}/Pictures  - - - - ${hddPath}/Pictures"
      "L+ /home/${userName}/Videos    - - - - ${hddPath}/Videos"
      #"L+ /home/${userName}/Music     - - - - ${hddPath}/Music"
      #"L+ /home/${userName}/Desktop   - - - - ${hddPath}/Desktop"
    ];

    # 2. Ensure environment variables are set globally so apps know where they are
    environment.sessionVariables = {
      XDG_DOWNLOAD_DIR = "${hddPath}/Downloads";
      XDG_DOCUMENTS_DIR = "${hddPath}/Documents";
      XDG_PICTURES_DIR = "${hddPath}/Pictures";
      XDG_VIDEOS_DIR = "${hddPath}/Videos";
      #XDG_MUSIC_DIR = "${hddPath}/Music";
      #XDG_DESKTOP_DIR = "${hddPath}/Desktop";
    };
  };
}
