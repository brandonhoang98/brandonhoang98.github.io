*** Lab No 6 Part 1
.include mosistsmc180.sp

Vdd Vdd gnd DC 2.5
M2 	out	in Vdd Vdd PMOS L=0.18um W=3.06um
M1  out in gnd gnd NMOS L=0.18um W=1.80um
Vin in gnd pulse (2.5 0 0ps 1ps 1ps 1us 2us)
Cl	out gnd	100fF

.measure tran Tphl trig V(in) val=1.25 rise=1 targ V(out) val=1.25 fall=1
.measure tran Tplh trig V(in) val=1.25 fall=1 targ V(out) val=1.25 rise=1

.tran 1ns 10us
.print V(in) V(out)
