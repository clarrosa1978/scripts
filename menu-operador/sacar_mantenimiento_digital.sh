echo "Bajo el webserver de ohsclus01"
echo ""
echo ""
ssh ohsclus01 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
ssh ohsclus01 'mv /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf-BACKUP /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf'
echo "Levanto el webserver de ohsclus01"
echo ""
ssh ohsclus01 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo "Se levanto el webserver de ohsclus01".
echo ""
echo ""
echo "Levanto el webserver de ohsclus02"
ssh ohsclus02 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo ""
echo ""
echo "Levanto el webserver de ohsclus03"
ssh ohsclus03 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo ""
echo ""
echo "Levanto el webserver de ohsclus04"
ssh ohsclus04 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo ""
echo ""
echo "Levanto el webserver de ohsclus05"
ssh ohsclus05 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo ""
echo ""
echo "Se saco la pagina de mantenimiento. Validar ingresando a www.cotodigital.com.ar"
echo ""
echo ""
echo "Presione "ENTER" para continuar"
read cont
