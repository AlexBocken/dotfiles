#!/bin/sh
# cronjob requires this
# shellcheck disable=SC1090
. ~/.zprofile
# sync moodle
echo "syncclouds.sh: moodle-dl"
{
    # remove lock file if moodle-dl is not running
    pgrep -x moodle-dl || [ -f ~/eth/.moodle/running.lock ] && rm ~/eth/.moodle/running.lock
    cd ~/eth/.moodle && moodle-dl
}
moodle_pid=$!

# sync nextcloud drive
echo "syncclouds.sh: nextcloudcmd"
{
	nextcloudcmd -u "alexander" --password "$(pass show Misc/nextcloud_token | head -n1)"  ~/dox/nextcloud https://cloud.bocken.org
}
nextcloud_pid=$!

# sync contacts to nextcloud
echo "syncclouds.sh: vdirsyncer"
{
    vdirsyncer sync
}
vdirsyncer_pid=$!

# sync calendar to nextcloud
echo "syncclouds.sh: calcurse-caldav"
{
    # remove lock file if calcurse-caldav is not running
    pgrep -x calcurse-caldav || [ -f ~/.local/share/calcurse/caldav/lock ] && rm ~/.local/share/calcurse/caldav/lock
    CALCURSE_CALDAV_PASSWORD=$(pass Misc/calcurse_token) calcurse-caldav
}
calcurse_pid=$!

# Wait for all processes to complete and print a message for each one
# This does not print in the correct order (meaning first done first printed), but it's good enough
wait $vdirsyncer_pid
echo "syncclouds.sh: vdirsyncer done"

wait $nextcloud_pid
echo "syncclouds.sh: nextcloudcmd done"

wait $calcurse_pid
echo "syncclouds.sh: calcurse-caldav done"

wait $moodle_pid
echo "syncclouds.sh: moodle-dl done"

echo "syncclouds.sh done"
