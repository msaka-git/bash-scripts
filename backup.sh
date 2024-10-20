#!/bin/bash

dialog --title "Main menu" --backtitle "Backup script" --menu "Move using [UP] [DOWN],[ENTER] to select" 15 60 3 \
"File" "Compress selected file with gzip" \
"Folder" "Compress selected folder with tar" \
Exit "Exit to shell" 2>/tmp/menuitem.$$
$0=myapp

menuitem=`cat /tmp/menuitem.$$`

case $menuitem in
  File) FILE=$(dialog --title "Compress a file" --stdout --title "Please choose a file to compress" --fselect /tmp/ 14 48); echo "compress in progress"; `gzip $FILE`; {
    for ((i = 0 ; i <= 100 ; i+=20)); do
        sleep 1
        echo $i
    done
} | dialog --gauge "Please wait compress in progress" 6 60 0
;;
  Folder) FOLDER=$(dialog --title "Compress a folder" --stdout --title "Please choose a folder to compress" --dselect / 14 48); echo "compress in progress"; `tar -zcvf $FOLDER.tar.gz $FOLDER` >/dev/null 2>&1; {
    for ((i = 0 ; i <= 100 ; i+=10)); do
        sleep 1
        echo $i
    done
} | dialog --gauge "Please wait compress in progress" 6 60 0
 ;;
  Exit) exit 0;;
esac


dialog --msgbox "Compress has been completed Press any key..." 9 40 ;
read

[[ -f /tmp/menuitem.$$ ]] && rm /tmp/menuitem.$$

