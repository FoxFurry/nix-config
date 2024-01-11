#!/usr/bin/env bash
# Thanks https://github.com/i4pg/dotfiles for awesome cava configuration!!!

is_cava_ServerExist=`ps -ef|grep -m 1 cava|grep -v "grep"|wc -l`
if [ "$is_cava_ServerExist" = "0" ]; then
	echo "cava_server not found" > /dev/null 2>&1
#	exit;
elif [ "$is_cava_ServerExist" = "1" ]; then
  killall cava
fi

# | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
cava -p ~/.config/cava/config
