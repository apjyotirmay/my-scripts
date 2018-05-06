#!/bin/env bash

# This script uses rsync to backup a user's home directory to a destination

DEST=$(echo /media/$USER/Andromeda/folder/backup/linux/)

echo "Last backup details" > $HOME/.backup.log
echo "Start:  $(date)" >> $HOME/.backup.log
rsync -ah --delete --ignore-existing $HOME $DEST && 
echo "Finish: $(date)" >> $HOME/.backup.log && 
exit 0

echo "Backup failed" &&
exit 3
