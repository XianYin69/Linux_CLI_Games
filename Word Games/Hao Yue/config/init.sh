#!/bin/bash
local Status
#print character with color
show_word() {
    echo -e "/e[{$1}m{$2}:${$3}/e[{$4}m" #$1 = prefix, $2 = color, $3 = character, $4 = suffix
    #ANSI code
    #ANSI prefix
    #0 = reset, 1 = bold, 2 = dim, 3 = italic, 4 = underline, 5 = blink, 7 = reverse, 8 = hidden
    #ANSI color
    #30 = black, 31 = red, 32 = green, 33 = yellow, 34 = blue, 35 = magenta, 36 = cyan, 37 = white
    #90 = bright black, 91 = bright red, 92 = bright green, 93 = bright yellow, 94 = bright blue, 95 = bright magenta, 96 = bright cyan, 97 = bright white
    #ANSI background
    #40 = black, 41 = red, 42 = green, 43 = yellow, 44 = blue, 45 = magenta, 46 = cyan, 47 = white
    #ANSI suffix
    #0 = reset, 1 = bold, 2 = dim, 3 = italic, 4 = underline, 5 = blink, 7 = reverse, 8 = hidden
}

#archive function
archive() {
    local archive_state="none" #none, exist, new, overwrite, error, old
    local real_time=$(date +%Y%m%d_%H%M%S)
    local is_achive="{$1}" #yes, no
    local data="{$2}" #archive data
    #read archive
    archive_read() {
        source ./config/archive.txt #archive file path
        local readed_data
        if [[ -z $PATH ]]; then
            archive_state="error"
        else
            archive_state="exist"
            source $PATH/data.txt
            for true; do
                if [[ $LASTED_DATE == $real_time ]]; then
                    archive_state="old"
                    break
                else
                    readed_data=$data
                    break
                fi
            done
        fi
        echo $readed_data
    }
    #write archive
    archive_write() {
        archive_data() {
            cd "$(dirname $1)"
            source "./data.txt"
            sed -a "s/DATE=.* ARCHIVE_DATA=.*/DATE=\"$real_time\" ARCHIVE_DATA=\"$data\"/" ./data.txt
        }
        if [[ $archive_state == "exist" ]]; then
            sed  -i "s/LASTED_DATE=.*/LASTED_DATE=\"$real_time\"/" ./config/archive.txt
            archive_data $PATH
        elif [ $archive_state -eq "none" ]; then
            local archive_path={$1} #archive file path
            if [[ -z $archive_path ]]; then
                archive_state="error"
            else
                echo "PATH=\"$archive_path\"" > ./config/archive.txt
                cd "$(dirname $archive_path)"
                touch "$(basename $archive_path)/data.txt"
                echo "LASTED_DATE=\"$real_time\"" >> ./config/archive.txt]
                archive_data $archive_path
                archive_state="new"
            fi
        else
            archive_state="error"
        fi
    }
    #user control
    if [[ $is_achive == "yes" ]]; then
        archive_read
        if [[ $archive_state == "error" ]]; then
            echo Status:-1
        else
            echo "Status:0"
        fi
    elif [[ $is_achive == "no" ]]; then
        archive_write "{$2}"
        if [[ $archive_state == "error" ]]; then
            echo Status:-1
        elif [[ $archive_state == "new" ]]; then
            echo Status:0
        fi
    else
        echo Status:-1
    fi            
}