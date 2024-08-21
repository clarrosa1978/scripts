exit 0
echo "NO ESTA HABILITADA LA OPCION"
echo " REINICIANDO ATG_PROD_3"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_3"'
ssh scdigi02 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_3 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_4"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_4"'
ssh scdigi02 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_4 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_5"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_5"'
ssh scdigi04 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_5 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_6"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_6"'
ssh scdigi04 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_6 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_7"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_7"'
ssh scdigi05 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_7 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_8"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_8"'
ssh scdigi05 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_8 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_11"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_11"'
ssh scdigi07 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_11 t3://scdigi01:7001"'

echo " REINICIANDO ATG_PROD_12"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_prod_12"'
ssh scdigi07 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_prod_12 t3://scdigi01:7001"'

echo " REINICIANDO ATG_SCENARIO"
ssh scdigi01 'su - oraatg -c "/tecnol/weblogic/stop_nodes.sh `date +%Y%m%d` atg_scenario"'
ssh scdigi03 'su - oraatg -c "/tecnol/weblogic/start_nodes.sh `date +%Y%m%d` atg_scenario t3://scdigi01:7001"'
