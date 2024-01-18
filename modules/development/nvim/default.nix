{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    #extraConfig = builtins.readFile ./../../../.config/nvim/init.vim;
  };

 xdg.configFile."nvim" = { source = ./../../../.config/nvim_nvchad; recursive = true; };
}
