#!/bin/bash

set -eEu
set -o pipefail  # avoid masking failures in pipes
shopt -s nullglob  # do not run loops if the glob has not found anything

# recreating svg images from external sources
CREATE_INITIAL=${CREATE_INITIAL:-}
# convert svg to jpg and png if needed
CREATE_JPG=${CREATE_JPG:-true}

CURRENT_DIR=$PWD

if [ -n "$CREATE_INITIAL" ];then
    echo "cloning repos into repos"
    mkdir -p repos
    pushd "$CURRENT_DIR"/repos || exit
    set +e
    git clone https://github.com/belzebub40k/router-pics.git
    git clone https://github.com/Moorviper/Freifunk-Router-Anleitungen
    git clone https://github.com/nalxnet/freifunk-device-images
    git clone https://github.com/freifunkstuff/meshviewer-hwimages
    set -e
    popd

    echo "cloning pictures into pictures-svg"
    mkdir -p pictures-svg
    cp repos/router-pics/*.svg pictures-svg/
    cp repos/freifunk-device-images/*.svg pictures-svg/
    cp repos/meshviewer-hwimages/hwimg/*.svg pictures-svg/
    for file in repos/Freifunk-Router-Anleitungen/router/**/front.svg; do
        cutfront=${file##repos/Freifunk-Router-Anleitungen/router/}
        routername=${cutfront%%/front.svg}
        cp "$file" pictures-svg/"$routername".svg
    done;

    pushd "$CURRENT_DIR"/pictures-svg
    set +e
    # wrong model name
    mv gl.inet_gl-mt300a.svg gl-mt300a.svg
    mv gl.inet_gl-mt300n.svg gl-mt300n.svg
    mv gl.inet_gl-mt750.svg gl-mt750.svg
    mv gl.inet_vixmini.svg gl-inet-vixmini.svg
    mv ocedo_indoor.svg ocedo-koala.svg
    # duplicate - 3d version available
    rm gl.inet-gl-ar750.svg

    mv netgear-ex6150v2.svg netgear-ex6150.svg
    # raspberry devices have been renamed
    mv raspberry-pi_model-b.svg raspberrypi.svg
    mv raspberry-pi_v2-model-b.svg raspberrypi-2.svg
    mv raspberry-pi_v3-model-b.svg raspberrypi-3.svg
    mv openmesh_om2p-hs.svg openmesh-om2p.svg
    mv openmesh_om5p-ac.svg openmesh-om5p.svg
    set -e
    popd

    echo "finished cloning sources"
fi

if [[ "${CREATE_JPG}" == "true" ]]; then
    echo "creating jpg folders"
    mkdir -p pictures-jpg
    mkdir -p pictures-png
fi

for file in pictures-svg/*.svg; do
    normalized=${file##pictures-svg/}
    normalized=${normalized%.svg}
    normalized="$(echo "$normalized" | sed -e 's/fritzbox/fritz-box/ig' -e 's/[^a-z0-9\.\-]/-/ig')"

    if [ "$file" == "pictures-svg/no_picture_available.svg" ]; then
        continue
    fi

    if [ "$file" != "pictures-svg/$normalized.svg" ]; then
        mv "$file" pictures-svg/"$normalized".svg
    fi

    if [[ "${CREATE_JPG}" != "true" ]]; then
        continue
    fi

    if [[ -L "pictures-svg/$normalized.svg" ]]; then
        link_filepath=$(readlink -f "pictures-svg/$normalized.svg")
        link_file=$(basename "$link_filepath")
        link_name="${link_file%.svg}"
        echo "Symlinking $normalized to $link_name. Skipping conversion."
        ln -sf "$link_name.png" "pictures-png/$normalized.png"
        ln -sf "$link_name.jpg" "pictures-jpg/$normalized.jpg"
    else
        inkscape "pictures-svg/$normalized.svg" --batch-process --export-type=png --export-filename="pictures-png/$normalized.png" --export-background-opacity=0
        convert "pictures-png/$normalized.png" -background white -flatten -alpha off "pictures-jpg/$normalized.jpg"
    fi
done;
