{ ... }:

{
  home.file = {
    ".ssh/config".text = ''
    Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes

    # Personal GitHub account
    Host github.com-personal
        HostName github.com
        User git
        IdentityFile ~/.ssh/isacartur
        IdentitiesOnly yes
    '';
  };
}