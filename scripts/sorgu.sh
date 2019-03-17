#!/bin/bash

a="mufit" 2>/dev/null
echo "Lütfen kullanıcı adınızı giriniz"

read -p "Adiniz : "  

if [ $REPLY = "$a" ]
then
echo -e \\a\Kimlik onaylandı
else
echo "Hatalı giris"
fi 
