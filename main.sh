#!/usr/bin/env bash
set -eu

repo_root=$(cd "$(dirname "$0")"; pwd)
declare -r repo_root

declare -r server_root="$1"
declare -r script_zip_file="$server_root/data/databundles/scripts.zip"
declare -r version_file="$server_root/version.txt"

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

declare -r tmp_dir='/tmp/dst-worldgen-cache'
declare -r script_dir="$tmp_dir/scripts"
declare -r work_dir="$tmp_dir/work"

########## ########## ########## ########## ########## ##########

function unzip_script_file() {
    if [[ -e $tmp_dir ]]; then
        rm -rf $tmp_dir > /dev/null 2>&1
    fi

    echo "Unzip $script_zip_file to $tmp_dir ..."
    mkdir -p $tmp_dir
    unzip -q -d $tmp_dir "$script_zip_file"
}

function copy_files_from_unzipped() {
    echo "Copy files from $script_dir to $work_dir ..."
    if [[ ! -e $work_dir ]]; then mkdir -p $work_dir; fi

    cp -r $script_dir/languages                     $work_dir

    mkdir -p $work_dir/map
    cp -r $script_dir/map/levels                    $work_dir/map
    cp -r $script_dir/map/tasksets                  $work_dir/map
    cp $script_dir/map/customize.lua                $work_dir/map
    cp $script_dir/map/level.lua                    $work_dir/map
    cp $script_dir/map/levels.lua                   $work_dir/map
    cp $script_dir/map/locations.lua                $work_dir/map
    cp $script_dir/map/resource_substitution.lua    $work_dir/map
    cp $script_dir/map/settings.lua                 $work_dir/map
    cp $script_dir/map/startlocations.lua           $work_dir/map
    cp $script_dir/map/tasksets.lua                 $work_dir/map

    cp $script_dir/constants.lua                    $work_dir
    cp $script_dir/strings.lua                      $work_dir

    cp $script_dir/class.lua                        $work_dir
    cp $script_dir/strict.lua                       $work_dir
    cp $script_dir/translator.lua                   $work_dir

    cp $script_dir/speech_*.lua                     $work_dir
    cp $script_dir/beefalo_clothing.lua             $work_dir
    cp $script_dir/clothing.lua                     $work_dir
    cp $script_dir/emote_items.lua                  $work_dir
    cp $script_dir/item_blacklist.lua               $work_dir
    cp $script_dir/misc_items.lua                   $work_dir
    cp $script_dir/prefabskins.lua                  $work_dir
    cp $script_dir/skin_strings.lua                 $work_dir
    cp $script_dir/techtree.lua                     $work_dir
    cp $script_dir/tuning.lua                       $work_dir
    cp $script_dir/worldsettings_overrides.lua      $work_dir
}

function copy_lua_files_from_repo() {
    echo "Copy lua files from repo to $work_dir ..."

    cp "$repo_root"/map/*.lua                       $work_dir/map
    cp "$repo_root"/*.lua                           $work_dir
}

function check_server_version() {
    if [[ ! -e $version_file ]]; then
        echo ''
        return
    fi
    declare -r server_version=$(cat "$version_file")
    echo "$server_version"
    return
}

function parse() {
    declare -r version=$(check_server_version)
    cd $work_dir
    if which luajit > /dev/null 2>&1; then
        luajit ./main.lua "$output_dir" "$version"
    else
        lua ./main.lua "$output_dir" "$version"
    fi
}

unzip_script_file
copy_files_from_unzipped
copy_lua_files_from_repo
parse

echo ''
echo "Done!"
