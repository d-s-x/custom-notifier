#!/bin/sh
set -x
$XGETTEXT `find ../package -name \*.qml` -L JavaScript -o ../package/translate/template.pot
