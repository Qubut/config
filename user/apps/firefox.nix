{pkgs, nixpkgs-unstable, ...}:
{
  programs.firefox = {
    enable = true;
    pkgs = nixpkgs-unstable.firefox;
  };
}
