#!/bin/bash                   
#
# Auteur: Mufit SAKA
# Le script sert a trouver uniquement les fichiers; par nom et / ou par date (y inclu heure).
# Puis vous avez des choix a effectuer; lister, compresser, changer ou supprimer
# l'extension des fichers, creer des archives tar et les deplacer
# enfin les supprimer. C'est un script interactif avec l'utilisateur.					
###################################################################################################


echo -e "\nEssayer avec $0 -h pour voir les options disponibles\n"

FILE_GENERATOR() {

read -p "DEBUT:Veuillez entrez l'intervalle en AAAAMMJJ: " START                                                                                                                                                                                                                                                          
echo -e "DEBUT $START" ; sleep 1; read -p "DEBUT: Preciser l'heure hhmm.ss: " H1                                                                                                                                                                                                                                          
read -p "FIN:Veuillez entrez l'intervalle en AAAAMMJJ: " FIN                                                                                                                                                                                                                                                              
echo -e "FIN $FIN" ; sleep 1; read -p "FIN: Preciser l'heure hhmm.ss: " H2                                                                                                                                                                                                                                                
read -p "REPERTOIRE:Veuillez saisir le repertoire (ex. /home/admserv/): " REP                                                                                                                                                                                                                                             
touch -t $START$H1 start-$START.begin                                                                                                                                                                                                                                                                                     
touch -t $FIN$H2 fin-$FIN.end                                                                                                                                                                                                                                                                                             
mv start-$START.begin /tmp                                                                                                                                                                                                                                                                                                
mv fin-$FIN.end /tmp                                                                                                                                                                                                                                                                                                      
}                                                                                                                                                                                                                                                                                                                         
MENU_ONLY_NAME() {                                                                                                                                           
read -p "REPERTOIRE:Veuillez saisir le repertoire (ex. /home/admserv/): " REP                                                                                
read -p "Nom du fichier: " REPON                                                                                                                             

}

NOM() {
shopt -s nocasematch
while true; do      
read -p "Recherchez avec nom (O/N)? : " REPONSE
if [[ $REPONSE = "N" ]]                        
then                                           
$1                                             
break                                          
elif [[ $REPONSE = "O" ]]; then                
read -p "Nom du fichier: " REPON               
$2                                             
break                                          
else                                           
echo "Faites votre choix O/N : "               
continue                                       
fi                                             
done                                           
}                                              

REMOVE_temp() {
rm -f /tmp/start-$START.begin /tmp/fin-$FIN.end
}                                              


COMMAND_COMP() {
find $REP -maxdepth 1 -type f -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end -exec gzip -9 {} \;
}                                                                                                 

archivage() {
read -p "Nom de l'archive: " NOM
read -p "Choissez la localisation($REP est par defaut): " LOCAL
}                                                              


COMMAND_TAR() {
PWD=`pwd`      
(cd $REP; find . -maxdepth 1 -type f -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end -exec tar czvf "$NOM.tar.gz" {} +)
cd $PWD                                                                                                                 
}                                                                                                                       

COMMAND_TAR_INAME() {
PWD=`pwd`            
(cd $REP; find . -maxdepth 1 -type f -iname "$REPON" -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end -print0 | tar czvf "$NOM.tar.gz" --null -T -)
cd $PWD                                                                                                                                            
}                                                                                                                                                  

MV() {
if [[ -d $LOCAL ]] 
        then               
                mv $REP/$NOM.tar.gz $LOCAL
                echo -e "\n########L'archive est dans $LOCAL ############\n"
        else                                                                
                echo -e "\n########L'archive est dans $REP #############\n" 
fi                                                                          
}                                                                           


COMMAND_COMP_iname() {
find $REP -maxdepth 1 -type f -iname "$REPON" -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end -exec gzip -9 {} \;
}                                                                                                                 

COMMAND() {

find $REP -maxdepth 1 -type f -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end $1 
}                                                                                 

COMMAND_INAME() {
find $REP -maxdepth 1 -type f -iname "$REPON" -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end $1
}                                                                                                

ONLY_NAME_COMMAND() {
MENU_ONLY_NAME       
find $REP -maxdepth 1 -type f -iname "$REPON" $1
}                                   

#find /PROD/DATA/arsacif4 -mmin +540 -type f -iname "*.failed"  | while read f ; do mv "$f" "${f%.failed}"; done
#for f in *.txt; do mv $f `basename $f .txt`; done;
DELETE_EXTENSION() {
read -p "REPERTOIRE:Veuillez saisir le repertoire (ex. /home/admserv/): " REP
read -p "Extension du ficher (apres le . ): " ext
while true; do
read -p "Voulez vous recherchez par date (o/n)?: " REP1
if [[ $REP1 = "o" ]]; then
read -p "DEBUT:Veuillez entrez l'intervalle en AAAAMMJJ: " START                                                                                                        
echo -e "DEBUT $START" ; sleep 1; read -p "DEBUT: Preciser l'heure hhmm.ss: " H1                                                                                        
read -p "FIN:Veuillez entrez l'intervalle en AAAAMMJJ: " FIN                                                                                                            
echo -e "FIN $FIN" ; sleep 1; read -p "FIN: Preciser l'heure hhmm.ss: " H2                                                                                              
                                                                             
touch -t $START$H1 start-$START.begin                                                                                                                                   
touch -t $FIN$H2 fin-$FIN.end
sleep 2                                                                                                                                           
mv start-$START.begin /tmp                                                                                                                                              
mv fin-$FIN.end /tmp                                                                 
sleep 1
find $REP -maxdepth 1 -type f -iname "*.$ext" -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end | while read f ; do mv "$f" "${f%.$ext}"; done
echo -e "\n*******Extension Supprime*******\n"
ls -l $REP
break
elif [[ $REP1 = "n" ]]; then
find $REP -maxdepth 1 -type f -iname "*.$ext" | while read f ; do mv "$f" "${f%.$ext}"; done
echo -e "\n*******Extension Supprime*******\n"
ls -l $REP
break
else
echo "Faites votre choix o/n : "
fi
done
REMOVE_temp
}

CHANGE_EXTENSION() {
read -p "REPERTOIRE:Veuillez saisir le repertoire (ex. /home/admserv/): " REP
read -p "Extension du ficher (apres le . ): " ext
read -p "Nouvel extension (sans le .): " n_ext
while true; do
read -p "Voulez vous recherchez par date (o/n)?: " REP1
if [[ $REP1 = "o" ]]; then
read -p "DEBUT:Veuillez entrez l'intervalle en AAAAMMJJ: " START                                                                                                        
echo -e "DEBUT $START" ; sleep 1; read -p "DEBUT: Preciser l'heure hhmm.ss: " H1                                                                                        
read -p "FIN:Veuillez entrez l'intervalle en AAAAMMJJ: " FIN                                                                                                            
echo -e "FIN $FIN" ; sleep 1; read -p "FIN: Preciser l'heure hhmm.ss: " H2                                                                                              
                                                                                           
touch -t $START$H1 start-$START.begin                                                                                                                                   
touch -t $FIN$H2 fin-$FIN.end   
sleep 2                                                                                                                                        
mv start-$START.begin /tmp                                                                                                                                              
mv fin-$FIN.end /tmp
sleep 1
find $REP -maxdepth 1 -type f -iname "*.$ext" -newer /tmp/start-$START.begin -a ! -newer /tmp/fin-$FIN.end | while read f ; do mv "$f" "${f%.$ext}.$n_ext"; done
echo -e "\n*******Extension Change*******\n"
ls -l $REP
break
elif [[ $REP1 = "n" ]]; then
find $REP -maxdepth 1 -type f -iname "*.$ext" | while read f ; do mv "$f" "${f%.$ext}.$n_ext"; done
echo -e "\n*******Extension Change*******\n"
ls -l $REP
break
else
echo "Faites votre choix o/n : "
fi
done
REMOVE_temp
}

ONLY_NAME_ZIPCOMMAND() {
MENU_ONLY_NAME          
find $REP -maxdepth 1 -type f -iname "$REPON" -exec gzip -9 {} \;
}                                                    

ONLY_NAME_TARCOMMAND() {
MENU_ONLY_NAME          
archivage               
PWD=`pwd`               
(cd $REP; find . -type f -iname "$REPON" -print0 | tar czvf "$NOM.tar.gz" --null -T -)
cd $PWD                                                                               
MV                                                                                    
}                                                                                     

LIST() {
echo -e "\n########Liste des Fichiers########\n"
FILE_GENERATOR                                  
NOM "COMMAND -ls" "COMMAND_INAME $REPON -ls"    
REMOVE_temp                                     
}                                                                                 


COMPRESS() {
echo -e "\n#############Compression avec gzip##################\n"
FILE_GENERATOR                                                    
NOM "COMMAND_COMP" "COMMAND_COMP_iname $REPON"                    
echo -e "\n#############COMPRESSES##################\n"           
REMOVE_temp                                                       
}                                                                                                 

TAR_BALL() {
echo -e "\n#############Archivage des fichiers en tar.gz##################\n"
FILE_GENERATOR                                                               
archivage                                                                    
NOM "COMMAND_TAR" "COMMAND_TAR_INAME $REPON"                                 
MV                                                                           
REMOVE_temp                                                                  
}                                                                            

DEL() {
echo -e "\n#############SUPPRESSION##################\n"
FILE_GENERATOR                                          
NOM "COMMAND -delete" "COMMAND_INAME -delete "          
echo -e "\n#############SUPRIMES##################\n"   
REMOVE_temp                                             
}                                                       


while getopts ":hlctdeo" opt; do
        case ${opt} in         
                h) echo -e "****** -l: Pour lister les fichiers dans l'intervalle donnee.
****** -c: Compresser les fichiers trouves, les fichiers sont verifiables via $0 -l commande.
****** -t: Creer un archive tar.gz a partir des fichiers trouves.                            
****** -d: Supprimer les fichiers trouves.
****** -e: Manipuler l'extension.
****** -o: Traitement par nom.\n";;
                l) echo -e "Commande va lister les fichiers\n";LIST;;
                c) echo -e "Commande va compresser les fichiers\n";COMPRESS;;
                t) echo -e "Archivage .tar.gz en cours\n";TAR_BALL;;
                d) echo -e "Fichiers seront supprimes\n";DEL;;
		e) echo -e "Changer ou Supprimer l'extension\n"
				while true; do
				PS3="Faites votre choix: "
				choix=("Supprimer" "Changer" "Quitter")
				select answer in "${choix[@]}"
				do
					case $answer in 
						"Supprimer") echo "####Supprimer l'Extension####";DELETE_EXTENSION;break;;
						"Changer") echo "####Changer l'Extension####";CHANGE_EXTENSION;break;;
						"Quitter") echo "####Vous quittez####";exit;;
					esac
				done
				done;;

                o) echo -e "Recherche seulement par nom\n"
                                while true; do
                                PS3="Faites votre choix: "
                                choix=("Lister" "Compresser" "Archivage" "Supprimer" "Quitter")
                                select answer in "${choix[@]}"
                                do
                                        case $answer in
                                                "Lister") echo "####Liste des Fichier####";ONLY_NAME_COMMAND -ls;break;;
                                                "Compresser") echo "####Compression des Fichiers####";ONLY_NAME_ZIPCOMMAND;break;;
                                                "Archivage") echo "####Archivage des Fichiers####";ONLY_NAME_TARCOMMAND;break;;
                                                "Supprimer") echo "####Suppression des Fichiers####";ONLY_NAME_COMMAND -delete;echo -e "\n####SUPPRIMES####\n";break;;
						"Quitter") echo "####Vous quittez####";exit;;
                                        esac
                                done
                                done
        esac
done

