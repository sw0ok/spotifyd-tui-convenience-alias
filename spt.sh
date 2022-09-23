#!/bin/bash
spotifyd_status=$(systemctl --user status spotifyd 2> echo $2 | grep "running" 1> /dev/null; echo $?) # if running then = 0 else 1

function usage {
  echo "Usage: $(basename $0) [-rks]" 2>&1
  echo '   -r   restart spotifyd daemon'
  echo '   -k   kill spotifyd daemon'
  echo '   -s   show quick spotifyd status'
  echo '   -h   show this guide'
  exit 1
}

function kill_process {
if [ $spotifyd_status == 0 ]; then
  killall spotifyd;
  systemctl --user stop spotifyd;
fi
}

function restart_daemon {
if [ $spotifyd_status == 0 ]; then
  killall spotifyd;
  echo Restarting spotifyd daemon
  sleep 0.5s
  while true; do
    local activating=$(systemctl --user status spotifyd 2> echo $2 | grep "activating" 1> /dev/null; echo $?);
    if [ $activating -eq 1 ]; then
      clear
      echo 'Activating spotifyd daemon [succesfull]'
      echo
      echo 'Enjoy your music!'
      sleep 1s
      clear
      spt
      break
    fi
    echo "Activating spotifyd daemon [current status $activating]."
    sleep 0.1s
    clear
    echo "Activating spotifyd daemon [current status $activating].."
    sleep 0.1s
    clear
    echo "Activating spotifyd daemon [current status $activating]..."
    sleep 0.1s
    clear
  done
else
  regular
fi
}

function regular {
  if [ $spotifyd_status == 0 ]; then
    spt
  else 
    systemctl --user start spotifyd
    spt
  fi
}

function options {
  optstring=":rksh"
  while getopts ${optstring} arg; do
  case "${arg}" in
    k) kill_process ;;
    r) restart_daemon ;;
    s) status $@ ;;
    h) usage ;;

    ?)
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done
}

function status {
  echo
  echo "Launch options $@"
  echo "Current spotifyd daemon status"
  echo
  systemctl --user status spotifyd 2> /dev/null
  echo
  read -p "Press enter to continue"
  clear
  
  if [[ ($# -eq 1) && ($1 -eq "-s") ]]; then
    regular
  fi
}

if [ $# -gt 0 ]; then
  options $@
else
  regular
fi