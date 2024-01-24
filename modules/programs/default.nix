{ pkgs, ... }:

{
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ];
      userSettings = {
        "files.autoSave" = "onFocusChange";
        "[nix]"."editor.tabSize" = 2;
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Catppuccin Frappé";
        "workbench.preferredDarkColorTheme" = "Catppuccin Frappé";
        "workbench.iconTheme" = "catppuccin-frappe";
        "terminal.explorerKind" = "external";
      };
    };
}