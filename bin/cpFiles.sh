cd ../src
for f in `find ./ -type f | grep -v ".coffee"`;
do 
	dirname=`dirname $f`;
	mkdir -p ../servers/$dirname
        cp $f ../servers/$dirname
done
cd ../bin
