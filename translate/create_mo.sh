#!/bin/sh
# Version: 4

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
plasmoidName=`kreadconfig5 --file="$DIR/../package/metadata.desktop" --group="Desktop Entry" --key="X-KDE-PluginInfo-Name"`
projectName="plasma_applet_${plasmoidName}" # project name

#---
if [ -z "$plasmoidName" ]; then
	echo "[build] Error: Couldn't read plasmoidName."
	exit
fi

if [ -z "$(which msgfmt)" ]; then
	echo "[build] Error: msgfmt command not found. Need to install gettext"
	echo "[build] Running 'sudo apt install gettext'"
	sudo apt install gettext
	echo "[build] gettext installation should be finished. Going back to installing translations."
fi

#---
echo "[build] Compiling messages"

catalogs=`find . -name '*.po'`
for cat in $catalogs; do
	echo "$cat"
	catLocale=`basename ${cat%.*}`
	msgfmt -o "${catLocale}.mo" "$cat"

	installPath="$DIR/../package/contents/locale/${catLocale}/LC_MESSAGES/${projectName}.mo"

	echo "[build] Install to ${installPath}"
	mkdir -p "$(dirname "$installPath")"
	mv "${catLocale}.mo" "${installPath}"
done

echo "[build] Done building messages"

