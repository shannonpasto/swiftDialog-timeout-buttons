#!/bin/sh

##########
# with inspiration from
# https://stackoverflow.com/questions/1570262/get-exit-code-of-a-background-process
# https://github.com/bartreardon/swiftDialog
# https://github.com/bartreardon/swiftDialog/issues/231
##########

# set a few variable
dialogBin="/Library/Application Support/Dialog/Dialog.app/Contents/MacOS/Dialog"
commandFile="/var/tmp/dialog.log"
delaySec=$(/usr/bin/jot -r 1 5 15) # this will choose a random number between 5 and 15

# if we are root launch as the user in case we run from MDM like Jamf
if [ "$(/usr/bin/id -u)" -eq 0 ]; then
  if [ -n "${commandFile}" ]; then
    /usr/bin/touch "${commandFile}"
    /bin/chmod 644 "${commandFile}"
  fi

  # get the loggedon username and user id
  CurrentlyLoggedInUser=$(/usr/bin/stat -f %Su /dev/console)
  CurrentlyLoggedInUserUID=$(/usr/bin/id -u "${CurrentlyLoggedInUser}")

  # run dialog as the user
  /bin/launchctl asuser "${CurrentlyLoggedInUserUID}" "${dialogBin}" \
    --title Title \
    --message Message \
    --button1text OK \
    --button2text Cancel \
    --infobuttontext Help \
    --button1disabled \
    --button2disabled &
else
  "${dialogBin}" \
    --title Title \
    --message Message \
    --button1text OK \
    --button2text Cancel \
    --infobuttontext Help \
    --button1disabled \
    --button2disabled &
fi

# do a quick sleep to make sure the dialog is up and running and the commandFile is in place
sleep 0.5
# get the pid of the running dialog
myPID=$(/usr/bin/pgrep Dialog)

# sleep for the specified amount of time
sleep "${delaySec}"

# activate the buttons
/bin/cat << EOF >> "${commandFile}"
button1: enabled
button2: enabled
EOF

# wait here for the user to make a choice
wait "${myPID}"
# the user has made their choice so capture the exit code
myExit=$?

# evaluate the exit code in a case statement and do something based on the choice
case "${myExit}" in
  0)
    /bin/echo "OK clicked. dialog return code ${myExit}"
    ;;

  2)
    /bin/echo "Cancel clicked. dialog return code ${myExit}"
    ;;

  3)
    /bin/echo "Help clicked. dialog return code ${myExit}"
    ;;

  *)
    /bin/echo "Unknown error or dialog quit. dialog return code ${myExit}"
    ;;

esac

# add the rest of your script here if needed

exit 0
