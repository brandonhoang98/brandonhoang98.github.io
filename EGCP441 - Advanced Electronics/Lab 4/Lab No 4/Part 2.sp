*** Lab No 4 Part 2
.include MMBF170.mod
.include BS250.mod

Vdd Vdd gnd DC 12
X2 	out	in	Vdd	BS250P
X1  out in gnd BS170
Vin in gnd pulse (0 12 0 1ns 1ns 2us 4us)
Cl	out gnd	10nF

.measure tran Tphl trig V(in) val=6 rise=2 targ V(out) val=6 fall=2
.measure tran Tplh trig V(in) val=6 fall=2 targ V(out) val=6 rise=2

.tran 1ns 10us
.print V(in) V(out)
