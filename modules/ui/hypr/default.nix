{ inputs, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./../../../.config/hypr/hyprland.conf;
  };

  xdg.configFile."hypr/hyprpaper.conf" = { source = ./../../../.config/hypr/hyprpaper.conf;  };
}
