cd ../servers
mkdir -p ../logs
forever start -a -l $(pwd)/../logs/forever.log -o $(pwd)/../logs/out.log -e $(pwd)/../logs/err.log server.js
cd ../bin
