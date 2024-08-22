OPTIONS
(
         ROWS=10000,
         ERRORS=1000000,
         DIRECT=NO
)
LOAD DATA
APPEND INTO TABLE T6931000
(

         CTARJNUM position(1:10)"603167080||:ctarjnum" ,
         CARTINUM position(11:11)
)
