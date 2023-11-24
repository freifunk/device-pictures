#!/usr/bin/env bash

set -eEu
set -o pipefail  # avoid masking failures in pipes
shopt -s nullglob  # do not run loops if the glob has not found anything

CURRENT_DIR=$PWD

create_initial(){
	local repo_url=${1}
	local repo=${2}
	local img_path=${3:-.}
	local svg_name=${4:-.svg}

	echo "cloning ${repo_url}"
	mkdir -p repos
	set +e
	git clone "${repo_url}" "${repo}"
	set -e

	mkdir -p pictures-svg
	for file in $repo$img_path/*$svg_name; do
		file_short=${file#"$repo"}

		echo "---------------------"
		echo "${file_short} from ${file}"

		authors=$(git -C $repo log -n1 --format="source: $repo_url/commit/%H%nCo-authored-by: %an <%ae>" -- $file_short)
	
		file_short_without_path=${file_short#"$img_path/"}
		device_name=${file_short_without_path%%"$svg_name"}

		similar_devices=""

		case $device_name in
			# duplicate - don't use 3d version
			gl.inet-gl-ar750) continue ;;
			# wrong model name
			gl.inet_gl-mt300a ) device_name=gl-mt300a ;;
			gl.inet_gl-mt300n ) device_name=gl-mt300n similar_devices="friendlyelec-nanopi-r2s" ;;
			gl.inet_gl-mt750 ) device_name=gl-mt750 ;;
			gl.inet_vixmini ) device_name=gl-inet-vixmini ;;
			ocedo_indoor ) device_name=ocedo-koala ;;
			netgear-ex6150v2 ) device_name=netgear-ex6150 ;;
			raspberry-pi_model-b ) device_name=raspberrypi ;;
			raspberry-pi_v2-model-b ) device_name=raspberrypi-2 ;;
			raspberry-pi_v3-model-b ) device_name=raspberrypi-3 ;;
			openmesh_om2p-hs ) device_name=openmesh-om2p ;;
			openmesh_om5p-ac ) device_name=openmesh-om5p ;;
			alfa-ap121 ) similar_devices="alfa-ap121u" ;;
			alfa-ap121u) continue ;;
			tp-link-archer-c7-v2 ) similar_devices="tp-link-archer-c7-v5" ;;
			tp-link-archer-c7-v5) continue ;;
			tp-link-tl-wa801n-nd-v1 ) similar_devices="tp-link-tl-wa801n-nd-v2 tp-link-tl-wa801n-nd-v3" ;;
			tp-link-tl-wa801n-nd*) continue ;;
			aerohive_ap121 ) device_name=aerohive-hiveap-121 ;;
			aerohive_ap330 ) device_name=aerohive-hiveap-330 ;;
			tp-link-tl-wr841n-nd-v5 ) similar_devices="tp-link-tl-wr841n-nd-v10 tp-link-tl-wr841n-nd-v7 tp-link-tl-wr841n-nd-v8 tp-link-tl-wr841n-nd-v9" ;;
			tp-link-tl-wr841n-nd-v10 | tp-link-tl-wr841n-nd-v7 | tp-link-tl-wr841n-nd-v8 | tp-link-tl-wr841n-nd-v9 ) continue ;;
			tp-link-archer-c6-v2 ) similar_devices="tp-link-archer-c6-v2-eu-ru-jp" ;;
			tp-link-archer-c6-v2-eu-ru-jp ) continue ;;
			tp-link-tl-mr3040-v1 ) similar_devices="tp-link-tl-mr3040-v2" ;;
			tp-link-tl-mr3040-v2 ) continue ;;
			tp-link-tl-wr940n-v3 ) similar_devices="tp-link-tl-wr940n-v4 tp-link-tl-wr940n-v6 tp-link-tl-wr941n-nd-v6" ;;
			tp-link-tl-wr940n-v4 | tp-link-tl-wr940n-v6 | tp-link-tl-wr941n-nd-v6 ) continue ;;
			ubiquiti-picostation-m ) similar_devices="ubiquiti-picostation-m2" ;;
			ubiquiti-picostation-m2 ) continue ;;
			tp-link-tl-wr710n-v1 ) similar_devices="tp-link-tl-wr710n-v2-1 tp-link-tl-wr710n-v2" ;;
			tp-link-tl-wr710n-v2-1 | tp-link-tl-wr710n-v2 ) continue ;;
			aerohive-ap330 ) similar_devices="aerohive-hiveap-330" ;;
			aerohive-hiveap-330 ) continue ;;
			wd-my-net-n600 ) similar_devices="wd-my-net-n750" ;;
			wd-my-net-n750 ) continue ;;
			aerohive-ap121 ) similar_devices="aerohive-hiveap-121" ;;
			aerohive-hiveap-121 ) continue ;;
			ubiquiti-loco-m ) similar_devices="ubiquiti-loco-m-xw ubiquiti-nanostation-loco-m5" ;;
			ubiquiti-loco-m-xw | ubiquiti-nanostation-loco-m5 ) continue ;;
			tp-link-tl-wr1043nd-v2 ) similar_devices="tp-link-tl-wr1043nd-v3 tp-link-tl-wr1043nd-v4 tp-link-tl-wr1043n-nd-v2 tp-link-tl-wr1043n-nd-v3 tp-link-tl-wr1043n-nd-v5 tp-link-tl-wr1043n-v5" ;;
			tp-link-tl-wr1043nd-v3 | tp-link-tl-wr1043nd-v4 | tp-link-tl-wr1043n-nd-v2 | tp-link-tl-wr1043n-nd-v3 | tp-link-tl-wr1043n-nd-v5 | tp-link-tl-wr1043n-v5 ) continue ;;
			tp-link-tl-wa830re-v1 ) similar_devices="tp-link-tl-wa830re-v2" ;;
			tp-link-tl-wa830re-v2 ) continue ;;
			avm-fritz-box-7362-sl ) similar_devices="avm-fritz-box-7320" ;;
			avm-fritz-box-7320 ) continue ;;
			gl-inet-6408a-v1 ) similar_devices="gl-inet-6416a-v1" ;;
			gl-inet-6416a-v1 ) continue ;;
			netgear-wndr3700 ) similar_devices="netgear-wndr3700v2 netgear-wndr3700v4" ;;
			netgear-wndr3700v2 | netgear-wndr3700v4 ) continue ;;
			tp-link-re200-v1 ) similar_devices="tp-link-re200-v2 tp-link-re200-v3 tp-link-re200-v4" ;;
			tp-link-re200-v2 | tp-link-re200-v3 | tp-link-re200-v4 ) continue ;;
			ubiquiti-bullet-m2 ) similar_devices="ubiquiti-bullet-m5 ubiquiti-bullet-m" ;;
			ubiquiti-bullet-m5 | ubiquiti-bullet-m ) continue ;;
			tp-link-tl-wr940n-v1 ) similar_devices="tp-link-tl-wr940n-v2" ;;
			tp-link-tl-wr940n-v2 ) continue ;;
			tp-link-tl-wa901n-nd-v3 ) similar_devices="tp-link-tl-wa901n-nd-v4 tp-link-tl-wa901n-nd-v5 tp-link-tl-wr801n-nd-v2" ;;
			tp-link-tl-wa901n-nd-v4 | tp-link-tl-wa901n-nd-v5 | tp-link-tl-wr801n-nd-v2 ) continue ;;
			tp-link-tl-wa901n-nd-v1 ) similar_devices="tp-link-tl-wr941n-nd-v2 tp-link-tl-wr941n-nd-v3 tp-link-tl-wr941n-nd-v4 tp-link-tl-wr941n-nd-v5" ;;
			tp-link-tl-wr941n-nd-v2 | tp-link-tl-wr941n-nd-v3 | tp-link-tl-wr941n-nd-v4 | tp-link-tl-wr941n-nd-v5 ) continue ;;
			ubiquiti-nanostation-m-xw ) similar_devices="ubiquiti-nanostation-m2 ubiquiti-nanostation-m5" ;;
			ubiquiti-nanostation-m2 | ubiquiti-nanostation-m5 ) continue ;;
			tp-link-archer-c6u-v1 ) similar_devices="tp-link-archer-c6-v3" ;;
			tp-link-archer-c6-v3 ) continue ;;
			gl-inet-gl-ar300m16 ) similar_devices="gl-inet-gl-ar300m-nor gl-inet-gl-ar300m" ;;
			gl-inet-gl-ar300m-nor | gl-inet-gl-ar300m ) continue ;;
			tp-link-archer-c60-v1 ) similar_devices="tp-link-archer-c60-v2" ;;
			tp-link-archer-c60-v2 ) continue ;;
			tp-link-tl-wr740n-nd-v1 ) similar_devices="tp-link-tl-wr740n-nd-v3 tp-link-tl-wr740n-nd-v4 tp-link-tl-wr740n-nd-v5 tp-link-tl-wr741n-nd-v2 tp-link-tl-wr741n-nd-v4 tp-link-tl-wr741n-nd-v5" ;;
			tp-link-tl-wr740n-nd-v3 | tp-link-tl-wr740n-nd-v4 | tp-link-tl-wr740n-nd-v5 | tp-link-tl-wr741n-nd-v2 | tp-link-tl-wr741n-nd-v4 | tp-link-tl-wr741n-nd-v5 ) continue ;;
			tp-link-tl-wr841n-nd-v11 ) similar_devices="tp-link-tl-wr841n-nd-v12 tp-link-tl-wr841n-v13" ;;
			tp-link-tl-wr841n-nd-v12 | tp-link-tl-wr841n-v13 ) continue ;;
			tp-link-cpe210 ) similar_devices="tp-link-cpe210-v1 tp-link-cpe210-v2 tp-link-cpe210-v3 tp-link-cpe220-v3 tp-link-cpe510-v1-0 tp-link-cpe510-v1-1 tp-link-cpe510-v1" ;;
			tp-link-cpe210-v1 | tp-link-cpe210-v2 | tp-link-cpe210-v3 | tp-link-cpe220-v3 | tp-link-cpe510-v1-0 | tp-link-cpe510-v1-1 | tp-link-cpe510-v1 ) continue ;;
			avm-fritz-box-7360 ) similar_devices="avm-fritz-box-7360-v2" ;;
			avm-fritz-box-7360-v2 ) continue ;;
			openmesh-mr600-v1 ) similar_devices="openmesh-mr600-v2 openmesh-mr900-v1 openmesh-mr900-v2" ;;
			openmesh-mr600-v2 | openmesh-mr900-v1 | openmesh-mr900-v2 ) continue ;;
			netgear-r6220 ) similar_devices="netgear-wac104" ;;
			netgear-wac104 ) continue ;;
			ubiquiti-rocket-m2 ) similar_devices="ubiquiti-rocket-m5 ubiquiti-rocket-m ubiquiti-rocket-m-xw" ;;
			ubiquiti-rocket-m5 | ubiquiti-rocket-m | ubiquiti-rocket-m-xw ) continue ;;
			avm-fritz-box-3370 ) similar_devices="avm-fritz-box-3370-rev-2-micron-nand" ;;
			avm-fritz-box-3370-rev-2-micron-nand ) continue ;;
			avm-fritz-wlan-repeater-450e  ) similar_devices="avm-fritz-wlan-repeater-300e" ;;

		esac

		# normalize device names
		device_name="$(echo "$device_name" | sed -e 's/fritzbox/fritz-box/ig' -e 's/[^a-z0-9\.\-]/-/ig')"

		for sim_dev in $similar_devices; do
			pushd "$CURRENT_DIR"/pictures-svg
			ln -sfr "${device_name}.svg" "${sim_dev}".svg
			git add "${sim_dev}".svg
			popd
		done;


		if [[ -L $file ]]; then
			link_filepath=$(readlink -f "${file}")
			link_file=$(basename "${link_filepath}")
			link_name="${link_file%.svg}"
			pushd "$CURRENT_DIR"/pictures-svg
			ln -sfr "${link_file}" "${device_name}".svg
			popd
		else
			cp "$file" pictures-svg/"$device_name".svg
		fi

		status_output=$(git status --porcelain -- "pictures-svg/$device_name.svg")
		if [[ -n "$status_output" ]]; then
			git add pictures-svg/"$device_name".svg
			git commit -m "add $device_name" -m "$authors"
		fi
	done;
}

create_initial https://github.com/Moorviper/Freifunk-Router-Anleitungen repos/Freifunk-Router-Anleitungen/ router /front.svg
create_initial https://github.com/belzebub40k/router-pics repos/router-pics/
create_initial https://github.com/nalxnet/freifunk-device-images repos/freifunk-device-images/
create_initial https://github.com/freifunkstuff/meshviewer-hwimages repos/meshviewer-hwimages/ hwimg

set +e
pushd "$CURRENT_DIR"/pictures-svg
ln -s 8devices-jalapeno-board.svg  8devices-jalapeno.svg
ln -s aerohive-ap330.svg  aerohive-hiveap-330.svg
ln -s aerohive-hiveap-121.svg  aerohive-ap121.svg
ln -s alfa-ap121.svg  alfa-ap121u.svg
ln -s avm-fritz-box-7360.svg  avm-fritz-box-7430.svg
ln -s avm-fritz-box-3370.svg  avm-fritz-box-3370-rev-2-micron-nand.svg
ln -s avm-fritz-box-7362-sl.svg avm-fritz-box-7320.svg  
ln -s avm-fritz-box-7360-v2.svg  avm-fritz-box-7360.svg
ln -s avm-fritz-wlan-repeater-450e.svg  avm-fritz-wlan-repeater-300e.svg
ln -s devolo-wifi-pro-1200i.svg  devolo-wifi-pro-1750i.svg
ln -s d-link-dap-x1860-a1.svg  d-link-dap-x1860.svg
ln -s d-link-covr-x1860-a1.svg  d-link-covr-x1860.svg
ln -s d-link-dir-825-rev-b1.svg  d-link-dir-825b1.svg
ln -s d-link-dir-860l.svg  d-link-dir-860l-b1.svg
ln -s gl-inet-6408a-v1.svg  gl-inet-6416a-v1.svg
ln -s gl-inet-gl-ar300m16.svg  gl-inet-gl-ar300m-nor.svg
ln -s gl-inet-gl-ar300m.svg  gl.inet-gl-ar300m-lite.svg
ln -s gl-inet-gl-ar300m.svg  gl.inet-gl-ar300m.svg
ln -s gl-inet-gl-ar750.svg  gl.inet-gl-ar750.svg
ln -s gl.inet-gl-ar750s.svg  gl-inet-gl-ar750s.svg
ln -s gl.inet-gl-ar750s.svg  gl.inet-gl-ar750s-nor.svg
ln -s gl-inet-gl-ar150.svg  gl.inet-gl-ar150.svg
ln -s gl-inet-vixmini.svg  gl.inet-vixmini.svg
ln -s netgear-dgn3500.svg  netgear-dgn3500b.svg
ln -s netgear-ex3700.svg  netgear-ex3800.svg
ln -s netgear-ex3700.svg  netgear-ex3700-ex3800.svg
ln -s netgear-ex6150.svg  netgear-ex6100.svg
ln -s netgear-ex6150.svg  netgear-ex6150v2.svg
ln -s netgear-r6220.svg  netgear-wac104.svg
ln -s netgear-r7800.svg  netgear-nighthawk-x4s-r7800.svg
ln -s netgear-wndr3700.svg  netgear-wndr3700v2.svg
ln -s netgear-wndr3700.svg  netgear-wndr3700v4.svg
ln -s netgear-wndr3800.svg  netgear-wndr3800chmychart.svg
ln -s nexx-wt3020.svg  nexx-wt3020ad.svg
ln -s nexx-wt3020.svg  nexx-wt3020f.svg
ln -s nexx-wt3020.svg  nexx-wt3020h.svg
ln -s ocedo-koala.svg  ocedo-raccoon.svg
ln -s openmesh-a40.svg  openmesh-a42.svg
ln -s openmesh-a40.svg  openmesh-a60.svg
ln -s openmesh-a40.svg  openmesh-a62.svg
ln -s openmesh-mr900-v2.svg  openmesh-mr1750.svg
ln -s openmesh-mr600-v1.svg  openmesh-mr600-v2.svg
ln -s openmesh-mr600-v1.svg  openmesh-mr900-v1.svg
ln -s openmesh-mr600-v1.svg  openmesh-mr900-v2.svg
ln -s openmesh-om2p.svg  openmesh-om2p-lc.svg
ln -s openmesh-om2p.svg  openmesh-om2p-hs.svg
ln -s openmesh-om5p.svg  openmesh-om5p-an.svg
ln -s openmesh-om5p.svg  openmesh-om5p-ac.svg
ln -s raspberrypi.svg  raspberry-pi-modelb-b-rev-1.svg
ln -s raspberrypi.svg  raspberry-pi-modelb-b-rev-2.svg
ln -s raspberrypi-2.svg  raspberry-pi-2-model-b-rev-1.1.svg
ln -s raspberrypi-2.svg  raspberry-pi-2-model-b-rev-1-1.svg
ln -s raspberrypi-3.svg  raspberry-pi-3-model-b-rev-1.2.svg
ln -s raspberrypi-3.svg  raspberry-pi-3-model-b-rev-1-2.svg
ln -s raspberrypi.svg  raspberry-pi.svg
ln -s raspberrypi-2.svg  raspberry-pi-2.svg
ln -s raspberrypi-3.svg  raspberry-pi-3.svg
ln -s tp-link-archer-c20i.svg  tp-link-archer-c20i-alle.svg
ln -s tp-link-archer-c20-v1.svg  tp-link-archer-c20-v5.svg
ln -s tp-link-archer-c2-v1.svg  tp-link-archer-c2-v2.svg
ln -s tp-link-archer-c2-v1.svg  tp-link-archer-c2-v3.svg
ln -s tp-link-archer-c6-v2.svg  tp-link-archer-c6-v2-eu-ru-jp.svg
ln -s tp-link-archer-c60-v2.svg  tp-link-archer-c60-v1.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-archer-c59-v1.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-archer-c7-v4.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-archer-c7-v5.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-archer-a7-v5.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-td-w8980-alle.svg
ln -s tp-link-archer-c7-v2.svg  tp-link-td-w9980-alle.svg
ln -s tp-link-cpe210.svg  tp-link-cpe210-v1.svg
ln -s tp-link-cpe210.svg  tp-link-cpe210-v2.svg
ln -s tp-link-cpe210.svg  tp-link-cpe210-v2.svg
ln -s tp-link-cpe210.svg  tp-link-cpe210-v3.svg
ln -s tp-link-cpe210.svg  tp-link-cpe210-v3.svg
ln -s tp-link-cpe210.svg  tp-link-cpe220-v1.svg
ln -s tp-link-cpe210.svg  tp-link-cpe220-v3.svg
ln -s tp-link-cpe210.svg  tp-link-cpe220-v3.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v1-0.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v1-1.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v1.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v1.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v2.svg
ln -s tp-link-cpe210.svg  tp-link-cpe510-v3.svg
ln -s tp-link-re200-v1.svg  tp-link-re200-v2.svg
ln -s tp-link-re200-v1.svg  tp-link-re200-v3.svg
ln -s tp-link-re200-v1.svg  tp-link-re200-v4.svg
ln -s tp-link-tl-mr3020-v1.svg  tp-link-tl-mr3020-v3.svg
ln -s tp-link-tl-mr3020-v1.svg  tp-link-tl-wr902ac-v3.svg
ln -s tp-link-tl-mr3040-v1.svg  tp-link-tl-mr3040-v2.svg
ln -s tp-link-tl-mr3420-v2.svg  tp-link-tl-mr3420-v5.svg
ln -s tp-link-tl-wa801n-nd-v1.svg  tp-link-tl-wa801nd-v2.svg
ln -s tp-link-tl-wa801n-nd-v1.svg  tp-link-tl-wa801nd-v3.svg
ln -s tp-link-tl-wa801n-nd-v1.svg  tp-link-tl-wa801nd-v5.svg
ln -s tp-link-tl-wa830re-v2.svg  tp-link-tl-wa830re-v1.svg
ln -s tp-link-tl-wa901n-nd-v1.svg  tp-link-tl-wa901n-nd-v2.svg
ln -s tp-link-tl-wdr3600-v1.svg  tp-link-td-w8970-alle.svg
ln -s tp-link-tl-wdr3600-v1.svg  tp-link-tl-wdr3500-v1.svg
ln -s tp-link-tl-wdr4300-v1.svg  tp-link-tl-wdr4900-v1.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-nd-v2.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-nd-v3.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-nd-v4.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-nd-v5.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-v5.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043n-v5.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043nd-v3.svg
ln -s tp-link-tl-wr1043nd-v2.svg  tp-link-tl-wr1043nd-v4.svg
ln -s tp-link-tl-wr710n-v1.svg  tp-link-tl-wr710n-v2-1.svg
ln -s tp-link-tl-wr710n-v1.svg  tp-link-tl-wr710n-v2.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr740n-nd-v3.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr740n-nd-v4.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr740n-nd-v5.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr741n-nd-v2.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr741n-nd-v4.svg
ln -s tp-link-tl-wr740n-nd-v1.svg  tp-link-tl-wr741n-nd-v5.svg
ln -s tp-link-tl-wr801n-nd-v2.svg  tp-link-tl-wa901n-nd-v3.svg
ln -s tp-link-tl-wr801n-nd-v2.svg  tp-link-tl-wa901n-nd-v4.svg
ln -s tp-link-tl-wr801n-nd-v2.svg  tp-link-tl-wa901n-nd-v5.svg
ln -s tp-link-tl-wr841n-nd-v11.svg  tp-link-tl-wr841n-nd-v12.svg
ln -s tp-link-tl-wr841n-nd-v11.svg  tp-link-tl-wr841n-nd-v13.svg
ln -s tp-link-tl-wr841n-nd-v11.svg  tp-link-tl-wr841n-v13.svg
ln -s tp-link-tl-wr841n-nd-v3.svg  tp-link-tl-wr841n-nd-v10.svg
ln -s tp-link-tl-wr841n-nd-v3.svg  tp-link-tl-wr841n-nd-v5.svg
ln -s tp-link-tl-wr841n-nd-v3.svg  tp-link-tl-wr841n-nd-v7.svg
ln -s tp-link-tl-wr841n-nd-v3.svg  tp-link-tl-wr841n-nd-v8.svg
ln -s tp-link-tl-wr841n-nd-v3.svg  tp-link-tl-wr841n-nd-v9.svg
ln -s tp-link-tl-wr842n-nd-v1.svg  tp-link-tl-wr842n-nd-v2.svg
ln -s tp-link-tl-wr940n-v1.svg  tp-link-tl-wr940n-v2.svg
ln -s tp-link-tl-wr940n-v3.svg  tp-link-tl-wr940n-v4.svg
ln -s tp-link-tl-wr940n-v3.svg  tp-link-tl-wr940n-v6.svg
ln -s tp-link-tl-wr940n-v3.svg  tp-link-tl-wr941n-nd-v6.svg
ln -s tp-link-tl-wr941n-nd-v2.svg  tp-link-tl-wr941n-nd-v3.svg
ln -s tp-link-tl-wr941n-nd-v2.svg  tp-link-tl-wr941n-nd-v4.svg
ln -s tp-link-tl-wr941n-nd-v2.svg  tp-link-tl-wr941n-nd-v5.svg
ln -s tp-link-wbs210.svg  tp-link-wbs210-v1-20.svg
ln -s tp-link-wbs210.svg  tp-link-wbs210-v1.svg
ln -s tp-link-wbs210.svg  tp-link-wbs510-v1-20.svg
ln -s tp-link-wbs210.svg  tp-link-wbs510-v1.svg
ln -s tp-link-wbs210.svg  tp-link-wbs210-v2.svg
ln -s tp-link-wbs210.svg  tp-link-wbs210-v2-0.svg
ln -s ubiquiti-bullet-m.svg  ubiquiti-bullet-m2.svg
ln -s ubiquiti-bullet-m.svg  ubiquiti-bullet-m5.svg
ln -s ubiquiti-edgerouter-x.svg  ubnt-erx.svg
ln -s ubiquiti-edgerouter-x-sfp.svg  ubnt-erx-sfp.svg
ln -s ubiquiti-loco-m.svg  ubiquiti-loco-m-xw.svg
ln -s ubiquiti-loco-m.svg  ubiquiti-nanostation-loco-m2.svg
ln -s ubiquiti-loco-m.svg  ubiquiti-nanostation-loco-m5.svg
ln -s ubiquiti-nanostation-m.svg  ubiquiti-nanostation-m-xw.svg
ln -s ubiquiti-nanostation-m.svg  ubiquiti-nanostation-m2.svg
ln -s ubiquiti-nanostation-m.svg  ubiquiti-nanostation-m5.svg
ln -s ubiquiti-picostation-m.svg  ubiquiti-picostation-m2.svg
ln -s ubiquiti-rocket-m.svg  ubiquiti-rocket-m-xw.svg
ln -s ubiquiti-rocket-m.svg  ubiquiti-rocket-m2.svg
ln -s ubiquiti-rocket-m.svg  ubiquiti-rocket-m5.svg
ln -s ubiquiti-unifi-ac-lite.svg  ubiquiti-unifi-ac-lite-mesh.svg
ln -s ubiquiti-unifi-ac-pro.svg  ubiquiti-unifi-ap-pro.svg
ln -s ubiquiti-unifi.svg  ubiquiti-unifi-ap.svg
ln -s vocore-v2.svg  vocore2.svg
ln -s wd-my-net-n600.svg  wd-my-net-n750.svg
ln -s xiaomi-mi-router-4a-gigabit-edition.svg  xiaomi-mi-router-4a-100m-edition.svg
ln -s xiaomi-mi-router-4a-gigabit-edition.svg  xiaomi-mi-router-4a-100m-international-edition.svg
ln -s xiaomi-mi-router-4c.svg  xiaomi-mi-router-3g.svg
ln -s avm-fritz-box-3370.svg  avm-fritz-box-3370-rev-2-hynix-nand.svg
popd
set -e
