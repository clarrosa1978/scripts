-- INSERTAR TODOS LOS DOCUMENTOS QUE DEBEN PARTICIPAR
spool &1
INSERT INTO t6931000 (ctarjnum,cartinum) 
(
SELECT '603167085'||LPAD(NRODOC,10,'0'), '0'
FROM ACTIVE_EMPLOYEE
WHERE SUBDIVISION in (229,231,910,920,940)  -- Sucursales que participan
--AND AREA_PERS in ('M4','M2') -- Categoría de Empleados que participan no definido
--AND to_date(FEC_ING,'YYYYMMDD') <= TO_DATE(SYSDATE,'DD-MON-YY') - 90 -- Días de Antiguedad mayor a 3 meses no definido
--AND TO_NUMBER(NRODOC) < 99999999 -- Control del número de documento menor a 8 digitos
AND length(nrodoc) between 5 and 8 -- Control del número de documento menor a 8 digitos
);
commit;
spool off
quit