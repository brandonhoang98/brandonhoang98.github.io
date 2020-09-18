// Library - xc9000, Cell - ADD1X2, // View - schematic, Version - 0.2

module ADD1X2( CO, S0, A0, B0, CI );


output  CO, S0;

input  A0, B0, CI;

`ifdef SYNTH
`else

    specify
	specparam CDS_LIBNAME  = "xc9000";
	specparam CDS_CELLNAME = "ADD1X2";
	specparam CDS_VIEWNAME = "schematic";
    endspecify

    XOR3  I_7( .I1(A0), .I2(B0), .I0(CI), .O(S0));
    AND2  I_8( .I0(B0), .O(ab0), .I1(A0));
    AND2  I_10( .I0(CI), .O(a0ci), .I1(A0));
    AND2  I_9( .I0(B0), .O(b0ci), .I1(CI));
    OR3  I_6( .I2(ab0), .I0(b0ci), .O(CO), .I1(a0ci));

`endif

endmodule
