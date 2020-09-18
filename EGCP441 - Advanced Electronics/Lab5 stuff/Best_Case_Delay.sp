**** Lab no 5 Sample Inverter
.include mosistsmc180.sp

Vdd Vdd gnd DC 1.8

M1P out in Vdd Vdd PMOS L=0.18um W=2.00um
M2P T1P in Vdd Vdd PMOS L=0.18um W=4.00um
M3P T1P in Vdd Vdd PMOS L=0.18um W=4.00um
M4P out in T1P Vdd PMOS L=0.18um W=4.00um


M1N out in T1N gnd NMOS L=0.18um W=2.7um
M2N T1N in T2N gnd NMOS L=0.18um W=2.70um
M3N out in T2N gnd NMOS L=0.18um W=1.35um
M4N T2N in gnd gnd NMOS L=0.18um W=2.70um


Vin in gnd pulse (0 1.8 0ps 1ps 1ps 1ns 2ns)

Cl out gnd 10fF
.tran 1ps 35ns

.print V(in)  V(out)

.measure tran TPHL trig V(in) val=0.9 rise=1 targ V(out) val=0.9 fall=1
.measure tran TPLH trig V(in) val=0.9 fall=2 targ V(out) val=0.9 rise=2

.end

