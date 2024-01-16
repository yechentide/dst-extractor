#!/usr/bin/env bash
set -eu

repo_root=$(cd "$(dirname "$0")"; pwd)
declare -r repo_root

# path to scripts.zip in the DST server directory
declare -r script_zip_file="$1"

if [[ $# == 2 ]]; then
    output_dir="$2"
else
    output_dir="$repo_root/output"
    echo "Using default output dir: $output_dir"
fi
declare -r output_dir
if [[ ! -e "$output_dir" ]]; then
    mkdir -p "$output_dir"
fi

declare -r work_dir='/tmp/dst-worldgen-cache'
declare -r unzipped_script_dir="$work_dir/scripts"
declare -r target_script_dir="$work_dir/target"

########## ########## ########## ########## ########## ##########

function unzip_script_file() {
    if [[ -e $work_dir ]]; then
        rm -rf $work_dir > /dev/null 2>&1
    fi

    echo "Unzip $script_zip_file to $work_dir ..."
    mkdir -p $work_dir
    unzip -q -d $work_dir "$script_zip_file"
}

function copy_files_from_unzipped() {
    echo "Copy files from $unzipped_script_dir to $target_script_dir ..."
    if [[ ! -e $target_script_dir ]]; then mkdir -p $target_script_dir; fi

    cp -r $unzipped_script_dir/languages $target_script_dir

    mkdir -p $target_script_dir/map
    cp -r $unzipped_script_dir/map/levels                   $target_script_dir/map
    cp -r $unzipped_script_dir/map/tasksets                 $target_script_dir/map
    cp $unzipped_script_dir/map/customize.lua               $target_script_dir/map
    cp $unzipped_script_dir/map/level.lua                   $target_script_dir/map
    cp $unzipped_script_dir/map/levels.lua                  $target_script_dir/map
    cp $unzipped_script_dir/map/locations.lua               $target_script_dir/map
    cp $unzipped_script_dir/map/resource_substitution.lua   $target_script_dir/map
    cp $unzipped_script_dir/map/settings.lua                $target_script_dir/map
    cp $unzipped_script_dir/map/startlocations.lua          $target_script_dir/map
    cp $unzipped_script_dir/map/tasksets.lua                $target_script_dir/map

    cp $unzipped_script_dir/constants.lua                   $target_script_dir
    cp $unzipped_script_dir/strings.lua                     $target_script_dir

    cp $unzipped_script_dir/class.lua                       $target_script_dir
    cp $unzipped_script_dir/strict.lua                      $target_script_dir
    cp $unzipped_script_dir/translator.lua                  $target_script_dir

    cp $unzipped_script_dir/speech_*.lua                    $target_script_dir
    cp $unzipped_script_dir/beefalo_clothing.lua            $target_script_dir
    cp $unzipped_script_dir/clothing.lua                    $target_script_dir
    cp $unzipped_script_dir/emote_items.lua                 $target_script_dir
    cp $unzipped_script_dir/item_blacklist.lua              $target_script_dir
    cp $unzipped_script_dir/misc_items.lua                  $target_script_dir
    cp $unzipped_script_dir/prefabskins.lua                 $target_script_dir
    cp $unzipped_script_dir/skin_strings.lua                $target_script_dir
    cp $unzipped_script_dir/techtree.lua                    $target_script_dir
    cp $unzipped_script_dir/tuning.lua                      $target_script_dir
    cp $unzipped_script_dir/worldsettings_overrides.lua     $target_script_dir
}

function copy_lua_files_from_repo() {
    echo "Copy lua files from repo to $target_script_dir ..."

    cp "$repo_root"/mock/map/*.lua $target_script_dir/map
    cp "$repo_root"/mock/*.lua $target_script_dir
    cp "$repo_root"/main.lua $target_script_dir
}

unzip_script_file
copy_files_from_unzipped
copy_lua_files_from_repo

cd $target_script_dir
if which luajit > /dev/null 2>&1; then
    luajit ./main.lua "$target_script_dir/languages" "$output_dir"
else
    lua ./main.lua "$target_script_dir/languages" "$output_dir"
fi

echo ''
echo "Done!"
