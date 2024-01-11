{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."cava" = { source = ./../../.config/cava; recursive = true; };
}