{ pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
  ];

  xdg.configFile."waybar" = { source = ./../../.config/waybar; recursive = true; };
}