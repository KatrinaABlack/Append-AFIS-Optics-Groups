#!/bin/bash
#Script to append optics groups determined in AFIS to micrograph file names
#Katrina Black katrina.black@ucsf.edu and Rich Birkinshaw birkinshaw.r@wehi.edu.au

read -ep 'Please input location of all_movies.star  [./Import/all_movies.star]: ' inputstar
inputstar="${inputstar:-"./Import/all_movies.star"}"
inputstar=`realpath $inputstar`
echo $inputstar
read -ep 'Please input location of movies or symlinks to the movies [./Micrographs/]: ' inputraw
inputraw="$(inputraw:-"./Micrographs/")"
inputraw=`realpath $inputraw`
numbmics=`find $inputraw -name '*oilHole*.tiff' | wc -l`
echo "Found $numbmics movies"

#copy relevant data from all_movies.star, remove header info and remove directory
awk '{if (NF<3) printf "%s\t%s\n", $1,$2 }' $inputstar | sed "s/.*FoilHole_/FoilHole_/g" > tmp_mic_names_1.star

#append the optics group column to just before .tiff
sed "s/.tiff//g" ./tmp_mic_names_1.star | awk '{print $1 "_" $2}' | sed 's/$/.tiff/' > tmp_mic_names_2.star
echo "Done appending optics groups."

#rename mics
find $inputraw -name '*oilHole*.tiff' -print0 | while IFS= read -r -d '' file
do
    filename=$(basename "${file%.*}")
    newfilename=$(grep "$filename" tmp_mic_names_2.star)
    filepath=$(dirname "$file")
    mv -v "$file" "$filepath/$newfilename"    
done
rm tmp_mic_names_1.star tmp_mic_names_2.star

#counting renamed mics
newmics1=`find $inputraw -name '*oilHole*_[0-9].tiff' | wc -l`
newmics2=`find $inputraw -name '*oilHole*_[0-9][0-9].tiff' | wc -l`
newmicstotal=`expr $newmics1 + $newmics2`
echo "Renamed $newmicstotal movies"
