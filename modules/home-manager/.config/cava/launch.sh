#!/usr/bin/env bash
# Thanks https://github.com/i4pg/dotfiles for awesome cava configuration!!!

is_cava_ServerExist=`ps -ef|grep -m 1 cava|grep -v "grep"|wc -l`
if [ "$is_cava_ServerExist" = "0" ]; then
	echo "cava_server not found" > /dev/null 2>&1
#	exit;
elif [ "$is_cava_ServerExist" = "1" ]; then
  killall cava
fi

cava -p ~/.config/cava/config
