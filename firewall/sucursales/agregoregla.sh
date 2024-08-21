#!/usr/bin/ksh


for sucursal in 02 06 07 13 18 19 20 22 24 25 26 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137 142 143 149 151 152 153 154 155 158 159 160 162 163 164 165 166 167 168 170 171 174 175 176 177 178 179 180 181

 

#for sucursal in 07 13 18 19 20 22 24 25 26 35 37 38 39 40 41 42 43 44 45 46 47 48 49 51 52 53 54 55 56 57 58 59 60 61 63 64 65 66 67 68 69 70 71 74 75 78 80 82 83 84 85 88 90 91 92 94 95 96 97 99 101 103 104 105 107 108 109 110 111 116 117 118 120 121 123 124 125 129 130 131 135 136 137 142 143 149 151 152 153 154 155 158 159 160 162 163 164 165 166 167 168 170 171 174 175 176 177 178 179 180 181

#for sucursal in 02

do

      #echo "Voy a copiar el instalador y agregar la variable en $sucursal"
      #sudo  scp ./cambiaregla.sh suc$sucursal:/tmp
      #echo "Ahora mando a ejecutar.."
      #sleep 1
      #sudo ssh -t suc$sucursal 'bash /tmp/cambiaregla.sh'
      #echo "Pronto....."

      #echo "Agrego el Usuario a la Funcion Oracle en suc$sucursal"
      #sudo ssh -t suc$sucursal 'sed -i '\''s/$EPUENTES/& $JCNEGRIS/'\''  /tecnol/util/firewall.sh' 
      #sleep 1
      #echo "Pronto....."

      #echo "Voy a reiniciar el Firewall en sucursal $sucursal"
      #sudo ssh -t suc$sucursal 'bash /tecnol/util/firewall.sh'
      #sleep 1
      #echo "Pronto....."

      #echo "Voy a bajar el Firewall en sucursal $sucursal"
      #sudo ssh -t suc$sucursal 'bash /tecnol/util/bajafirewall.sh'
      #sleep 1
      #echo "Pronto....."
     
      # echo "Voy a bajar el Firewall en sucursal $sucursal"
      # sudo ssh -t suc$sucursal 'bash /tecnol/util/bajafirewall.sh'
      # sleep 1
      # echo "Pronto....."


      echo "Grabo Reglas de Firewall  suc$sucursal"
      sudo ssh -t suc$sucursal '/sbin/iptables-save > /tecnol/util/active-rules'
      sudo scp suc$sucursal:/tecnol/util/active-rules active-rules-$sucursal 
      sleep 1
      echo "Pronto....."
done
