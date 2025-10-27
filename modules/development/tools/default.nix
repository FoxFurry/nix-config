{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user.name = "FoxFurry";
    settings.user.email = "isacartur@gmail.com";
  };
}