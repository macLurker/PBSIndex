#!/bin/sh
echo "Update PBS Index JSON from PBSNewData & current PBSIndexData.json"
cd /Users/darendon/_UseThis/github/PBSIndex
#test location
#cd /Users/darendon/_UseThis/github/PBSIndex/scripts

# check if perl script executed w/o errors
# production version
perl scripts/UpdatePBSJSON.pl PBSNewData.txt PBSIndexData.json
# test version
#perl UpdatePBSJSON.pl testData/PBSNewData.txt testData/PBSIndexData.json
if [ "$?" -ne "0" ]; then
	echo "Error running perl script"
	exit 1
fi

exit 0