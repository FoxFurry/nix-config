{ pkgs, ... }:

{
#  programs.kitty = {
#    enable = true;
#  };

  programs.alacritty.enable = true;

  xdg.configFile."kitty" = { source = ./../../../.config/kitty; recursive = true; };
  xdg.configFile."alacritty" = { source = ./../../../.config/alacritty; recursive = true; };

}