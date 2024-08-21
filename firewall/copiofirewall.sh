#!/usr/bin/ksh

for sucursal in 142 143 149 151 152 153 154 155 158 159 160 162 163 164 165 166 167 168 170 171 174 175 176 177 178 179 180 181 183 184 186 188 189 192 197 

#for sucursal in 02

do
      echo "Voy a copiar el firewall en $sucursal"
      sudo  scp firewall.sh bajafirewall.sh check* util* suc$sucursal:/tecnol/util
      echo "Pronto"
done

