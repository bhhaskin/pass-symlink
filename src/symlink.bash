#!/bin/bash

local sourcePath="$1"
local targetPath="$2"
local targetDirectory="$PREFIX/"$(dirname "$targetPath")""
check_sneaky_paths "$sourcePath" "$targetPath" "$targetDirectory"

local passfile="$sourcePath.gpg"
local targetfile="$targetPath.gpg"
local symFile=$(basename "$targetfile")
local parent_path=$(echo "$targetfile" | sed -e "s|[^/]||g" -e "s|/|../|g")


if [[ -f "$PREFIX/$passfile" ]]; then
    if [[ ! -d $targetDirectory ]]; then
        mkdir -p "$targetDirectory"
    fi
    cd "$targetDirectory"
    if [[ -f "$PREFIX/$targetfile" ]]; then
        die "Error: $targetPath already exists"
    elif [[ -z $targetPath ]]; then
        die "Error: Target path is missing"
    fi
    ln -s "$parent_path$passfile" "$symFile" || exit $?
    if [[ -d "$PREFIX/.git" ]]; then
        git add . --quiet && git commit -am "Created symlink of \"$sourcePath\" as \"$targetPath\"" --quiet
    fi
elif [[ -z $sourcePath ]]; then
    die "Error: Source path is missing"
else
    die "Error: $sourcePath is not in the password store."
fi