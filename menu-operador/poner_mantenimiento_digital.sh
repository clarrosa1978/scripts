echo "Bajo el webserver de ohsclus01"
echo ""
ssh ohsclus01 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
echo ""
echo ""
ssh ohsclus01 'cp -pr /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf-BACKUP'
ssh ohsclus01 'cp -pr /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf.MANTENIMIENTO /ohs/oracle_ohs/user_projects/domains/Cotodigital/config/fmwconfig/components/OHS/instances/ohs1/httpd.conf'
echo ""
ssh ohsclus01 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/startComponent.sh ohs1"'
echo ""
echo ""
echo "Bajo el webserver de ohsclus02"
ssh ohsclus02 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
echo ""
echo ""
echo "Bajo el webserver de ohsclus03"
ssh ohsclus03 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
echo ""
echo ""
echo "Bajo el webserver de ohsclus04"
ssh ohsclus04 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
echo ""
echo ""
echo "Bajo el webserver de ohsclus05"
ssh ohsclus05 'su - oraohs -c "/ohs/oracle_ohs/user_projects/domains/Cotodigital/bin/stopComponent.sh ohs1"'
echo ""
echo ""
echo " Ya se encuentra en mantenimiento la pagina. Validar ingresando a www.cotodigital.com.ar"
echo ""
echo ""
echo "Presione "ENTER" para continuar"
read cont
