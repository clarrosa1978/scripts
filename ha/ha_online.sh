#set -x                                                                         
echo "Antes de ejecutar este script asegurarse que el servidor online1 tenga los
 volumes groups borrados"                                                       
echo "y los discos Defined o que se encuentre apagado."                         
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
DISCOS="hdisk2 hdisk3 hdisk4"                                                   
#DISCOS="hdisk3"                                                                
echo "Importando y Activando Volume Group vgapponline."                         
importvg -y vgapponline hdisk3                                                  
if [ $? != 0 ]                                                                  
then                                                                            
        echo "Error - No se pudo importar el volume group $VG."                 
        exit 1                                                                  
fi                                                                              
echo "Montando Filesystems de Volume Group vgapponline"                         
for fs in `lsvg -l vgapponline | grep -v 'N/A' | grep closed | awk ' { print $7 
} '`                                                                            
do                                                                              
        echo "\tMontando $fs."                                                  
        mount $fs                                                               
        if [ $? != 0 ]                                                          
        then                                                                    
                echo "\tError - No se pudo montar $fs."                         
                exit 1                                                          
        fi                                                                      
done                                                                            
echo "Importando y Activando Volume Group vgdbonline"                           
importvg -y vgdbonline hdisk2                                                   
if [ $? != 0 ]                                                                  
then                                                                            
        echo "Error - No se pudo importar el volume group vgdbonline."          
        exit 1                                                                  
fi                                                                              
echo "Montando Filesystems de Volume Group vgdbonline."                         
for fs in `lsvg -l vgdbonline | grep -v 'N/A' | grep closed | awk ' { print $7 }
 '`                                                                             
do                                                                              
        echo "\tMontando $fs."                                                  
        mount $fs                                                               
        if [ $? != 0 ]                                                          
        then                                                                    
                echo "\tError - No se pudo montar $fs."                         
                exit 1                                                          
        fi                                                                      
done                                                                            
echo "Creando Alias para online1 en placa en0"                                  
chdev -l en0 -a alias4='10.10.10.100,255.255.252.0'                             
