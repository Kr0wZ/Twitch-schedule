#!/bin/bash

CLIENT_ID=""
OAUTH_TOKEN=""

function usage() {
	echo "Usage: $0 -u <USERNAME>"
	echo "-u <USERNAME>: Username/channel to check (mandatory)."
	echo "-h: Run this usage message."
	exit 0
}

function argument_check(){
	#Check at least -u option is specified.
	if [[ -z "$USERNAME_" ]]
	then
        echo -e '\e[0;31m[-] You must specify the option -u. See -h or --help for more information.\e[0m' >&2
        exit 1
	fi
}

function check_oauth(){
	OAUTH_VALIDATION=$(curl -s -X GET "https://id.twitch.tv/oauth2/validate" -H "Authorization: Bearer $OAUTH_TOKEN" | jq -r '.status')
	if [[ "$OAUTH_VALIDATION" == 401 ]]
	then
		echo -e "\e[0;31m[-] Invalid token provided...\e[0m"
		exit
	fi
}

function check_channel_exists(){
	USERNAME_CHANNEL_RESULT=$(curl -s -X GET "https://api.twitch.tv/helix/users?login=$USERNAME_" -H "Authorization: Bearer $OAUTH_TOKEN" -H "Client-ID: $CLIENT_ID" | jq -r '.data[]')

	if [[ "$USERNAME_CHANNEL_RESULT" == "" ]]
	then
		echo -e "\e[0;31m[-] Error, channel does not exist or is banned. Check here: https://streamerbans.com/user/$USERNAME_\e[0m"
		exit
	fi
}

function check_username_provided(){
	if [[ "$USERNAME_" == "" ]]
	then
		echo -e "\e[0;31m[-] You should provide a username to check\e[0m"
		exit
	fi
}

function get_channel_id(){
	CHANNEL_ID=$(echo "$USERNAME_CHANNEL_RESULT" | jq -r '.id')
}

function retrieve_schedule(){
	SCHEDULE=$(curl -s -H "Client-ID: $CLIENT_ID" -H "Authorization: Bearer $OAUTH_TOKEN" -X GET "https://api.twitch.tv/helix/schedule/icalendar?broadcaster_id=$CHANNEL_ID")
}


while getopts ":u:h" options
do
	case "${options}" in
		u)
			USERNAME_=${OPTARG}
			USERNAME_=$(echo "$USERNAME_" | tr '[:upper:]' '[:lower:]')
			;;
		h)
			usage
			;;
	    *)
			echo -e "\e[0;31m[-] Unkown option... See -h or --help for more information\e[0m"
			exit 1
	      ;;
  	esac
done

argument_check

#First check if user has provided a username
check_username_provided

#Check if the OAuth token is valid:
check_oauth

#Check if user exists
check_channel_exists

#Get ID of channel
get_channel_id

retrieve_schedule

echo "$SCHEDULE"