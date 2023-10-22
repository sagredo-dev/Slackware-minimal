#!/bin/bash
#
# v. 2022.03.05

VERSION="15.0" # Slackware version
ARCH="64"
UPGRADE='no' # [yes/no] download only the packages in the "patch" folder

# Put here your favourite Slackware repository
SRC="ftp://ftp.osuosl.org/pub/slackware/slackware${ARCH}-${VERSION}/"

# put here your pkg list
LIST=${PWD}/PKG_LIST_${VERSION}
#LIST="${PWD}/PKG_LIST-all-minimal-a-ap-d-l-n"

# the directory where you want to download the slackware packages
PACKAGES="${PWD}/slackware${ARCH}-${VERSION}_pkg"

################### do not touch below this line ################################

# create the folder where the pkg will be downloaded
if [ ! -d "$PACKAGES" ]; then
        mkdir -p $PACKAGES
fi

# create the "patches" sub-folder
if [ ! -d "${PACKAGES}/patches" ]; then
        mkdir -p "${PACKAGES}/patches"
fi

# download
cd $PACKAGES

if [ ! $UPGRADE = 'yes' ]; then # do not download again
        if [ -f $LIST ]; then
                while read LINE
                    do
                    [ "$LINE" ] || continue
                    [ "${LINE#\#}" = "$LINE" ] || continue
                    wget "${SRC}slackware${ARCH}/${LINE}*.t?z"
                done < $LIST
        else
                echo "Can't find $LIST file."
                exit 1
        fi
fi

# download packages from the patches folder
cd ${PACKAGES}/patches
rm ${PACKAGES}/patches/*

if [ -f ${LIST} ]; then
        while read LINE
        do
                IFS='/' read -ra PKG <<< "$LINE"
                [ "${PKG#\#}" = "${PKG}" ] || continue
                PKG_LEN=${#PKG[@]}
                if [ $PKG_LEN == 2 ]; then
                        wget "${SRC}patches/packages/${PKG[1]}*.t?z"
                fi
        done < $LIST
else
        echo "Can't find $LIST file."
        exit 1
fi
