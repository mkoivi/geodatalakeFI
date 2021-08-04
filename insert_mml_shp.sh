# list all shapefiles in maastotietokanta folder and insert to db
cd /home/azureuser/geodatalake/maastotietokanta
find $(pwd) -maxdepth 3 -type f -path '*/*.shp' | while read file; do
   echo $file;
   filename=(${file//_/ })
   tablename=(${filename[1]//./ })
   echo ${tablename[0]};
    shp2pgsql -a -s 3067 -W "latin1" $file ${tablename[0]} | psql -U postgres gis;
done
