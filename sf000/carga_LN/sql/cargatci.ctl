OPTIONS
(
        ROWS=10000,
        ERRORS=1000000,
        DIRECT=NO
)
LOAD DATA 
TRUNCATE 
INTO TABLE T6197500_TEMP
(
        CTARJETA position(1:20) char,
        CSITCRED position(21:21) char
)
