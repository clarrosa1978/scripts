OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
LOAD DATA
APPEND INTO TABLE T6931000
(
CTARJNUM POSITION(1:10) "'603167088' || LPAD(:CTARJNUM,10,'0')" ,
CARTINUM "TO_CHAR('0')"
)