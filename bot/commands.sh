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
	if ! tmux ls | grep -v send | grep -q $copname; then
		TOCHECK="${URLS[AUDIO]} ${URLS[DOCUMENT]}"
		[ ! -z $TOCHECK ] && {
			send_action "${CHAT[ID]}" "typing"
#			send_message "${CHAT[ID]}" "Initiating recognition process..."
			curl -s $TOCHECK -o /tmp/$ME$NAME
			CHECKRES="$(../audiokeychain.sh "/tmp/$ME$NAME")"
			#[ ! -z $CHECKRES ] && 
			res=$(curl -s "$MSG_URL" -d "chat_id=${CHAT[ID]}" -d "text=$(urlencode "$CHECKRES")" -d "reply_to_message_id=$MESSAGE_ID")
			rm "/tmp/$ME$NAME"
			return
		}

	fi
	case $MESSAGE in
		'/info')
			send_markdown_message "${CHAT[ID]}" "This is bashbot, the *Telegram* bot written entirely in *bash*."
			;;
		'/start')
			send_action "${CHAT[ID]}" "typing"
			send_message "${CHAT[ID]}" "This bot can recognize the musical key and the bpm (beats per minute) of any song.
To start, send me an audio file in mp3 or wav format smaller than 15 megabytes.

Available commands:
• /start: Start bot and get this message.

This bot uses audiokeychain.com to recognize the songs. Both the audiokeychain client and the bot is written by Daniil Gentili (@danogentili).
Check out my other bots: @video_dl_bot, @mklwp_bot, @caption_ai_bot, @cowsaysbot, @cowthinksbot, @figletsbot, @lolcatzbot, @filtersbot, @id3bot, @pwrtelegrambot, @lennysbot
Source code: https://github.com/danog/audiokeychain-clients
"
			;;
	esac
fi
