{ pkgs, ... }:

{
  xdg.configFile."wofi" = { source = ./../../../.config/wofi; recursive = true; };
}