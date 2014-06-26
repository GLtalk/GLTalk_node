cd ..
rm -rf  servers
mkdir servers
coffee -o ./servers -c src/
cd bin
./cpFiles.sh