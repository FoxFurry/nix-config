{ inputs, config, pkgs, ... }:

{
   imports = [
     ./development
     ./mimes
     ./programs
     ./ui
   ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = "foxfurry";
  home.homeDirectory = "/home/foxfurry";

  home.packages = with pkgs; [
    swww
  ];

  home.pointerCursor = {
    name = "catppuccin-macchiato-mauve-cursors";
    package = pkgs.catppuccin-cursors.macchiatoMauve;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
