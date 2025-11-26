#!/bin/bash

set -eEu
set -o pipefail  # avoid masking failures in pipes
shopt -s nullglob  # do not run loops if the glob has not found anything
STANDARD_PATH="pictures-svg/*.svg"

convert_file() {
    local file_path="$1"
    local normalized="$2"

    inkscape "${file_path}" --batch-process --export-type=png --export-filename="pictures-png/$normalized.png" --export-background-opacity=0
    # as not all SVG are updated to have no borders, trim unnecessary white borders from png
    mogrify -trim "pictures-png/$normalized.png"
    # even though mogrify trims the png, we need to trim again for the jpg
    convert "pictures-png/$normalized.png" -resize 65536@\> -background white -flatten -alpha off -trim "pictures-jpg/$normalized.jpg"
    # transfer license and author tags to jpg
    exiftool -overwrite_original -tagsfromfile "pictures-png/$normalized.png" "pictures-jpg/$normalized.jpg"
}

# Take optional file, to only convert one file (or another path)
FILE_PATH=${1:-STANDARD_PATH}

# convert svg to jpg and png if needed
CREATE_JPG=${CREATE_JPG:-true}

if [[ "${CREATE_JPG}" == "true" ]]; then
    echo "creating jpg folders"
    mkdir -p pictures-jpg
    mkdir -p pictures-png
fi

for file in $FILE_PATH; do
    normalized=${file##pictures-svg/}
    normalized=${normalized%.svg}
    normalized="$(echo "$normalized" | sed -e 's/fritzbox/fritz-box/ig' -e 's/[^a-z0-9\.\-]/-/ig')"
    if [[ "${FILE_PATH}" == "${STANDARD_PATH}" ]]; then
        file=pictures-svg/$normalized.svg
    fi

    if [ "$file" == "pictures-svg/no_picture_available.svg" ]; then
        normalized="no_picture_available"
    fi

    if [ "$file" != "pictures-svg/$normalized.svg" ]; then
        mv "$file" pictures-svg/"$normalized".svg
    fi

    if [[ "${CREATE_JPG}" != "true" ]]; then
        continue
    fi

    if [[ -L "${file}" ]]; then
        link_filepath=$(readlink -f "${file}")
        link_file=$(basename "$link_filepath")
        link_name="${link_file%.svg}"
        echo "Symlinking $normalized to $link_name. Skipping conversion."
        ln -sf "$link_name.png" "pictures-png/$normalized.png"
        ln -sf "$link_name.jpg" "pictures-jpg/$normalized.jpg"
    else
        convert_file "${file}" "${normalized}"
    fi
done;
