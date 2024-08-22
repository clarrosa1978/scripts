-- Carga de Lista Blanca CREDITO MASTER ITAU PB 
OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1216')",
        CNUMEBIN position(3:18),
        XMEMORIA "TO_CHAR('0')"
  )
