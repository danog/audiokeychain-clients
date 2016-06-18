#!/bin/bash
# Edit your commands in this file.

# Licensed under gplv3

if [ "$1" = "source" ];then
	# Place the token in the token file
	TOKEN=$(cat token)
	# Set INLINE to 1 in order to receive inline queries.
	# To enable this option in your bot, send the /setinline command to @BotFather.
	INLINE=0
	# Set to .* to allow sending files from all locations
	FILE_REGEX='/home/user/allowed/.*'
else
	send_action "${CHAT[ID]}" "typing"
	if ! tmux ls | grep -v send | grep -q $copname; then
		[ ! -z ${URLS[*]} ] && {
			send_message "${CHAT[ID]}" "Initiating recognition process..."
			curl -s ${URLS[*]} -o /tmp/$ME$NAME
			send_message "${CHAT[ID]}" "$(../audiokeychain.sh "/tmp/$ME$NAME")"
			rm "/tmp/$ME$NAME"
		}

	fi
	case $MESSAGE in
		'/info')
			send_markdown_message "${CHAT[ID]}" "This is bashbot, the *Telegram* bot written entirely in *bash*."
			;;
		*)
			send_markdown_message "${CHAT[ID]}" "This bot can recognize the musical key and the bpm (beats per minute) of any song.
To start, send me an audio file in mp3 or wav format smaller than 15 megabytes.

*Available commands*:
• /start: _Start bot and get this message_.

This bot uses audiokeychain.com to recognize the songs. Both the audiokeychain client and the bot is written by Daniil Gentili (@danogentili).
Get the code in my [GitHub](http://github.com/danog/audiokeychain-clients)
"
			;;
	esac
fi
