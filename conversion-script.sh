#!/bin/bash

set -eEu
set -o pipefail  # avoid masking failures in pipes
shopt -s nullglob  # do not run loops if the glob has not found anything

# recreating svg images from external sources
CREATE_INITIAL=
# convert svg to jpg and png if needed
CREATE_JPG=true

if [ -n "$CREATE_INITIAL" ];then
    echo "cloning repos into repos"
    mkdir -p repos
    cd repos
    git clone https://github.com/belzebub40k/router-pics.git
    git clone https://github.com/Moorviper/Freifunk-Router-Anleitungen
    git clone https://github.com/nalxnet/freifunk-device-images
    git clone https://github.com/freifunkstuff/meshviewer-hwimages
    cd ..

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

    cd pictures-svg
    # wrong model name
    mv gl.inet_gl-mt300a.svg gl-mt300a.svg
    mv gl.inet_gl-mt300n.svg gl-mt300n.svg
    mv gl.inet_gl-mt750.svg gl-mt750.svg
    mv ocedo_indoor.svg ocedo-koala.svg

    # meshviewer does not use version
    mv d-link-dap-x1860-a1.svg d-link-dap-x1860.svg

    mv netgear-ex6150v2.svg netgear-ex6150.svg
    # raspberry devices have been renamed
    mv raspberry-pi_model-b.svg raspberrypi.svg
    mv raspberry-pi_v2-model-b.svg raspberrypi-2.svg
    mv raspberry-pi_v3-model-b.svg raspberrypi-3.svg
    mv openmesh_om2p-hs.svg openmesh-om2p.svg
    mv openmesh_om5p-ac.svg openmesh-om5p.svg
    cd ..

    echo "finished cloning sources"
fi

if [ -n "$CREATE_JPG" ];then
    echo "creating jpg folders"
    mkdir -p pictures-jpg
    mkdir -p pictures-png
fi

for file in pictures-svg/*.svg; do
    normalized=${file##pictures-svg/}
    normalized=${normalized%.svg}
    normalized="$(echo "$normalized" | sed -e 's/fritzbox/fritz-box/ig' -e 's/[^a-z0-9\.\-]/-/ig')"

    if [ "$file" != "pictures-svg/$normalized.svg" ]; then
        mv "$file" pictures-svg/"$normalized".svg
    fi
    if [ -n "$CREATE_JPG" ];then
        inkscape "pictures-svg/$normalized.svg" --batch-process --export-type=png --export-filename="pictures-png/$normalized.png" --export-background-opacity=0
        convert "pictures-png/$normalized.png" -background white -flatten -alpha off "pictures-jpg/$normalized.jpg"
    fi
done;


# shellcheck disable=SC2086
create_symlink() {
    EXT=$1

    echo "creating symlinks"
    ln -sf 8devices-jalapeno-board.$EXT 8devices-jalapeno.$EXT
    ln -sf aerohive-ap330.$EXT aerohive-hiveap-330.$EXT
    ln -sf aerohive-hiveap-121.$EXT aerohive-ap121.$EXT
    ln -sf alfa-ap121.$EXT alfa-ap121u.$EXT
    ln -sf avm-fritz-box-7360.$EXT avm-fritz-box-7430.$EXT
    ln -sf avm-fritz-box-3370.$EXT avm-fritz-box-3370-rev-2-micron-nand.$EXT
    ln -sf avm-fritz-box-7320.$EXT avm-fritz-box-7362-sl.$EXT
    ln -sf avm-fritz-box-7360-v2.$EXT avm-fritz-box-7360.$EXT
    ln -sf avm-fritz-wlan-repeater-450e.$EXT avm-fritz-wlan-repeater-300e.$EXT
    ln -sf devolo-wifi-pro-1200i.$EXT devolo-wifi-pro-1750i.$EXT
    ln -sf d-link-dap-x1860.$EXT d-link-dap-x1860-a1.$EXT
    ln -sf d-link-dir-825-rev-b1.$EXT d-link-dir-825b1.$EXT
    ln -sf d-link-dir-860l.$EXT d-link-dir-860l-b1.$EXT
    ln -sf gl-inet-6408a-v1.$EXT gl-inet-6416a-v1.$EXT
    ln -sf gl-inet-gl-ar300m16.$EXT gl-inet-gl-ar300m-nor.$EXT
    ln -sf gl.inet-gl-ar300m.$EXT gl.inet-gl-ar300m-lite.$EXT
    ln -sf gl.inet-gl-ar750s.$EXT gl.inet-gl-ar750s-nor.$EXT
    ln -sf netgear-dgn3500.$EXT netgear-dgn3500b.$EXT
    ln -sf netgear-ex3700.$EXT netgear-ex3800.$EXT
    ln -sf netgear-ex3700.$EXT netgear-ex3700-ex3800.$EXT
    ln -sf netgear-ex6150.$EXT netgear-ex6100.$EXT
    ln -sf netgear-ex6150.$EXT netgear-ex6150v2.$EXT
    ln -sf netgear-r6220.$EXT netgear-wac104.$EXT
    ln -sf netgear-r7800.$EXT netgear-nighthawk-x4s-r7800.$EXT
    ln -sf netgear-wndr3700.$EXT netgear-wndr3700v2.$EXT
    ln -sf netgear-wndr3700.$EXT netgear-wndr3700v4.$EXT
    ln -sf netgear-wndr3800.$EXT netgear-wndr3800chmychart.$EXT
    ln -sf nexx-wt3020.$EXT nexx-wt3020ad.$EXT
    ln -sf nexx-wt3020.$EXT nexx-wt3020f.$EXT
    ln -sf nexx-wt3020.$EXT nexx-wt3020h.$EXT
    ln -sf ocedo-koala.$EXT ocedo-raccoon.$EXT
    ln -sf openmesh-a40.$EXT openmesh-a42.$EXT
    ln -sf openmesh-a40.$EXT openmesh-a60.$EXT
    ln -sf openmesh-a40.$EXT openmesh-a62.$EXT
    ln -sf openmesh-mr900-v2.$EXT openmesh-mr1750.$EXT
    ln -sf openmesh-mr600-v1.$EXT openmesh-mr600-v2.$EXT
    ln -sf openmesh-mr600-v1.$EXT openmesh-mr900-v1.$EXT
    ln -sf openmesh-mr600-v1.$EXT openmesh-mr900-v2.$EXT
    ln -sf openmesh-om2p.$EXT openmesh-om2p-lc.$EXT
    ln -sf openmesh-om2p.$EXT openmesh-om2p-hs.$EXT
    ln -sf openmesh-om5p.$EXT openmesh-om5p-an.$EXT
    ln -sf openmesh-om5p.$EXT openmesh-om5p-ac.$EXT
    ln -sf raspberrypi.$EXT raspberry-pi-modelb-b-rev-1.$EXT
    ln -sf raspberrypi.$EXT raspberry-pi-modelb-b-rev-2.$EXT
    ln -sf raspberrypi-2.$EXT raspberry-pi-2-model-b-rev-1.1.$EXT
    ln -sf raspberrypi-3.$EXT raspberry-pi-3-model-b-rev-1.2.$EXT
    ln -sf raspberrypi.$EXT raspberry-pi.$EXT
    ln -sf raspberrypi-2.$EXT raspberry-pi-2.$EXT
    ln -sf raspberrypi-3.$EXT raspberry-pi-3.$EXT
    ln -sf tp-link-archer-c20i.$EXT tp-link-archer-c20i-alle.$EXT
    ln -sf tp-link-archer-c20-v1.$EXT tp-link-archer-c20-v5.$EXT
    ln -sf tp-link-archer-c2-v1.$EXT tp-link-archer-c2-v2.$EXT
    ln -sf tp-link-archer-c2-v1.$EXT tp-link-archer-c2-v3.$EXT
    ln -sf tp-link-archer-c6-v2.$EXT tp-link-archer-c6-v2-eu-ru-jp.$EXT
    ln -sf tp-link-archer-c60-v2.$EXT tp-link-archer-c60-v1.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-archer-c59-v1.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-archer-c7-v4.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-archer-c7-v5.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-archer-a7-v5.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-td-w8980-alle.$EXT
    ln -sf tp-link-archer-c7-v2.$EXT tp-link-td-w9980-alle.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe210-v1.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe210-v2.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe210-v2.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe210-v3.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe210-v3.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe220-v1.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe220-v3.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe220-v3.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe510-v1-0.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe510-v1-1.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe510-v1.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe510-v1.$EXT
    ln -sf tp-link-cpe210.$EXT tp-link-cpe510-v3.$EXT
    ln -sf tp-link-re200-v1.$EXT tp-link-re200-v2.$EXT
    ln -sf tp-link-re200-v1.$EXT tp-link-re200-v3.$EXT
    ln -sf tp-link-re200-v1.$EXT tp-link-re200-v4.$EXT
    ln -sf tp-link-tl-mr3020-v1.$EXT tp-link-tl-mr3020-v3.$EXT
    ln -sf tp-link-tl-mr3020-v1.$EXT tp-link-tl-wr902ac-v3.$EXT
    ln -sf tp-link-tl-mr3040-v1.$EXT tp-link-tl-mr3040-v2.$EXT
    ln -sf tp-link-tl-mr3420-v2.$EXT tp-link-tl-mr3420-v5.$EXT
    ln -sf tp-link-tl-wa801n-nd-v1.$EXT tp-link-tl-wa801nd-v2.$EXT
    ln -sf tp-link-tl-wa801n-nd-v1.$EXT tp-link-tl-wa801nd-v3.$EXT
    ln -sf tp-link-tl-wa801n-nd-v1.$EXT tp-link-tl-wa801nd-v5.$EXT
    ln -sf tp-link-tl-wa830re-v2.$EXT tp-link-tl-wa830re-v1.$EXT
    ln -sf tp-link-tl-wa901n-nd-v1.$EXT tp-link-tl-wa901n-nd-v2.$EXT
    ln -sf tp-link-tl-wdr3600-v1.$EXT tp-link-td-w8970-alle.$EXT
    ln -sf tp-link-tl-wdr3600-v1.$EXT tp-link-tl-wdr3500-v1.$EXT
    ln -sf tp-link-tl-wdr4300-v1.$EXT tp-link-tl-wdr4900-v1.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-nd-v2.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-nd-v3.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-nd-v4.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-nd-v5.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-v5.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043n-v5.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043nd-v3.$EXT
    ln -sf tp-link-tl-wr1043nd-v2.$EXT tp-link-tl-wr1043nd-v4.$EXT
    ln -sf tp-link-tl-wr710n-v1.$EXT tp-link-tl-wr710n-v2-1.$EXT
    ln -sf tp-link-tl-wr710n-v1.$EXT tp-link-tl-wr710n-v2.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr740n-nd-v3.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr740n-nd-v4.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr740n-nd-v5.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr741n-nd-v2.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr741n-nd-v4.$EXT
    ln -sf tp-link-tl-wr740n-nd-v1.$EXT tp-link-tl-wr741n-nd-v5.$EXT
    ln -sf tp-link-tl-wr801n-nd-v2.$EXT tp-link-tl-wa901n-nd-v3.$EXT
    ln -sf tp-link-tl-wr801n-nd-v2.$EXT tp-link-tl-wa901n-nd-v4.$EXT
    ln -sf tp-link-tl-wr801n-nd-v2.$EXT tp-link-tl-wa901n-nd-v5.$EXT
    ln -sf tp-link-tl-wr841n-nd-v11.$EXT tp-link-tl-wr841n-nd-v12.$EXT
    ln -sf tp-link-tl-wr841n-nd-v11.$EXT tp-link-tl-wr841n-nd-v13.$EXT
    # v13 renamed without nd?
    ln -sf tp-link-tl-wr841n-nd-v11.$EXT tp-link-tl-wr841n-v13.$EXT
    ln -sf tp-link-tl-wr841n-nd-v3.$EXT tp-link-tl-wr841n-nd-v10.$EXT
    ln -sf tp-link-tl-wr841n-nd-v3.$EXT tp-link-tl-wr841n-nd-v5.$EXT
    ln -sf tp-link-tl-wr841n-nd-v3.$EXT tp-link-tl-wr841n-nd-v7.$EXT
    ln -sf tp-link-tl-wr841n-nd-v3.$EXT tp-link-tl-wr841n-nd-v8.$EXT
    ln -sf tp-link-tl-wr841n-nd-v3.$EXT tp-link-tl-wr841n-nd-v9.$EXT
    ln -sf tp-link-tl-wr842n-nd-v1.$EXT tp-link-tl-wr842n-nd-v2.$EXT
    ln -sf tp-link-tl-wr940n-v1.$EXT tp-link-tl-wr940n-v2.$EXT
    ln -sf tp-link-tl-wr940n-v3.$EXT tp-link-tl-wr940n-v4.$EXT
    ln -sf tp-link-tl-wr940n-v3.$EXT tp-link-tl-wr940n-v6.$EXT
    ln -sf tp-link-tl-wr940n-v3.$EXT tp-link-tl-wr941n-nd-v6.$EXT
    ln -sf tp-link-tl-wr941n-nd-v2.$EXT tp-link-tl-wr941n-nd-v3.$EXT
    ln -sf tp-link-tl-wr941n-nd-v2.$EXT tp-link-tl-wr941n-nd-v4.$EXT
    ln -sf tp-link-tl-wr941n-nd-v2.$EXT tp-link-tl-wr941n-nd-v5.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs210-v1-20.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs210-v1.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs510-v1-20.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs510-v1.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs210-v2.$EXT
    ln -sf tp-link-wbs210.$EXT tp-link-wbs210-v2-0.$EXT
    ln -sf ubiquiti-bullet-m.$EXT ubiquiti-bullet-m2.$EXT
    ln -sf ubiquiti-bullet-m.$EXT ubiquiti-bullet-m5.$EXT
    # ERX has been renamed
    ln -sf ubiquiti-edgerouter-x.$EXT ubnt-erx.$EXT
    ln -sf ubiquiti-edgerouter-x-sfp.$EXT ubnt-erx-sfp.$EXT
    ln -sf ubiquiti-loco-m.$EXT ubiquiti-loco-m-xw.$EXT
    ln -sf ubiquiti-loco-m.$EXT ubiquiti-nanostation-loco-m2.$EXT
    ln -sf ubiquiti-loco-m.$EXT ubiquiti-nanostation-loco-m5.$EXT
    ln -sf ubiquiti-nanostation-m.$EXT ubiquiti-nanostation-m-xw.$EXT
    ln -sf ubiquiti-nanostation-m.$EXT ubiquiti-nanostation-m2.$EXT
    ln -sf ubiquiti-nanostation-m.$EXT ubiquiti-nanostation-m5.$EXT
    ln -sf ubiquiti-picostation-m.$EXT ubiquiti-picostation-m2.$EXT
    ln -sf ubiquiti-rocket-m.$EXT ubiquiti-rocket-m-xw.$EXT
    ln -sf ubiquiti-rocket-m.$EXT ubiquiti-rocket-m2.$EXT
    ln -sf ubiquiti-rocket-m.$EXT ubiquiti-rocket-m5.$EXT
    ln -sf ubiquiti-unifi-ac-lite.$EXT ubiquiti-unifi-ac-lite-mesh.$EXT
    ln -sf ubiquiti-unifi-ac-pro.$EXT ubiquiti-unifi-ap-pro.$EXT
    ln -sf vocore-v2.$EXT vocore2.$EXT
    ln -sf wd-my-net-n600.$EXT wd-my-net-n750.$EXT
    ln -sf xiaomi-mi-router-4a-gigabit-edition.$EXT xiaomi-mi-router-4a-100m-edition.$EXT
    ln -sf xiaomi-mi-router-4a-gigabit-edition.$EXT xiaomi-mi-router-4a-100m-international-edition.$EXT
    ln -sf xiaomi-mi-router-4c.$EXT xiaomi-mi-router-3g.$EXT
    ln -sf avm-fritz-box-3370.$EXT avm-fritz-box-3370-rev-2-hynix-nand.$EXT
}

cd pictures-svg
create_symlink svg
cd ..

if [ -n "$CREATE_JPG" ];then
    cd pictures-jpg
    create_symlink jpg

    declare -a placeholder_images=(
        "no_picture_available.jpg"
    )
    for file in "${placeholder_images[@]}"
    do
        if [[ -f "${file}" ]]; then
            echo "Skipping existing file ${file}"
            continue
        fi
        wget "https://raw.githubusercontent.com/freifunk-darmstadt/gluon-firmware-selector/master/pictures/${file}"
    done

    cd ..
    cd pictures-png
    create_symlink png
    cd ..
fi
