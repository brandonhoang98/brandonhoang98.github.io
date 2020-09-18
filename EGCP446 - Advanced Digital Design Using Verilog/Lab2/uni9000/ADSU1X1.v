// Library - xc9000, Cell - ADSU1X1, // View - schematic, Version - 0.2
//

module ADSU1X1( CO, S0, A0, ADD, B0 );


output  CO, S0;

input  A0, ADD, B0;

`ifdef SYNTH
`else

    specify
	specparam CDS_LIBNAME  = "xc9000";
	specparam CDS_CELLNAME = "ADSU1X1";
	specparam CDS_VIEWNAME = "schematic";
    endspecify

    XOR2  I_31( .I0(A0), .I1(B0), .O(S0));
    AND2B1 I_1( .I0(ADD), .I1(sub_c0), .O(m0));
    AND2   I_2( .I0(ADD), .I1(add_c0), .O(m1));
    OR2    I_3( .I0(m0), .I1(m1), .O(CO));
    OR2B1  I_4( .I0(B0), .I1(A0), .O(sub_c0));
    AND2  I_7( .I0(B0), .O(add_c0), .I1(A0));

`endif

endmodule
