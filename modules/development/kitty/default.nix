{ pkgs, ... }:

{
  xdg.configFile."kitty" = { source = ./../../../.config/kitty; recursive = true; };
}