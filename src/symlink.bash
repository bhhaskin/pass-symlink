#!/bin/bash

local sourcePath="$1"
local targetPath="$2"
check_sneaky_paths "$sourcePath" "$targetPath"

local passfile="$sourcePath.gpg"
local targetfile="$targetPath.gpg"
local symFile=$(basename "$targetfile")
local parent_path=$(echo "$targetfile" | sed -e "s|[^/]||g" -e "s|/|../|g")


if [[ -f "$PREFIX/$passfile" ]]; then
    cd "$PREFIX/"$(dirname "$targetPath")""
    if [[ -f "$PREFIX/$targetfile" ]]; then
        die "Error: $targetPath already exists"
    fi
    ln -s "$parent_path$passfile" "$symFile" || exit $?
elif [[ -z $sourcePath ]]; then
    die ""
else
    die "Error: $sourcePath is not in the password store."
fi