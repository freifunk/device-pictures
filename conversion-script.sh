#!/bin/bash

set -eEu
set -o pipefail  # avoid masking failures in pipes
shopt -s nullglob  # do not run loops if the glob has not found anything

# convert svg to jpg and png if needed
CREATE_JPG=${CREATE_JPG:-true}

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
        normalized="no_picture_available"
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
        # as not all SVG are updated to have no borders, trim unnecessary white borders from png
        mogrify -trim "pictures-png/$normalized.png"
        # even though mogrify trims the png, we need to trim again for the jpg
        convert "pictures-png/$normalized.png" -resize 65536@\> -background white -flatten -alpha off -trim "pictures-jpg/$normalized.jpg"
        convert "pictures-png/$normalized.png" -resize 65536@\> "pictures-png/$normalized.png"
        # transfer license and author tags to jpg
        exiftool -overwrite_original -tagsfromfile "pictures-png/$normalized.png" "pictures-jpg/$normalized.jpg"
    fi
done;
