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
} > /dev/null 2>&1 &
moodle_pid=$!

# sync nextcloud drive
echo "syncclouds.sh: nextcloudcmd"
{
    nextcloudcmd -s -u "alexander@bocken.org" --password "$(pass server/seenas/nextcloud_admin_pass | head -n1)"  ~/dox/nextcloud https://cloud.bocken.org
} > /dev/null 2>&1 &
nextcloud_pid=$!

# sync contacts to nextcloud
echo "syncclouds.sh: vdirsyncer"
{
    vdirsyncer sync
} > /dev/null 2>&1 &
vdirsyncer_pid=$!

# sync calendar to nextcloud
echo "syncclouds.sh: calcurse-caldav"
{
    # remove lock file if calcurse-caldav is not running
    pgrep -x calcurse-caldav || [ -f ~/.local/share/calcurse/caldav/lock ] && rm ~/.local/share/calcurse/caldav/lock
    CALCURSE_CALDAV_PASSWORD=$(pass server/seenas/nextcloud_admin_pass) calcurse-caldav
} > /dev/null 2>&1 &
calcurse_pid=$!

# Wait for all processes to complete and print a message for each one

wait $vdirsyncer_pid
echo "syncclouds.sh: vdirsyncer done"

wait $nextcloud_pid
echo "syncclouds.sh: nextcloudcmd done"

wait $calcurse_pid
echo "syncclouds.sh: calcurse-caldav done"

wait $moodle_pid
echo "syncclouds.sh: moodle-dl done"

echo "syncclouds.sh done"
