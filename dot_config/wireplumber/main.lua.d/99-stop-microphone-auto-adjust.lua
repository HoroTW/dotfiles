-- after change use  'systemctl --user restart wireplumber pipewire pipewire-pulse'
-- to reload the config

-- disable microphone auto adjust for all but pavucontrol, gnome-control-center
table.insert (default_access.rules,{
    matches = {
        {
            { "application.process.binary", "=", "teamspeak3" }
        },
        {
            { "application.process.binary", "=", "brave" }
        },
        {
            { "application.process.binary", "=", "chromium" }
        },
        {
            { "application.process.binary", "=", "firefox" }
        }
    },
    default_permissions = "rx",
})

-- to find a specific process, start the process and run the following to list all processes
-- sleep 5 && echo now && ps -e -o command --sort=uid > /tmp/topcurr.txt && sleep 10 && ps -e -o command --sort=uid > /tmp/topnext.txt && diff /tmp/topcurr.txt /tmp/topnext.txt

