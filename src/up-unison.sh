# Title:        up-unison.sh
# Description:  Setup Unison to sync computers
# Author:       Matthew Norris
# Reference:    http://www.micahcarrick.com/11-07-2007/unison-synchronize-ubuntu.html
#               http://fixunix.com/questions/15884-printing-all-arguments-passed-bash-script.html

# Check for the arguments "server" or "client" before proceeding.

if [ -n "$1" ]
  then
    if [ "$1" == "server" ] 
      then
        echo "Installing server..."
        sudo aptitude install openssh-server unison -y
    elif [ "$1" == "client" ]
      then
        echo "Installing client..."
        sudo aptitude install unison unison-gtk -y
    else
      echo "Invalid argument: '$1'.  Provide an argument of \"server\" or \"client\" to continue."
      exit 1
    fi
else
  echo "Invalid argument: '$1'.  Provide an argument of \"server\" or \"client\" to continue."
  exit 1
fi

################################################################################
# TODO: Getting an error when using functions: 
# ./unison-setup.sh: line 19: exit_with_error: command not found
################################################################################
function exit_with_error {
  echo "Invalid argument: '$1'.  Provide an argument of \"server\" or \"client\" to continue."
  exit 1
}

function install_client {
  sudo aptitude install unison unison-gtk -y
}

function install_server {
  # Install Unison for synchronizing computers

  sudo aptitude install openssh-server unison -y

  #CONFIG_FILE=/etc/ssh/sshd_config
  #echo "Backing up $CONFIG_FILE..."
  #sudo cp $CONFIG_FILE $CONFIG_FILE.bak

  ## Write a header in the config file so it is obvious what we have changed

  #echo "Modifying $CONFIG_FILE..."
  #sudo echo "################################################################################" >> $CONFIG_FILE
  #sudo echo "# Custom settings" >> $CONFIG_FILE
  #sudo echo "################################################################################" >> $CONFIG_FILE
  #sudo echo >> $CONFIG_FILE

  ## Deny remote users root access

  #sudo echo "AllowRootLogin no" >> $CONFIG_FILE

  ## Treat args as usernames to allow

  #for username in "$@"
  #  do
  #    echo "Allowing access to $username."
  #    sudo echo "AllowUsers $username" >> $CONFIG_FILE
  #done

  ## Restart the SSH service
  #sudo /etc/init.d/ssh
}
