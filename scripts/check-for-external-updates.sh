#!/bin/bash

set -eEu
set -o pipefail  # avoid masking failures in pipes

if [[ -n "$CHECK_EXTERNAL_REPOS" ]];then
    changes=0
    latest_commits=(
        e50e7c959b3ce853635d70585c213fdbf82acee5 # router-pics
        4d066b22de7ddf8303faeeafabaa4618d9b0b4be # Freifunk-Router-Anleitungen
        c37521feb4f1e71fe5da0863e1810771f96d9529 # freifunk-device-images
        0f2479b8dd6ff60b49776464a934a59f32d1e36d # meshviewer-hwimages
    )

    for repo in \
        https://github.com/belzebub40k/router-pics.git \
        https://github.com/Moorviper/Freifunk-Router-Anleitungen \
        https://github.com/nalxnet/freifunk-device-images \
        https://github.com/freifunkstuff/meshviewer-hwimages
    do
        last_commit=$(git ls-remote "${repo}" HEAD | awk '{ print $1}')
        if [[ " ${latest_commits[*]} " == *" ${last_commit} "* ]]; then
            echo "No changes in repository $repo"
        else
            echo "Warning: repository $repo has changes!"
            changes=$((changes+1))
        fi
    done

    if ((changes > 0)); then
        echo "Warning: $changes changes found".
        exit 1
    fi

    echo "No changes found".
    exit 0
fi
