{ ... }:

{
  home.file = {
    ".ssh/config".text = ''
    Host github.com
            User git
            Hostname github.com
            PreferredAuthentications publickey
            IdentityFile /home/foxfurry/.ssh/foxfurrygh
    '';
  };
}