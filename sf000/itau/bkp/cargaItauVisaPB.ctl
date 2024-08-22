-- Carga de Lista Blanca CREDITO VISA ITAU PB 
OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1215')",
        CNUMEBIN position(3:18),
        XMEMORIA "TO_CHAR('0')"
  )
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('6215')",
        CNUMEBIN position(3:18),
        XMEMORIA "TO_CHAR('0')"
  )
