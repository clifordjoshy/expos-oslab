#!/bin/bash

cd utils
for f in *.expl; do expl $f; done

xfs_commands=""

for filename in *.xsm; do
	xfs_commands+="rm $filename\n"
	xfs_commands+="load --exec $(readlink -f $filename)\n"
done

xfs_commands+="dump --inodeusertable\n"
xfs_commands+="exit\n"

echo -e $xfs_commands | nexfsi >/dev/null 2>&1

for filename in *.xsm; do
	entry=$(grep -n $filename /home/nexpos/mynexpos/nexfs-interface/inodeusertable.txt | cut -f1 -d:)
	data=$(head -$(($entry + 10)) /home/nexpos/mynexpos/nexfs-interface/inodeusertable.txt | tail +$(($entry + 7)) | tr '\n' ' ')
	echo -e "$filename: $data"
done

rm *.xsm
