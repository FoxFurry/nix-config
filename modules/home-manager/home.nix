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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    DEFAULT_BROWSER = "vivaldi.desktop";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
