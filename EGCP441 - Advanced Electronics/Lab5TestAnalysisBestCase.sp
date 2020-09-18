*** NAND GATE TRANSCIENT ANALYSIS

.include model.mos

Vdd Vdd gnd DC 2.5

M1 Out in Vdd Vdd CMOSP L=0.25u W=5.0u
M2 Out in Vdd Vdd CMOSP L=0.25u W=5.0u

M3 Out in T1 gnd CMOSN L=0.25u W=5.0u
M4 T1 in gnd gnd CMOSN L= 0.25u W.5.0u


Vin in gnd pulse (0 2.5 0 0.1ps 0.1ps 1ns 2ns)

.print V(in) V(out)
.tran 0.1ps 10ns
.end
