-- Carga de Lista Blanca DEBITO PAYROLL ICBC
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1079')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
  INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('6079')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
