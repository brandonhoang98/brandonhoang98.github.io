*** NAND GATE TRANSCIENT ANALYSIS

.include model.mos

Vdd Vdd gnd DC 2.5

M1 Out A Vdd Vdd CMOSP L=0.25u W=5.0u
M2 Out A Vdd Vdd CMOSP L=0.25u W=5.0u

M3 Out B T1 gnd CMOSN L=0.25u W=5.0u
M4 T1 A gnd gnd CMOSN L= 0.25u W.5.0u

VA A gnd pulse (0 2.5 0 0.1ps 0.1ps 2ns 4ns)
VB B gnd pulse (0 2.5 0 0.1ps 0.1ps 1ns 2ns)
**measure tran TPLH trig V(in) val=1.25 fall=2 targ V(out) val=1.25 rise=2
**.measure tran TPHL trig V(in) val=1.25 rise=2 targ V(out) val=1.25 fall=2
.print V(in) V(out)
.tran 0.1ps 10ns
.end
