{
  ...
}:
{
  flake.nixosModules.security = { ... }:
  {
    security = {
      polkit.enable = true;
      rtkit.enable = true;
      doas = {
        enable = true;
        extraRules = [
          {
            users = [ "ty" ];
            noPass = true;
            keepEnv = true;
          }
        ];
      };
      sudo = {
        enable = true;
        extraRules = [
          {
            groups = [ "wheel" ];
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
      pam.services = {
        login = {
          #enableGnomeKeyring = false;
          enableKwallet = false;
        };
      };
    };
  };
}
