if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias gm='/usr/bin/gm'
alias vim='nvim'
#alias ls='exa --icons --group-directories-first'
alias ls='lsd --hyperlink=auto -A --group-directories-first'
alias l='ls -lah'

alias open='handlr open'
alias o='open'

alias sshkitty='kitty +kitten ssh'

alias cat='bat'
alias man='batman'

alias pic='chafa --center on'
alias p='pic'

alias extract='unp -U'
alias x='extract'

alias f='fd -HIi'
alias ff='fd -HIi --hyperlink=always'

alias diff_dir_change='diff (ls . -lah --color always | psub) (read; ls . -lah --color always | psub)'

alias gpte='gh copilot explain'
alias gpts='gh copilot suggest'

alias rg='rg --no-ignore --hidden --ignore-case'

alias duff='duf -only-mp "/mnt/*,/"'

alias hrgd='hr-get-local-network-devices'
alias git-tree='git log --graph --oneline --decorate --all --date=short --pretty=format:"%h - %an, %ad : %s"'

alias nixm='vim /home/horo/packages.nix && nix-env -irf /home/horo/packages.nix # Nix management'
alias nixcg='nix-collect-garbage # Nix collect garbage'

alias mv='uu-mv -i --progress'
alias cp='uu-cp -i --progress'

function ssh --wraps ssh
  if test $TERM = xterm-kitty
    set --function --export TERM xterm-256color
  end
  command ssh $argv
end

set -x PATH $PATH /home/horo/Applications /home/horo/.cache/yay/distrobox/pkg/distrobox/usr/bin
set -x PATH $HOME/.flatpak/bin $PATH
set -x PATH $HOME/.local/bin:$PATH
set -x PATH $HOME/horoScripts $PATH
