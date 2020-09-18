module Full_Adder(A,B,Cin,Sum,Cout);
    input A,B,Cin;
    output Sum,Cout;
    wire Int1, Int2, Int3;

    Half_Adder HA1(A,B, Int1, Int2) ;
    Half_Adder HA2 (Int1, Cin, Sum, Int3 );
    or (Cout, Int3, Int2	);
endmodule
