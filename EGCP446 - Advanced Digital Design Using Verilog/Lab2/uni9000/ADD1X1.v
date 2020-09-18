// Library - xc9000, Cell - ADD1X1, // View - schematic, Version - 0.2

module ADD1X1( CO, S0, A0, B0 );


output  CO, S0;

input  A0, B0;

`ifdef SYNTH
`else

    specify
	specparam CDS_LIBNAME  = "xc9000";
	specparam CDS_CELLNAME = "ADD1X1";
	specparam CDS_VIEWNAME = "schematic";
    endspecify

    XOR2  I_7( .I0(B0), .I1(A0), .O(S0));
    AND2  I_8( .I0(B0), .O(CO), .I1(A0));

`endif

endmodule
