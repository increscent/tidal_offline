#!/bin/sh

# How to get the SESSION_ID and USER_ID:
# curl -X POST -H "X-Tidal-Token: wc8j_yBJd20zOmx0" -d "username=<email>" -d "password=<password>" "https://api.tidalhifi.com/v1/login/username"

# SESSION_ID
# USER_ID
# TARGET_DIR (does NOT end with a /)
. ./vars.sh

COUNTRY_CODE="US"
ORIGIN="http://listen.tidal.com"
BASE_URL="https://api.tidalhifi.com/v1"
FILE_EXT=".m4a"

build_url() {
    URL=$1
    EXTRA=$2

    REQUEST="curl -H \"X-Tidal-SessionId: ${SESSION_ID}\" -H \"Origin: ${ORIGIN}\" \"${URL}\" ${EXTRA}"
}

parse_track() {
    TRACK_ID="$1"
    TRACK_TITLE="$2"
    TRACK_ARTIST="$3"
}

get_stream() {
    TRACK_ID="$1"

    build_url "${BASE_URL}/tracks/${TRACK_ID}/streamUrl?countryCode=${COUNTRY_CODE}&soundQuality=HIGH"

    eval "$REQUEST" | node parse_stream.js
}

download_track() {
    FILENAME="$1"

    read STREAM_URL

    build_url "${STREAM_URL}" "-o \"${FILENAME}\""

    eval "$REQUEST"
}

remove_slash() {
    echo "$1" | tr -d /
}

echo "Getting list of tracks from collection..."

build_url "${BASE_URL}/users/${USER_ID}/favorites/tracks?countryCode=${COUNTRY_CODE}&limit=1000"

eval "$REQUEST" | node parse_tracks.js | while read TRACK; do
    eval parse_track $TRACK

    TRACK_TITLE=$(remove_slash "$TRACK_TITLE")
    TRACK_ARTIST=$(remove_slash "$TRACK_ARTIST")

    DIR="${TARGET_DIR}/${TRACK_ARTIST}"
    FILENAME="${DIR}/${TRACK_TITLE}${FILE_EXT}"

    mkdir -p "$DIR"

    if [ ! -f "$FILENAME" ]; then
        echo
        echo "Downloading..."
        echo "$TRACK_TITLE"
        echo "$TRACK_ID"
        get_stream "$TRACK_ID" | download_track "$FILENAME"
    fi
done

echo
echo "Done!"
