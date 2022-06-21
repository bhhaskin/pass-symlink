#!/bin/bash

local sourcePath="$1"
local targetPath="$2"
local targetDirectory="$PREFIX/"$(dirname "$targetPath")""
check_sneaky_paths "$sourcePath" "$targetPath" "$targetDirectory"

local passfile
local targetfile

if [[ -f "$PREFIX/$sourcePath.gpg" ]]; then
    passfile="$sourcePath.gpg"
    targetfile="$targetPath.gpg"
elif [[ -d "$PREFIX/$sourcePath" ]]; then
    passfile=$sourcePath
    targetfile=$targetPath
elif [[ -z $sourcePath ]]; then
    die "Error: Source path is missing"
else
    die "Error: $sourcePath is not in the password store."
fi

local symFile=$(basename "$targetfile")
local parent_path=$(echo "$targetfile" | sed -e "s|[^/]||g" -e "s|/|../|g")

if [[ -e "$PREFIX/$targetfile" ]]; then
    die "Error: $targetPath already exists"
elif [[ -z $targetPath ]]; then
    die "Error: Target path is missing"
fi

if [[ ! -d $targetDirectory ]]; then
    mkdir -p "$targetDirectory"
fi
cd "$targetDirectory"
ln -s "$parent_path$passfile" "$symFile" || exit $?
if [[ -d "$PREFIX/.git" ]]; then
    git add . && git commit -am "Created symlink of \"$sourcePath\" as \"$targetPath\"" --quiet
fi
