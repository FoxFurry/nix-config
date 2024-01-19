{ pkgs, ... }:

{
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ];
      userSettings = {
        "files.autoSave" = "off";
        "[nix]"."editor.tabSize" = 2;
        "window.titleBarStyle" = "custom";
      };
    };
}