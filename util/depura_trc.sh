#Depuramos los filesystems /software/app/oracle/admin

        find /10g/app/oracle10/admin/CTC/udump/ \( -name "*.trc" \) -mtime +3 -exec rm {} \;
        find /10g/app/oracle10/admin/CTC/bdump/ \( -name "*.trc" \) -mtime +3 -exec rm {} \;
        find /10g/app/oracle10/admin/CTC/cdump/ \( -name "core_*" \) -mtime +3 -exec delete -rf {} \;  2>/dev/null

        find /u01/app/oracle/admin/IGI/udump/ \( -name "*.trc" \) -mtime +3 -exec rm {} \;
        find /u01/app/oracle/admin/IGI/bdump/ \( -name "*.trc" \) -mtime +3 -exec rm {} \;
        find /u01/app/oracle/admin/IGI/cdump/ \( -name "core_*" \) -mtime +3 -exec delete -rf {} \;  2>/dev/null

