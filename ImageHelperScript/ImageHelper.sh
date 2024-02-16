#!/bin/bash

# Author           : Piotr Sulewski ( s192594@pg.edu.pl )
# Created On       : 1.06.2023
# Last Modified By : Piotr Sulewski ( s192594@pg.edu.pl )
# Last Modified On : 4.06.2023
# Version          : 14.3.4.33.2222
#
# Description      : 
# imagehelper.sh is a Bash script that allows you to process graphic files using the ImageMagick tool. 
# The program provides functionalities such as format conversion, resizing, adding watermarks, 
# adjusting brightness, adjusting contrast, and converting to grayscale.

#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)


trap "exit" INT TERM
trap "kill 0" EXIT
height=600

if ! command -v convert &> /dev/null; then
  echo "ImageMagick nie jest zainstalowany"
  exit 1
fi

while getopts ":hs:" opt; do
  case $opt in
    h)
      man -l manual.1
      exit 0
      ;;
    
    s)
      height=$OPTARG
      ;;

    \?)
      echo "Nieznana opcja: -$OPTARG" >&2
      exit 1
      ;;
  esac
done




while true; do
  operation=$(zenity --list --title="Wybierz operację" --column="Operacja" --height="$height" "Konwersja formatu" "Zmiana rozmiaru" "Dodawanie znaku wodnego" "Zmiana jasności" "Zmiana kontrastu" "Przekształcenie na czarno-białe" "Zmiana jakości" "Zamknij")

  if [ $? -ne 0 ] || [ "$operation" == "Zamknij" ]; then
    break
  fi

  files=$(zenity --file-selection --multiple --file-filter='All files | *')

  if [ $? -ne 0 ]; then
    continue
  fi

  case "$operation" in
    "Konwersja formatu")
      format=$(zenity --entry --title="Wybierz format docelowy" --text="Podaj format docelowy:")
      for file in $files; do
        output_file="${file%.*}.$format"
        convert "$file" "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Zmiana rozmiaru")
      dimensions=$(zenity --entry --title="Wybierz nowy rozmiar" --text="Podaj nowe wymiary (szerokośćxwysokość):")
      for file in $files; do
        output_file="${file%.*}_resized.${file##*.}"
        convert "$file" -resize "$dimensions" "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Dodawanie znaku wodnego")
      watermark=$(zenity --file-selection --title="Wybierz znak wodny")
      for file in $files; do
        output_file="${file%.*}_watermarked.${file##*.}"
        composite -dissolve 50% -gravity center "$watermark" "$file" "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Zmiana jasności")
      brightness=$(zenity --scale --title="Zmiana jasności" --text="Podaj wartość zmiany jasności:" -- min value 0 --max-value 100 -value 10)
      for file in $files; do
        output_file="${file%.*}_brightness.${file##*.}"
        convert "$file" -modulate 100,${brightness} "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Zmiana kontrastu")
      contrast=$(zenity --scale --title="Zmiana kontrastu" --text="Podaj wartość zmiany kontrastu:" -- min value 0 --max-value 100 -value 10)
      for file in $files; do
        output_file="${file%.*}_contrast.${file##*.}"
        convert "$file" -contrast-stretch ${contrast}% "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Przekształcenie na czarno-białe")
      for file in $files; do
        output_file="${file%.*}_bw.${file##*.}"
        convert "$file" -colorspace Gray "$output_file"
        xdg-open "$output_file"
      done
      ;;
    "Zmiana jakości")
      quality=$(zenity --scale --title="Zmiana jakości" --text="Podaj wartość jakości (0-100):" -- min value 0 --max-value 100 -value 10)
      for file in $files; do
        output_file="${file%.*}_quality.${file##*.}"
        convert "$file" -quality "$quality" "$output_file"
        xdg-open "$output_file"
      done
      ;;
  esac

  zenity --info --title="Zakończono przetwarzanie" --text="Przetwarzanie plików graficznych zakończone."
done
