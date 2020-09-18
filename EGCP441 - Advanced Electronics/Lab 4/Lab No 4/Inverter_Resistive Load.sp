***Lab No 4 Resistor Inverter
.include MMBF170.mod

Vdd Vdd gnd DC 12
Rd  Vdd out 5K
X1  out in gnd BS170
Vin in gnd pulse (0 12 0 1ns 1ns 2us 4us)
Cl out gnd 30pF

.measure tran Tphl trig V(in) val=6 rise=2 targ V(out) val=6 fall=2
.measure tran Tplh trig V(in) val=6 fall=2 targ V(out) val=6 rise=2

.tran 1ns 10us
.print V(in) V(out)
