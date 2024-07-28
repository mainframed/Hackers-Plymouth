#!/bin/bash

every_n_frame="1"
resolution="1800"  # Default resolution

if [ -n "$2" ] 
then
    resolution=$2
fi

#set -x
set -e

# Parse command-line arguments
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <lordnikon|crashoverride|acidburn|cerealkiller> [resolution]"
    exit 1
fi

# Validating the input folder
case "$1" in
    lordnikon)
        input_dir="$1"
        frame=66
        transparent=white
        ;;
    acidburn)
        input_dir="$1"
        frame=62
        transparent=black
        ;;
    crashoverride)
        input_dir="$1"
        frame=37
        ;;
    cerealkiller)
        input_dir="$1"
        frame=36
        ;;
    * )
        echo -e "\e[91m[!] Error: Input folder must be one of 'lordnikon', 'crashoverride', or 'acidburn'.\e[0m"
        exit 1
        ;;
esac

echo "[+] Generating $input_dir"

output_dir="$input_dir/uncompressed/"
mkdir -p "$output_dir"

echo "[+] Processing ./assets/$1.mp4 : Resolution: $resolution"

ffmpeg -hide_banner -loglevel error -i ./assets/$1.mp4 -vf "scale=-1:$resolution,select=not(mod(n\,$every_n_frame))" -frames:v $frame -vsync vfr "./$output_dir/boot-%d.png"

echo "[+] Cleaning up previous extracts"
rm $input_dir/*.png || :
echo "[+] Post-processing:" $(ls ./$output_dir/boot-*.png | wc -l ) "PNG images"

# Count total number of PNG files
total_files=$(ls -v "$output_dir"/*.png | wc -l)
file_count=0

# Loop through each .png file in the input directory
for file in $(ls -v "$output_dir"/*.png); do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        file_count=$((file_count + 1))
        case "$1" in
            lordnikon)
                if [ $file_count -ge 27 ] && [ $file_count -le 39 ] || [ $file_count -ge 44 ] && [ $file_count -le 65 ]; then
                    continue
                fi
                ;;
            acidburn)
                
                if [ $file_count -ge 2 ] && [ $file_count -le 16 ]; then
                    continue
                fi
                ;;
        esac
        # Calculate progress percentage
        progress=$(( (file_count * 100) / total_files ))
        # Print progress bar and filename
        printf "\r[+] Processing %s (%.2d%%) %s" "$filename" "$progress" "$(printf '%.0s#' $(seq 1 $((progress / 2))))$(printf '%.0s-' $(seq 1 $((50 - progress / 2))))"
        #  use pngquant to process the file and save it to the output directory
        pngquant --force --output "$input_dir/$filename" "$file"
    fi
done



rm -rf "$output_dir"

echo -e "\n[+] $(ls $input_dir/*.png | wc -l) .png images for '$input_dir' processed."
