module full_adder(a,b,cin,sum,cout);
    input  a,b,cin;
    output  sum,cout;
    //wire xor1, and1,and2,and3;

    //xor (xor1, a, b);
    //xor (sum, xor1, cin);
   // and (and1, a, b);
    //and (and2, a, cin);
    //and (and3, cin, b);
   // or  (cout, and1, and2, and3);
	assign sum = (cin ^ (a ^ b));
	assign cout = ((a & b) | (a & cin) | (b & cin));
		   
endmodule			   
