**** Lab no 5 Sample Inverter
.include mosistsmc180.sp

Vdd Vdd gnd DC 1.8

M1 out gate Vdd Vdd PMOS L=0.18um W=2.00um
M2 out gate gnd gnd NMOS L=0.18um W=0.90um

Vin gate gnd pulse (0 1.8 0ps 1ps 1ps 1ns 2ns)
Cl out gnd 10fF
.tran 1ps 5ns

.print V(gate) V(out) P(Vdd)
.measure S_pwr AVG P(Vdd) From=1ns to=3ns  ** Static Power
.measure curr integral I(Vdd) From=1ns to=3ns
.measure energy param = '1.8 * curr'

.measure charge_volt integral V(out) From=1ns to=3ns
** Use this to calculate dynamic power = CL * VL^2 * F * 0.5

.measure tran TPHL trig V(gate) val=0.9 rise=1 targ V(out) val=0.9 fall=1
.measure tran TPLH trig V(gate) val=0.9 fall=2 targ V(out) val=0.9 rise=2

.end

