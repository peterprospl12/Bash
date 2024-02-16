

inp_number=0;
quit=1
filename=""
filedir=.
greaterthan=1c
lessthan=10M
inside=.*
while [ $quit -eq 1 ]; do
echo "1. Nazwa: ${filename}"
echo "2. Katalog: ${filedir}"
echo "3. Wiekszy niż: ${greaterthan}"
echo "4. Mniejszy niz: ${lessthan} "
echo "5. Zawartość: ${inside}"
echo "6. Szukaj: "
echo "7. Koniec "

read inp_number;

if [ $inp_number -eq 1 ]; then
echo "Podaj nazwe pliku"
read filename
elif [ $inp_number -eq 2 ]; then
echo "Podaj nazwe katalogu"
read filedir;

elif [ $inp_number -eq 3 ]; then
echo "Wiekszy niz ..."
read greaterthan;

elif [ $inp_number -eq 4 ]; then
echo "Mniejszy niz ..."
read lessthan;

elif [ $inp_number -eq 5 ]; then
echo "Podaj zawartosc"
read inside;

elif [ $inp_number -eq 6 ]; then
if [[ $(find $filedir -name "$filename" -size +$greaterthan -size -$lessthan -exec grep $inside {} \;) ]]; then
echo "Plik istnieje"
else
echo "Plik nie istnieje"
fi

elif [ $inp_number -eq 7 ]; then
quit=0
echo "Koniec programu"

else
echo "Nie znam takiej komendy"
fi

done
