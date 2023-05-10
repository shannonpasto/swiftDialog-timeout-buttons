#!/bin/sh

##########
# with inspiration from
# https://stackoverflow.com/questions/1570262/get-exit-code-of-a-background-process
# https://github.com/bartreardon/swiftDialog
# https://github.com/bartreardon/swiftDialog/issues/231
##########

# set a few variable
dialogbin="/Library/Application Support/Dialog/Dialog.app/Contents/MacOS/Dialog"
commandfile="/var/tmp/dialog.log"
delay=$(jot -r 1 5 15) # this will choose a random number between 5 and 15

# if we are root launch as the user in case we run from MDM like Jamf
if [ $(id -u) -eq 0 ]; then
  if [ ! -z $commandfile ]; then
    touch $commandfile
    chmod 644 $commandfile
  fi

  # get the loggedon username and user id
  CurrentlyLoggedInUser=$(/usr/bin/stat -f %Su /dev/console)
  CurrentlyLoggedInUserUID=$(/usr/bin/id -u "${CurrentlyLoggedInUser}")

  # run dialog as the user
  launchctl asuser $CurrentlyLoggedInUserUID "$dialogbin" \
    --title Title \
    --message Message \
    --button1text OK \
    --button2text Cancel \
    --infobuttontext Help \
    --button1disabled \
    --button2disabled &
else
  "$dialogbin" \
    --title Title \
    --message Message \
    --button1text OK \
    --button2text Cancel \
    --infobuttontext Help \
    --button1disabled \
    --button2disabled &
fi

# do a quick sleep to make sure the dialog is up and running and the commandfile is in place
sleep 0.5
# get the pid of the running dialog
my_pid=$(pgrep Dialog)

# sleep for the specified amount of time
sleep $delay

# activate the buttons
cat << EOF >> $commandfile
button1: enabled
button2: enabled
EOF

# wait here for the user to make a choice
wait $my_pid
my_exit=$?

# the user has made a choice, now do something based on the choice
case $my_exit in
  0)
    echo "dialog return code $my_exit"
    ;;

  2)
    echo "dialog return code $my_exit"
    ;;

  3)
    echo "dialog return code $my_exit"
    ;;

  *)
    echo "dialog return code $my_exit"
    ;;

esac

# add the rest of your script here if needed

exit 0
