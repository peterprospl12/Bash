quit=1

while [[ $quit -ne 0 ]]; do
    data=$(zenity --forms --title="Szukajka" \
    --text="Wprowadź dane" \
    --separator="," \
    --add-entry="Nazwa pliku" \
    --add-entry="Katalog" \
    --add-entry="Wiekszy niz" \
    --add-entry="Mniejszy niz"\
    --add-entry="Zawartosc")
    if [[ -z $data ]]; then
        quit=0
    else
        filename=$(echo $data | cut -d "," -f1)
	if [ -z $filename ]; then
		filename=""
	fi
        filedir=$(echo $data | cut -d "," -f2)
	if [ -z $filedir ]; then
		filedir=.
	fi
        greaterthan=$(echo $data | cut -d "," -f3)
	if [ -z $greaterthan ]; then
		greaterthan=1c
	fi
        lessthan=$(echo $data | cut -d "," -f4)
	if [ -z $lessthan ]; then
		lessthan=10M
	fi
	inside=$(echo $data | cut -d "," -f5)
	if [ -z $inside ]; then
		inside=.*
	fi


        if [[ $(find $filedir -name "$filename" -size +$greaterthan -size -$lessthan -exec grep $inside {} \;) ]]; then
            zenity --info --title "Szukajka" --text "Plik istnieje"
        else
            zenity --info --title "Szukajka" --text "Plik nie istnieje"
        fi

    fi
done
