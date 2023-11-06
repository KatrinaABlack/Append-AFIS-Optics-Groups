The script will rename each linked micrograph with the calculated optics group from all_movies.star by appending the optics group to the end of each file name. 

1. Make a processing directory, and subdirectories called 'Micrographs' and 'Import'.
2. Make a symbolic link from your data (movies e.g. .tiff, .eer and metadata .xml files)
3. Make sure you have MTF file for your detector (these can be obtained from the manufacturer's site) Place your MTF file in your processing directory.
4. Open a terminal to load the needed EPU group AFIS module. Run according to the instructions here from inside your 'Import' directory.
https://github.com/DustinMorado/EPU_group_AFIS
5. This will generate a file called all_movies.star in your Import directory. If using .eer files, the script removes the “_EER” suffix from files and replace it with “_Fractions”. You can use sed to change the star file to use the correct suffix i.e.:
sed -i 's/Fractions/EER/g' all_movies.star
6. Make the Append-AFIS-Optics-Groups.sh executable and run. It will ask you to specify the directory of all_movies.star and the directory of the symbolic links to your micrographs.
7. Proceed as normal to import the movies into cryoSPARC. To group the micrographs by optic group, run the 'Exposure Group Utilities' job with the following settings (for '.tif' set 'Start Slice Index' to 4, and for '.tiff' files set 'Start Slice Index' to 5.
  Input Selection:  exposure
  Action: split
  Field to split dataset: movie_blob/path
  Start slice index: 4 or 5
  Number of characters to consider: 2
  Index position: back
8. If you are using '.tif' or ‘.eer’ files, you need to modify the references to '.tiff' in the script from '.tiff' to '.tif' or '.eer'.

