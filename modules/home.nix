{ inputs, config, pkgs, ... }:

{
   imports = [
     ./development
     ./mimes
     ./programs
     ./ui
     inputs.catppuccin.homeManagerModules.catppuccin
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

  catppuccin.flavor = "macchiato";
  catppuccin.accent = "mauve";
  catppuccin.cursors.enable = true;

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
