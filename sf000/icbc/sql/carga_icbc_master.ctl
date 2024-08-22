-- Carga de Lista Blanca MASTER PAYROLL ICBC
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1118')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
