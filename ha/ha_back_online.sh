# cat ha_back* | more                                                           
#set -x                                                                         
echo "Antes de ejecutar este script asegurarse que en el servidor online2 no ten
ga procesos activos"                                                            
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
VOLGROUP="vgapponline vgdbonline"                                               
for VG in $VOLGROUP                                                             
do                                                                              
        for fs in `lsvg -l $VG | grep -v 'N/A' | grep open | awk ' { print $7 } 
'`                                                                              
        do                                                                      
                echo "\tDesmontando $fs."                                       
                unmount $fs                                                     
                if [ $? != 0 ]                                                  
                then                                                            
                        echo "\tError - No se pudo desmontar $fs."              
                        exit 1                                                  
                fi                                                              
        done                                                                    
        echo "Desactivando Volume Group $VG"                                    
        varyoffvg $VG                                                           
        if [ $? != 0 ]                                                          
        then                                                                    
                echo "Error - No se pudo desactivar el volume group $VG."       
                exit 1                                                          
        fi                                                                      
        echo "Exportando Volume Group $VG"                                      
        exportvg $VG                                                            
        if [ $? != 0 ]                                                          
        then                                                                    
                echo "Error - No se pudo exportar el volume group $VG."         
                exit 1                                                          
        fi                                                                      
done                                                                            
#for HD in $DISCOS                                                              
#do                                                                             
#       echo "Poniendo disco $HD Defined."                                      
#       rmdev -l $HD                                                            
#       if [ $? != 0 ]                                                          
#        then                                                                   
#                echo "Error - No se pudo cambiar el estado del $HD."           
#                exit 1                                                         
#        fi                                                                     
#done                                                                           
echo "Eliminando Alias para online1 en placa en0"                               
chdev -l en0 -a delalias4='10.10.10.100,255.255.252.0'                          
