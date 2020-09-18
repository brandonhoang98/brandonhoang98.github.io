
/*

FUNCTION	: ACC1X2

*/

`timescale  100 ps / 10 ps

`celldefine

module ACC1X2(CO, Q0, ADD, B0, C, CE, CI, D0, L, R);


output  CO, Q0;

input  ADD, B0, C, CE, CI, D0, L, R;

`ifdef SYNTH
`else

    specify
	specparam CDS_LIBNAME  = "xc9000";
	specparam CDS_CELLNAME = "ACC1X2";
	specparam CDS_VIEWNAME = "schematic";
    endspecify

    OR2  I_8( .O(net11), .I0(net30), .I1(net13));
    AND3B2  I_7( .I0(R), .O(net15), .I2(Q0), .I1(L));
    AND4B2  I_5( .I2(CE), .O(net13), .I1(L), .I0(R), .I3(net22));
    XOR3  I_4( .I1(net11), .I2(CI), .I0(net15), .O(net27));
    AND3B1  I_6( .I1(L), .I0(R), .O(net30), .I2(D0));
    FDCP I_64( .Q(Q0), .C(C), .D(net27), .CLR(net99), .PRE(net99));
    AND2  I_14( .I0(CI), .O(net36), .I1(net15));
    AND2  I_13( .I0(CI), .O(net39), .I1(net11));
    AND2  I_12( .I0(net15), .O(net47), .I1(net11));
    XNOR2  I_3( .I0(ADD), .O(net22), .I1(B0));
    OR3  I_15( .I2(net47), .I0(net36), .O(CO), .I1(net39));
    GND   I_99(.G(net99));

`endif

endmodule

`endcelldefine
