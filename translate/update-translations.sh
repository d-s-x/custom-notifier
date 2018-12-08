#!/bin/sh

cd "$( dirname "${BASH_SOURCE[0]}" )"

NAME="template.pot"
PODIR=../package/translate/

# svn checkout svn://anonsvn.kde.org/home/kde/trunk/l10n-kf5/scripts
export PATH=./scripts:$PATH
extract-messages.sh

sed -e "s,Report-Msgid-Bugs-To: http://bugs.kde.org,Report-Msgid-Bugs-To: https://gitlab.com/yaute74/custom-notifier.git/issues," -i "$PODIR/$NAME"

echo "Merging translations"
catalogs=`find $PODIR -name '*.po'`
for cat in $catalogs
do
  echo $cat
  msgmerge -o $cat.new $cat $PODIR/$NAME
  mv $cat.new $cat
done

echo "Done merging translations"
