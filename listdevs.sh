#!/bin/bash

# Simple script to list the devices an ipa has been built for
# Copyright © Tapadoo, 2011.  All Rights Reserved
# No warranty is provided for the use of this script
# You are free to modify this for your needs 
LANG=C
LC_CTYPE=C
IPAFILE="$1"
UDID="$2"
TMPDIR=tmp$$.tmp
mkdir $TMPDIR
unzip -qq "$IPAFILE" -d $TMPDIR
EMBEDFILE=`find $TMPDIR -name embedded.mobileprovision -print | head -1`
EMBEDFILEONLY="${EMBEDFILE}.plist"
sed -n '/plist/,/\/plist/p' "$EMBEDFILE" > "$EMBEDFILEONLY"
UDIDs=$(sed -n '/ProvisionedDevices/,/\/array/p' "$EMBEDFILEONLY" | grep string | sed 's/<[/]*string>//g')
rm -rf $TMPDIR
if [[ -z "$UDID" ]]; then
	printf "\n*****UDID*******\n%s\n****************\n" "$UDIDs"
	exit 1;
fi 
if [ ${#UDID} -ne 40 ]; then
	printf "\nInvalid UDID: %s\n"  "$UDID"
	exit 1;
fi
if [[ $UDIDs == *$UDID* ]] ; then
	printf "UDID is present\xF0\x9f\x8d\xba\n" 
else
	printf "\nUDID is NOT present\n" 
fi
