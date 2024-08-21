#set -x                                                                         
echo "Antes de ejecutar este script asegurarse que el servidor gdm tenga los volumes groups borrados"
echo "y los discos Defined o que se encuentre apagado.\n"                         
echo "Presione cualquier tecla para cancelar o Y o y para proseguir.\c"         
read Y                                                                          
if [ $Y ]                                                                       
then                                                                            
        if [ $Y != 'Y' ] && [ $Y != 'y' ]                                       
        then                                                                    
                echo "Script cancelado."                                        
                exit 1                                                          
        fi                                                                      
else                                                                            
        echo "Script cancelado."                                                
        exit 1                                                                  
fi                                                                              
DISCODB="00c339c45a08852b"                                                
DISCOAPP="00c339c4972263f4"
echo "Importando y Activando Volume Group vggdmdb."
DISCO1DB="`lspv | grep $DISCODB | awk ' { print $1 } '`
if [ "${DISCO1DB}" ] ; then
	importvg -y vgvggdmdb ${DISCO1DB}                                                  
	if [ $? != 0 ] ; then
        	echo "Error - No se pudo importar el volume group vgvggdmdb."           
        	exit 1                                                                  
	fi                                                                              
else
        echo "Error - No se pudo encontrar el disco ${DISCODB}\n"
        echo "Se aborta la operacion"
        exit 1
fi

echo "Importando y Activando Volume Group vggdmapp."
DISCO1APP="`lspv | grep $DISCOAPP | awk ' { print $1 } '`
if [ "${DISCO1APP}" ] ; then
	importvg -y vggdmapp ${DISCO1APP}
	if [ $? != 0 ] ; then                                                           
                echo "Error - No se pudo importar el volume group vggdmapp."
                exit 1
        fi   
else
        echo "Error - No se pudo encontrar el disco ${DISCOAPP}\n"
        echo "Se aborta la operacion"
        exit 1
fi

echo "Montando Filesystems de Volume Group vgvggdmdb."                         
for fs in `lsvg -l vgvggdmdb | grep -v 'N/A' | grep closed | awk ' { print $7 } '`
do                                                                              
       	echo "\tMontando $fs."                                                  
       	mount $fs                                                               
       	if [ $? != 0 ] ; then 
               	echo "\tError - No se pudo montar $fs."                         
               	exit 1                                                          
       	fi                                                                      
done                                                                            

echo "Montando Filesystems de Volume Group vggdmapp."                         
for fs in `lsvg -l vggdmapp | grep -v 'N/A' | grep closed | awk ' { print $7 } '`
do                                                                              
        echo "\tMontando $fs."                                                  
        mount $fs                                                               
        if [ $? != 0 ]                                                          
        then                                                                    
                echo "\tError - No se pudo montar $fs."                         
                exit 1                                                          
        fi                                                                      
done                                                                            
echo "Creando Alias para GDM en placa en0"                                  
chdev -l en0 -a alias4='172.16.7.13,255.255.255.0'
