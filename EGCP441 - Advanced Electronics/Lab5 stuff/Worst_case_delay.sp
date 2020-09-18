**** Lab no 5 Sample Inverter
.include mosistsmc180.sp

Vdd Vdd gnd DC 1.8

M1P out A Vdd Vdd PMOS L=0.18um W=2.00um
M2P T1P B Vdd Vdd PMOS L=0.18um W=4.00um
M3P T1P C Vdd Vdd PMOS L=0.18um W=4.00um
M4P out D T1P Vdd PMOS L=0.18um W=4.00um


M1N out B T1N gnd NMOS L=0.18um W=2.7um
M2N T1N C T2N gnd NMOS L=0.18um W=2.70um
M3N out D T2N gnd NMOS L=0.18um W=1.35um
M4N T2N A gnd gnd NMOS L=0.18um W=2.70um


Vin1 D gnd DC 0
*pulse (0 1.8 0ps 1ps 1ps 1ns 2ns)
Vin2 C gnd  DC 1.8
*pulse (0 1.8 0ps 1ps 1ps 2ns 4ns)
Vin3 B gnd pulse (0 1.8 0ps 1ps 1ps 4ns 8ns)
Vin4 A gnd DC 1.8

Cl out gnd 10fF
.tran 1ps 20ns

.print V(B)  V(out)

.measure tran TPHL trig V(B) val=0.9 rise=1 targ V(out) val=0.9 fall=1
.measure tran TPLH trig V(B) val=0.9 fall=2 targ V(out) val=0.9 rise=2

.end

