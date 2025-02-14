#!/bin/bash

# QR Code Generator
# This script exists for CougarCS QR code event creations.
# - Jester

PATH_TO_IMAGES="$HOME/Pictures/cougarcsimages/main-cougarcs-images"
PATH_TO_QRCODES="$HOME/Pictures/cougarcsimages/qrcodes"

generate() {
    OPTION=$1
    COLOR=$2
    OVERLAY_IMAGE=$3
    FILE_NAME=$4
    URL=$5

    mkdir -p "$PATH_TO_QRCODES/TMP/"
    qrencode -o "$PATH_TO_QRCODES/TMP/temporary.png" -l H -s 32 "$URL"
    magick "$PATH_TO_QRCODES/TMP/temporary.png" -fill "$COLOR" -opaque black "$PATH_TO_QRCODES/TMP/temporary-recolored.png"

    if [ "$(echo "$OVERLAY_IMAGE" | tr '[:upper:]' '[:lower:]')" != "none" ]; then
        magick "$OVERLAY_IMAGE" -resize 300x300 "$PATH_TO_QRCODES/overlaytemp.png"
        composite -gravity center "$PATH_TO_QRCODES/overlaytemp.png" "$PATH_TO_QRCODES/TMP/temporary-recolored.png" "$PATH_TO_QRCODES/$OPTION-$FILE_NAME.png"
    else
        mv "$PATH_TO_QRCODES/TMP/temporary-recolored.png" "$PATH_TO_QRCODES/$OPTION-$FILE_NAME.png"
    fi
    rm -rf "$PATH_TO_QRCODES/TMP/"
    echo -e "\033[1;32mQR Code Successfully Generated in $PATH_TO_QRCODES/$OPTION-$FILE_NAME.png"
}

# COLLAB_LOGOS() {
#
# }

hex_to_rgb() {
    hex=$1
    r=$((0x${hex:1:2}))
    g=$((0x${hex:3:2}))
    b=$((0x${hex:5:2}))

    echo "$r" "$g" "$b"
}

rgb_to_hex() {
    r=$1
    g=$2
    b=$3
    printf '#%02x%02x%02x\n' "$r" "$g" "$b"
}

color_mixer() {
    read -r r1 g1 b1 <<< COLOR1="$(hex_to_rgb "$1")"
    read -r r2 g2 b2 <<< COLOR2="$(hex_to_rgb "$2")"

    R=$(( (r1 + r2) / 2))
    G=$(( (g1 + g2) / 2))
    B=$(( (b1 + b2) / 2))
    
    rgb_to_hex "$R" "$G" "$B"
}

main_generate() {
    if [ $# -lt 3 ]; then
        echo -e "\033[1;31mToo little arguments.\nUSAGE: $0 [webdev|infosec|tutoring|mainline] [file-name] [url]"
    elif [ $# -gt 3 ]; then
        echo -e "\033[1;31mToo many arguments.\nUSAGE: $0 [webdev|infosec|tutoring|mainline] [file-name] [url]"
    else
        OPTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        FILE_NAME=$(echo "$2" | tr '[:upper:]' '[:lower:]')
        URL="$3"
        case $OPTION in
            webdev)
                COLOR="#7554F6"
                ;;
            infosec)
                COLOR="#00B2FF"
                ;;
            tutoring)
                COLOR="#13CE67"
                ;;
            mainline)
                COLOR="#C80F2E"
                ;;
            *)
                echo -e "\033[1;31mInvalid option"
                exit 1
                ;;
        esac
        OVERLAY_IMAGE="$PATH_TO_IMAGES/$OPTION.png"

        generate "$OPTION" "$COLOR" "$OVERLAY_IMAGE" "$FILE_NAME" "$URL"
    fi
}

collab_generate() {
    if [[ $# -lt 4 ]]; then
        echo -e "\033[1;31mToo little arguments.\nUsage: $0 [collab] [file-name] [url] collab1, collab2...\nCollabs: cougarettes csgirls codecoogs"
    else
        OPTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        FILE_NAME=$2
        URL=$3
        MAIN_COLOR="#C80F2E"

        for i in $(seq 4 $#); do
            case "${!i}" in
                cougarettes)
                    COLOR="#FFD700"
                ;;
                csgirls)
                    COLOR="#FF69B4"
                ;;
                codecoogs)
                    COLOR="#FF4500"
                ;;
                *)
                    continue
                ;;
            esac
            MAIN_COLOR=$(color_mixer "$MAIN_COLOR" "$COLOR")
            # COLLABED_LOGOS=$( find a way to mix the logos
        done
    fi
    echo "$MAIN_COLOR"
}

custom_generate() {
    if [[ $# -lt 5 ]]; then
        echo -e "\033[1;31mToo little arguments.\nUsage: $0 [collab] [hex-value] [options/none/path-to-custom-screenshot] [file-name] [url]"
    elif [[ $# -gt 5 ]]; then
        echo -e "\033[1;31mToo little arguments.\nUsage: $0 [collab] [hex-value] [options/none/path-to-custom-screenshot] [file-name] [url]"
    else
        OPTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        COLOR=$2
        OVERLAY_IMAGE=$3
        FILE_NAME=$4
        URL=$5

        case $OVERLAY_IMAGE in
            webdev|infosec|tutoring|mainline)
            OVERLAY_IMAGE="$PATH_TO_IMAGES/$OVERLAY_IMAGE.png"
            ;;
            none)
            OVERLAY_IMAGE="none"
        esac

        if [[ "$(echo "$OVERLAY_IMAGE" | tr '[:upper:]' '[:lower:]')" != "none" ]]; then
            if [ ! -f "$OVERLAY_IMAGE" ]; then
                echo -e "\033[1;31mPath to screenshot does not exist."
                exit 1
            fi
        fi

        generate "$OPTION" "#$COLOR" "$OVERLAY_IMAGE" "$FILE_NAME" "$URL"
    fi
}

if [[ $# -eq 0 ]]; then
    echo -e "\033[1;31mToo little arguments.\n"
    echo -e "USAGE: $0 [collab|webdev|infosec|tutoring|mainline] [specific-parameters]"
    exit 1
fi

case "$1" in

    webdev|infosec|tutoring|mainline)
        main_generate "$@"
    ;;
    collab)
        collab_generate "$@"
    ;;
    custom)
        custom_generate "$@"
    ;;
    *) 
        echo -e "\033[1;31mInvalid option.\n"
        echo -e "USAGE: $0 [collab|webdev|infosec|tutoring|mainline] [specific-parameters]"
    ;;
esac

exit 1
