***Lab No 4 RC delay Modelling
**** RC delay modelling

Vin in gnd pulse (0 1.8 0 1ns 1ns 2us 4us)
R in out 5k
Cout out gnd 15pF

.measure tran Tphl trig V(in) val=0.6 fall=2 targ V(out) val=0.6 fall=2
.measure tran Tplh trig V(in) val=0.6 rise=2 targ V(out) val=0.6 rise=2

.tran 1ns 15us

.print V(in) V(out)


.end

