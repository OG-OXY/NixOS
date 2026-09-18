{ pkgs, ... }: {
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_22;
    pnpm.enable = true;
  };

  packages = [
  ];

  enterShell = ''
    echo "🚀 Mom's business dev environment active!"
    pnpm --version
  '';
}
