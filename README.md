# PBSIndex: Programming by Stealth Index Repository
This repository contains the PBS Index files. This includes:
* the HTML and JSON to generate the index as the page loads. As well as files to update & test index page.

File List:
* ChangeBartLink.pl - Perl script to update JSON file with Bart's new PBS link 
* index.html - Base HTML file for displaying index
* PBSIndexData_new.json - index data, with latest additions
* PBSIndexData.json - production index data, updated after every PBS episode
* PBSNewData_template.txt - Template for new PBS episode data
* test.html - HTML file for testing newly updated PBS index data file
* UpdatePBSJSON.pl - Perl script to update PBSIndexData.json from PBSNewData.txt

To test new data, use: https://maclurker.github.io/PBSIndex/test.html
<br>
To load production page, use: https://maclurker.github.io/PBSIndex/index.html

All files created by D. Rendon, June 2020
Connected to Podfeet.com via github, March 2022
