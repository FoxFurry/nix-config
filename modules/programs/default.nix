{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    vivaldi
    discord
    playerctl
  ];
}