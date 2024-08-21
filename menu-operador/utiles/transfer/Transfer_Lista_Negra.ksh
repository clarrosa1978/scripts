############################## Seccion agregada por JAF ##################################################

     # Jorge Fernandez Garay - Enero 2001
 
     # El proposito es integrar la copia del listaneg.ddmmyyyy del sp9 al amscentral como visa.jaf
     # para evitar que se distribuya un archivo de fechas previas, al omitir copiar del sp9 al amscentral

     #set -x

     # Confirma el envio del archivo de Novedades de lista negra

     LN_NEWS_FILE_EXTENT=`date +"%d%m%Y"`
     FMT_DATE=`date +"%d-%m-%Y"`
     CONNECT_STAT=''
     LN_NEWS_FILE_EXIST=''
     SOURCE_FILE_CHECKSUM=''
     SOURCE_RECORD_COUNT=''
     SOURCE_FILE_DATE=''
     TARGET_FILE_CHECKSUM=''
     TARGET_RECORD_COUNT=''
     TARGET_FILE_DATE=''
     export LN_NEWS_FILE_EXTENT FMT_DATE CONNECT_STAT LN_NEWS_FILE_EXIST SOURCE_FILE_CHECKSUM SOURCE_RECORD_COUNT SOURCE_FILE_DATE      TARGET_FILE_CHECKSUM TARGET_RECORD_COUNT TARGET_FILE_DATE


     clear
     echo "\n\n"
     echo "\t----------------------------------------------------------------"
     echo "\t|                                                              |" 
     echo "\t|         ENVIO DE NOVEDADES DE LISTA NEGRA A SUCURSALES       |"
     echo "\t|                                                              |" 
     echo "\t----------------------------------------------------------------"
     echo "\n\t                                           Fecha: $FMT_DATE"
     echo "\n\n"

     # Control del estado de comunicacion con sp9

      CONNECT_STAT=''
      CONNECT_STAT=`ping -c1 sp9 | grep "packet loss" | awk '{print $7}'|sed -e 's/%//'`

      if [ "$CONNECT_STAT" -gt 50 ]
      then
                echo "\nHay problemas de comunicacion con el server sp9. Abortando..."
                exit 1
      fi

      echo "\n\tControlando archivo de origen (listaneg.$LN_NEWS_FILE_EXTENT)en sp9..."

      # Controla la existencia del archivo de Lista Negra en sp9

      LN_NEWS_FILE_EXIST=''
      LN_NEWS_FILE_EXIST=`rsh sp9 "[ -f /tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT ] && echo TRUE || echo FALSE"`

      if [ "$LN_NEWS_FILE_EXIST" = "FALSE" ]
      then
               echo "\n\tEl archivo /tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT no existe en el server sp9."
               echo "\n\tAbortando..."
               exit 1
      fi

      # Variables de Control del Source File

      SOURCE_FILE_CHECKSUM=''
      SOURCE_RECORD_COUNT=''

      SOURCE_FILE_CHECKSUM=`rsh sp9 sum /tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT|awk ' { print $1 } '`
      SOURCE_RECORD_COUNT=`rsh sp9 wc -l /tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT|awk ' { print $1 } '|sed 's/[^0-9]//g'`

      CHK_DATE=`date +"%b %d"`
      SOURCE_FILE_DATE=`rsh sp9 ls -l "/tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT" 2>/dev/null|awk ' { printf "%s %02d", $6, $7 } '|awk ' { if ( length( $2 ) == 1 ) { $2="0"$2 } ;print $0 } '`
           
      if [ "$SOURCE_FILE_DATE" != "$CHK_DATE" ]
      then
               echo "\n\n\tEl archivo listaneg.$LN_NEWS_FILE_EXTENT no tiene fecha de hoy. Revisar..."
               echo "\n\tAbortando..."
               exit 1
      fi

      echo "\n\tCopiando archivo de Nov. de Lista Negra al amscentral..."

      rcp sp9:/tmp/lnworka/listaneg.$LN_NEWS_FILE_EXTENT /tmp/visa.jaf

      # Variables de Control local del Target File (visa.jaf)

      echo "\n\tControlando archivo de destino (visa.jaf), en amscentral..."

      TARGET_FILE_CHECKSUM=''
      TARGET_RECORD_COUNT=''
      TARGET_FILE_DATE=''

      TARGET_FILE_CHECKSUM=`sum /tmp/visa.jaf|awk ' { print $1 } '`
      TARGET_RECORD_COUNT=`wc -l /tmp/visa.jaf|awk ' { print $1 } '|sed 's/[^0-9]//g'`
      TARGET_FILE_DATE=`ls -l /tmp/visa.jaf 2>/dev/null|awk ' { printf "%s %02d", $6, $7 } '|awk ' { if ( length( $2 ) == 1 ) { $2="0"$2 } ;print $0 } '`

      if [ "$SOURCE_FILE_CHECKSUM" = "$TARGET_FILE_CHECKSUM" ] && \
         [ "$SOURCE_RECORD_COUNT" = "$TARGET_RECORD_COUNT" ] && \
         [ "$SOURCE_FILE_DATE" = "$TARGET_FILE_DATE" ]
      then
                :
      else
                #El archivo copiado es inconsistente
                echo "\n\n\tEl archivo visa.jaf copiado es inconsistente..."
                echo "\n\tAbortando..."
                exit 1
      fi

      # Pide confirmacion para proceder a la destribucion

      CONFIRM_SEND=''
      export CONFIRM_SEND=''

      while [ "$CONFIRM_SEND" = '' ]
      do

               echo "\n\n\tArchivo a distribuir: listaneg.$LN_NEWS_FILE_EXTENT"
               echo "\tCantidad de registros   : $TARGET_RECORD_COUNT"

               echo "\n\tCONFIRMA LA DISTIBUCION [S/N]? \c"
               read CONFIRM_SEND

               case "$CONFIRM_SEND" in
               S|s)     break
                        ;;
               N|n)     echo "\n\tCancelando..."
                        exit 1
                        ;;
               *)       echo "\n\t$CONFIRM_SEND: Ingreso erroneo. Reingrese..."
                        CONFIRM_SEND=''
                        ;;
               esac 


      done

      echo "\n\tDistribucion de Novedades de Lista Negra en progreso...\n"

############################# FIN Seccion agregada por JAF #######################################

#echo "Inicio Envio: `date`" >> $OPERADOR_LOG/envio_negra.log
echo "Inicio Envio: `date`" >> /home/root/operador/envio_negra.log

for I in `echo 76 $LISTASUC`
do
	if [ $I = 79 ]
	then
		echo "Mono a Famaba no lo mandes"
		continue
	fi
    	echo "Copiando Lista Negra a Sucursal $I - \c"
	PL=`ping -c1 suc$I | grep packet | awk '{print $7}' `
	if [ "$PL" != "100%" ]
	then
    		rcp -p /tmp/visa.jaf suc$I:/home/root 2>/dev/null
		echo "Copia terminada"
	else
		echo "No hay conectividad con suc$I"| tee -a /home/root/operador/envio_negra.log
		#echo "No hay conectividad con suc$I"| tee -a $OPERADOR_LOG/envio_negra.log
	fi
done
echo "Fin Envio: `date`" >> $OPERADOR_LOG/envio_negra.log

#Chequeo del archivo copiado a servidores 
/home/root/operador/en-check
