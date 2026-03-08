# This are my dotfiles that I manage using chezmoi :)

Usefull Commands:
-----------------
```fish
chezmoi status # Check what files have changed
chezmoi git status # Check if you have e.g. unpushed changes
chezmoi merge-all # Open meld for all files with changes and merge them
# The merge is now working with labels for the files :)

chezmoi update # Apply the incomming changes (from the Source dir)
chezmoilg # Open lazygit in chezmoi source dir to manage (mostly commit) changes
chezmoi cd # Switch to the Source dir of chezmoi (the git repo)

chezmoi add $FILE # Adds a file from your home dir to the chezmoi managed source dir
chezmoi add --template $FILE # Add the file as a tempalte (so you can use secrets in them)
chezmoi edit --apply $FILE # Edit the source file (good to keep in mind for templated files ^^)
```

So my normal workflow to edit files looks something like that:
```fish
# I normally forgett to use chezmoi edit...:
nvim .ssh/config # change something

# Ahhh, Oh I should have used chezmoi edit... now I have to merge..
chezmoi merge-all # resolve the merge so that the source file reflects the change
# If the source file is a template the merge is a little harder
# because the template variables will have to stay as differences, but that is
# not too complex ^^

chezmoilg # stage, commit, push the change

# If we now changed a file in the source dir while commiting
chezmoi update # to reflect the change in our home directory configs
```


