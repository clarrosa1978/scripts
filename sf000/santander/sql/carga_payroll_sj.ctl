-- Carga de Lista Blanca DEBITO PAYROLL SANTANDER JUBILADOS
OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1156')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('6156')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
