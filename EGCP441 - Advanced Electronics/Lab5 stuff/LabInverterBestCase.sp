**** Lab no 5 circuit
.include mosistsmc180.sp

Vdd Vdd gnd DC 1.8


M1P out in	T1P	 Vdd PMOS L=0.1801um W=2.00um
M2P T1P in	Vdd	 Vdd PMOS L=0.1801um W=2.00um
M3P out in	Vdd  Vdd PMOS L=0.3603um W=2.00um

M1N out in		T1N gnd	NMOS L=0.18um W=0.90um
M2N out in		T1N gnd	NMOS L=0.18um W=0.90um
M3N T1N in	gnd	 gnd	NMOS L=0.09um W=0.90um

Vin in gnd pulse (0 1.8 0ps 1ps 1ps 1ns 2ns)

Cl out gnd 10fF
.tran 1ps 35ns

.print V(in) V(out) P(Vdd)

.measure S_pwr AVG P(Vdd) From=0ns to=32ns  ** Static Power
.measure curr integral I(Vdd) From=1ns to=3ns
.measure energy param = '1.8 * curr'

.measure charge_volt integral V(out) From=0ns to=32ns
** Use this to calculate dynamic power = CL * VL^2 * F * 0.5

.measure tran TPHL trig V(in) val=0.9 rise=1 targ V(out) val=0.9 fall=1
.measure tran TPLH trig V(in) val=0.9 fall=2 targ V(out) val=0.9 rise=2

.end
