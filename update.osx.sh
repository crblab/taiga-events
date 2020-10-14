#!/bin/bash
set -eo pipefail

declare base=(
	[alpine]='alpine'
)

variants=(
	alpine
)

dockerRepo="crblab/taiga-events"
latests=(
    master
)

# Remove existing images
echo "reset docker images"
find -E ./images -maxdepth 1 -type d -regex sed -regex '\./images/.*\+' -exec rm -r '{}' \;

echo "update docker images"

for latest in "${latests[@]}"; do
    version=$latest

    for variant in "${variants[@]}"; do
        # Create the version+variant directory with a Dockerfile.
        dir="images/$version/$variant"
        if [ -d "$dir" ]; then
            continue
        fi

        echo "generating $latest [$version] $variant"
        mkdir -p "$dir"

        template="Dockerfile.${base[$variant]}.template"
        cp "$template" "$dir/Dockerfile"

        # Replace the variables.
        sed -i '' 's/%%VARIANT%%/'"$variant/g" "$dir/Dockerfile"
        sed -i '' 's/%%VERSION%%/'"$latest/g" "$dir/Dockerfile"

        # Copy the scripts
        for name in entrypoint.sh config.json; do
            cp "$name" "$dir/$name"
            chmod 755 "$dir/$name"
        done

        if [[ $1 == 'build' ]]; then
            tag="$version-$variant"
            echo "Build Dockerfile for ${tag}"
            docker build -t "${dockerRepo}:${tag}" "${dir}"
        fi
    done
done
