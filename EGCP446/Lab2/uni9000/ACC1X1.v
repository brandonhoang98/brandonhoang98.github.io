
/*

FUNCTION	: ACC1X1

*/

`timescale  100 ps / 10 ps

`celldefine

module ACC1X1 (CO, Q0, ADD, B0, C, CE, D0, L, R);


    output CO, Q0;

    input  ADD, B0, C, CE, D0, L, R;

    OR3  I_15( .I2(net10), .I0(net37), .O(CO), .I1(net34));
    AND4B3  I_80( .I2(L), .I3(CE), .I1(R), .O(net21), .I0(ADD));
    XOR3  I_4( .I1(net24), .I2(net21), .I0(net45), .O(net23));
    OR2  I_8( .O(net24), .I0(net50), .I1(net26));
    FDCP I_64( .Q(Q0), .C(C), .D(net23), .CLR(net99), .PRE(net99));
    AND2  I_12( .I0(net45), .O(net10), .I1(net24));
    AND2  I_13( .I0(net21), .O(net34), .I1(net24));
    AND2  I_14( .I0(net21), .O(net37), .I1(net45));
    AND4B2  I_5( .I2(CE), .O(net26), .I1(L), .I0(R), .I3(net43));
    AND3B2  I_7( .I0(R), .O(net45), .I2(Q0), .I1(L));
    AND3B1  I_6( .I1(L), .I0(R), .O(net50), .I2(D0));
    XNOR2  I_3( .I0(ADD), .O(net43), .I1(B0));
    GND   I_99(.G(net99));

endmodule

`endcelldefine
