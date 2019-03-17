#!/bin/bash
secenek=0

echo "1.Unix"
echo "2.Linux"
echo -n "İşletim sisteminizi seçiniz? : "
read secenek

if [ $secenek -eq 1 ]  ; then

echo "Unix seçildi"

else
	if [ $secenek -eq 2 ] ; then
		echo "Linux seçildi"
	else
		echo "Lütfen bir OS seçiniz"
	fi
fi
