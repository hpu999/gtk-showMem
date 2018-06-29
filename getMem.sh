#!/bin/bash

FILE="/tmp/mem.xml"

write_xml()
{
	echo "<disk>" >> $FILE
	echo "<name>$1</name>" >> $FILE
	echo "<total>$2</total>" >> $FILE
	echo "<used>$3</used>" >> $FILE
	echo "<free>$4</free>" >> $FILE
	echo "</disk>" >> $FILE
}

get_disk_info()
{
	disk=`mount | grep "$1" | awk '{print $3}'`
	total=`df -h $disk | grep "$disk" | awk '{print $2}'`
	used=`df -h $disk | grep "$disk" | awk '{print $3}'`
	free=`df -h $disk | grep "$disk" | awk '{print $4}'`
	if [ "/" == "$disk" ]
	then
		disk="system"
	elif [ "/home/tt/TT/data" == "$disk" ]
	then
		# disk=${disk##*/}
		disk="doppler"
	elif [ "/opt/usbStorage" == "$disk" ]
	then
		# disk=${disk##*/}
		disk="usb"
	fi
}

test -f "$FILE" && rm "$FILE"

contents=`mount | awk '{print $1}' | grep "rootfs\|/dev/sd\|/dev/mmc"`

echo "<disks>" > $FILE
for content in `echo $contents`
do
	get_disk_info $content
	write_xml $disk $total $used $free
done
echo "</disks>" >> $FILE
