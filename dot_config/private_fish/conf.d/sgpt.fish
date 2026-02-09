status is-interactive || exit

function _sgpt_commandline
    # Get the current command line content
    set -l _sgpt_prompt (commandline)

    # Only proceed if there is a prompt
    if test -z "$_sgpt_prompt"
        return
    end

    # Append an hourglass to the current command
    commandline -a "⌛"
    commandline -f end-of-line  # needed to display the icon

    # Get the output of the sgpt command
    set -l _sgpt_output (echo "$_sgpt_prompt" | sgpt --shell --no-interaction)

    if test $status -eq 0
        # Replace the command line with the output from sgpt
        commandline -r -- (string trim "$_sgpt_output")
        commandline -a "  # $_sgpt_prompt"
    else
        # If the sgpt command failed, remove the hourglass
        commandline -f backward-delete-char
        commandline -a "  # ERROR: sgpt command failed"
    end
end

# Bind command search using sgpt to CTRL+o
bind \co _sgpt_commandline
