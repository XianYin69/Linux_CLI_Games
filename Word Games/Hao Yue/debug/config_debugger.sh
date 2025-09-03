source "../config/init.sh"

color_test() {
    local prefix
    local color
    local character
    local suffix
    for prefix in 0 1 2 3 4 5 7 8; do
        for color in 30 31 32 33 34 35 36 37 90 91 92 93 94 95 96 97; do
            for character in {A..Z} {a..z} {0..9} "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "-" "=" "+" "[" "]" "{" "}" ";" ":" "'" "\"" "," "<" "." ">" "/" "?" "\\" "|"; do
                for suffix in 0 1 2 3 4 5 7 8; do
                    show_word $prefix $color $character $suffix
                done
            done
        done
    done
}

archive_test() {
    local action
    local is_archive
    local data
    local file_path
    read -p "File_path:" file_path
    for action in read write; do
        for is_archive in yes no; do
            for data in "TestData1" "TestData2" "TestData3" "TestData4" "TestData5"; do
                if [[ $action == "read" ]]; then
                    archive $is_archive $data
                elif [[ $action == "write" ]]; then
                    archive $is_archive $data $file_path
                fi
            done
        done
    done
}

debugger() {
    local test_type
    read -p "Test_type(color/archive):" test_type
    if [[ $test_type == "color" ]]; then
        color_test
    elif [[ $test_type == "archive" ]]; then
        archive_test
    else
        echo "Invalid test type"
    fi
}

debugger