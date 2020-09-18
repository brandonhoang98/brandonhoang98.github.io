**** RC Delay

R1 in 1 120
C1 1 gnd 75fF
R2 1 2 156
C2 2 gnd 100fF
R3 2 3 80
C3 3 gnd 95fF
R4 2 4 105
C4 4 gnd 65fF
R5 4 5 220
C5 5 gnd 200fF
R6 1 6 100
C6 6 gnd 15fF
R7 6 7 150
C7 7 gnd 45fF
R8 7 8 90
C8 8 gnd 50fF

Vin in gnd pulse (2.5 0 0 1ps 1ps 1ns 2ns)
.measure TPLH tran trig  V(in) val=1.25 rise=1 targ V(8) val=1.25 rise=1
.print V(in) V(8)
.tran 1ps 10ns

.end
