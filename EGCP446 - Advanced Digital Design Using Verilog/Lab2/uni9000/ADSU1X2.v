// Library - xc9000, Cell - ADSU1X2, // View - schematic, Version - 0.2
//

module ADSU1X2( CO, S0, A0, ADD, B0, CI );


output  CO, S0;

input  A0, ADD, B0, CI;

`ifdef SYNTH
`else

    specify
	specparam CDS_LIBNAME  = "xc9000";
	specparam CDS_CELLNAME = "ADSU1X2";
	specparam CDS_VIEWNAME = "schematic";
    endspecify

    OR2B1  I_5( .I0(B0), .I1(A0), .O(a1_0));
    AND2B1 I_1( .I0(ADD), .I1(sub_c0), .O(m0));
    AND2   I_2( .I0(ADD), .I1(add_c0), .O(m1));
    OR2    I_3( .I0(m0), .I1(m1), .O(CO));
    AND2B1  I_4( .I0(B0), .I1(A0), .O(a0_0));
    XNOR4  I_12( .I0(ADD), .I1(A0), .O(S0), .I3(CI), .I2(B0));
    AND2  I_10( .I0(CI), .O(a1ci), .I1(a1_0));
    AND2  I_8( .I0(CI), .O(a2ci), .I1(a2_0));
    AND2  I_7( .I0(B0), .O(a3_0), .I1(A0));
    OR2  I_9( .O(add_c0), .I0(a3_0), .I1(a2ci));
    OR2  I_11( .O(sub_c0), .I0(a1ci), .I1(a0_0));
    OR2  I_6( .O(a2_0), .I0(B0), .I1(A0));

`endif

endmodule
