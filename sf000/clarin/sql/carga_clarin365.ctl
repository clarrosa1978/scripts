 -- This is a sample control file
    LOAD DATA
    APPEND
    INTO TABLE GENCF.T6931000
  (   	CTARJNUM position(1:19) ,
 	CARTINUM "TO_NUMBER('555190')"
  )
