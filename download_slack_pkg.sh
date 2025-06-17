#!/bin/bash
#
# v. 2025.06.17

VERSION="15.0" # Slackware version
ARCH="64"
UPGRADE='no' # [yes/no] download only the packages in the "patch" folder

# Put here your favourite Slackware repository
#SRC="ftp://ftp.slackware.no/slackware/slackware${ARCH}-${VERSION}/"
#SRC="ftp://ftp.osuosl.org/pub/slackware/slackware${ARCH}-${VERSION}/"
SRC=ftp://nephtys.lip6.fr/pub/linux/distributions/slackware/slackware${ARCH}-${VERSION}/

# put here your pkg list
LIST=${PWD}/PKG_LIST_${VERSION}
#LIST="${PWD}/PKG_LIST-all-minimal-a-ap-d-l-n"

# the directory where you want to download the slackware packages
PACKAGES="${PWD}/slackware${ARCH}-${VERSION}_pkg"

################### do not touch below this line ################################

# create the folder where the pkg will be downloaded
if [ ! -d "$PACKAGES" ]; then
  # the /a subdir makes slackware setup to accept the list, just like as they belong to the /a section
  mkdir -p ${PACKAGES}/a
fi

# download
cd ${PACKAGES}/a

if [ "$UPGRADE" != "yes" ]; then # do not download again
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

# download packages from the patches folder. Skip if VERSION="current"
if [ "$VERSION" != "current" ]; then
  # create the "patches" sub-folder
  if [ ! -d "${PACKAGES}/a/patches" ]; then
    mkdir -p "${PACKAGES}/a/patches"
  fi

  cd ${PACKAGES}/a/patches
  rm ${PACKAGES}/a/patches/*

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
fi
