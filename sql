#!/bin/bash
# MIT License
#
# Copyright (c) 2023 Kris Rice, Gerald Venzl
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

downloadSQLcl(){
  version=$1
  link=$2

  # Set the stage directory
  STAGE_DIR=/tmp/sqlcl/${version}/
  mkdir -p ${STAGE_DIR}

  # Check whether internet connection exists
  if ping -c 1 -W 3 download.oracle.com > /dev/null; then

    echo "🔄 Checking SQLcl version...${version} ${link}"

    # Get current ETAG from download
    ETAG=$(curl -I -s $link | tr -d '\r'  | sed -En 's/^ETag: (.*)/\1/p')

    #echo "REMOTE-ETAG: $ETAG"

    # Compare to last ETag saved
    if [[ -e $STAGE_DIR/sqlcl.etag ]]; then
        CURRENT_ETAG=$(cat $STAGE_DIR/sqlcl.etag)
        #echo "LOCAL-ETAG: $CURRENT_ETAG"
    else
        CURRENT_ETAG="none"
    fi

    FILENAME=$(basename ${link})
    #echo $FILENAME
    # Check if ETags match
    if [[ "$ETAG" != "$CURRENT_ETAG" ]]; then
      echo "⬇️  Downloading ${version} SQLcl..."
      curl -sS -o $STAGE_DIR/${FILENAME} \
            --header "If-None-Match: ${CURRENT_ETAG}" \
            ${link}
      echo "🧹 Removing old SQLcl"
      rm -rf $STAGE_DIR/sqlcl
      echo "🗜️  Unzipping latest SQLcl to $STAGE_DIR"
      unzip   -qq -d $STAGE_DIR $STAGE_DIR/${FILENAME}
      echo "$ETAG" > $STAGE_DIR/sqlcl.etag
    else
      echo "✅ SQLcl is current."
    fi

  else
    echo "Internet connection to download.oracle.com not available."
    if [[ ! -f $STAGE_DIR/sqlcl/bin/sql ]]; then
      echo "❌ SQLcl cannot be downloaded, please check internet connection."
      return 1;
    else
      echo "⚠️  Cannot verify latest SQLcl version."
    fi
  fi

  ret_val=$STAGE_DIR
}

sql() {
  # Remote source this script
  #
  # . <(curl -s https://raw.githubusercontent.com/gvenzl/oracle-tools/main/sqlcl/sql)
  new_args=()
  version="latest"
  for var in "$@"; do
    case $var in
      "-r") release=true ;;  # get next arg as the release
      *)
        if [[ "$release" == "true" ]]; then
          version=$var
          release=false
        else
          new_args+=($var)
        fi
      ;;
    esac
  done

  echo -e "Trying Version: ${version}"

  

  if ( test -f releases.json ); then
    VERSIONS=$(cat releases.json| jq ".SQLcl[].version")
    LINK=$(cat releases.json|jq -r --arg VERSION "$version" '.SQLcl[] | select(.version=="\($VERSION)").link' )
  else
    RELEASES="https://raw.githubusercontent.com/krisrice/dbtools-releases/main/releases.json"
    LINK=$(curl ${RELEASES} jq -r --arg VERSION "$version" '.SQLcl[] | select(.version=="\($VERSION)").link')
  fi 
  
  echo -e "🤷 Available Versions:\n${VERSIONS}"

  STAGE_DIR=xx
  downloadSQLcl ${version} ${LINK}
  STAGE_DIR=$ret_val
  
  echo "STAGED AT : ${STAGE_DIR}"

   # Run SQLcl
   echo "🚀 Launching SQLcl..."
   #$STAGE_DIR/sqlcl/bin/sql "$@"
    $STAGE_DIR/sqlcl/bin/sql ${new_args[*]}
}
