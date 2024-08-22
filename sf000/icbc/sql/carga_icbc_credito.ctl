-- Carga de Lista Blanca VISA PAYROLL ICBC
    LOAD DATA
    APPEND
    INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('1078')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
 INTO TABLE U601.T6741400
  (     CCODDESC "TO_CHAR('6078')",
        CNUMEBIN position(1:16),
        XMEMORIA "TO_CHAR('0')"
  )
