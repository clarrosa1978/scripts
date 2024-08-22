OPTIONS
(
        ROWS=10000,
        ERRORS=1000000,
        DIRECT=YES
)
LOAD DATA 
APPEND
INTO TABLE U601.T6197500
(
        CTARJETA position(1:20) char,
        CSITCRED position(21:21) char
)

