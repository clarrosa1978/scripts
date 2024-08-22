-- Carga de Lista Blanca CREDITO SANTANDER  WOMEN
OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1223')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('6223')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
