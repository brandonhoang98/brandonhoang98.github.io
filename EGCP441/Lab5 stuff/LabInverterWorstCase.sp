**** Lab no 5 circuit
.include mosistsmc180.sp

Vdd Vdd gnd DC 1.8

M1P 	out	A	T1P	Vdd PMOS L=0.1801um W=2.00um
M2P 	T1P	B	Vdd	Vdd PMOS L=0.1801um W=2.00um
M3P 	out	C	Vdd	Vdd PMOS L=0.3603um W=2.00um

M1N 	out		A	T1N gnd NMOS L=0.18um W=0.90um
M2N 	out		B	T1N gnd NMOS L=0.18um W=0.90um
M3N 	T1N		C	gnd	 gnd NMOS L=0.09um W=0.90um

Vin1 A gnd DC 1.8
Vin2 B gnd pulse (0 1.8 0ps 1ps 1ps 1ns 2ns)
Vin3 C gnd pulse (0 1.8 0ps 1ps 1ps 2ns 4ns)

Cl out gnd 10fF
.tran 1ps 20ns

.print V(B) V(out) V(C) P(Vdd)
.measure S_pwr AVG P(Vdd) From=1ns to=3ns  ** Static Power
.measure curr integral I(Vdd) From=1ns to=3ns
.measure energy param = '1.8 * curr'

.measure charge_volt integral V(out) From=1ns to=3ns
** Use this to calculate dynamic power = CL * VL^2 * F * 0.5

.measure tran TPHL trig V(B) val=0.9 rise=1 targ V(out) val=0.9 fall=1
.measure tran TPLH trig V(C) val=0.9 fall=2 targ V(out) val=0.9 rise=2

.end
