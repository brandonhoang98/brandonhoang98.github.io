module Four_RCA(A,B,Cin,Sum,Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] Sum;
    output Cout;

    wire C1,C2,C3;

    Full_Adder FA1( A[0], B[0], Cin, Sum[0], C1);
    Full_Adder FA2( A[1], B[1], C1, Sum[1], C2);
    Full_Adder FA3( A[2], B[2], C2, Sum[2], C3);
    Full_Adder FA4( A[3], B[3], C3, Sum[3], Cout); 


endmodule
