#!/bin/sh
echo "Push new JSON data file to GitHub"
echo "PBS module is $KMVAR_Counter"

cd /Users/darendon/_UseThis/github/PBSIndex
#test location
#cd /Users/darendon/_UseThis/github/PBSIndex/scripts
echo "Added module $KMVAR_Counter"
#
git status
git commit -am "Added PBS module $KMVAR_Counter"
git push
git status
exit 0