function chezmoilg --wraps='lazygit --path /home/horo/.local/share/chezmoi' --description 'Use lazygit in chezmoi source directory'
    lazygit --path /home/horo/.local/share/chezmoi $argv
end
