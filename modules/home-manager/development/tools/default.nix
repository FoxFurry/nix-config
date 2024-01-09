{ pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    jetbrains.goland

    python311Full
    python311Packages.pygobject3
  ];

  programs.git = {
    enable = true;
    userName = "FoxFurry";
    userEmail = "isacartur@gmail.com";
  };
}