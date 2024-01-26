{ pkgs, ... }:

{
  xdg.configFile."ranger" = { source = ./../../../.config/ranger; recursive = true; };
}