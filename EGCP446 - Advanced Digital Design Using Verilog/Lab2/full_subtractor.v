module full_subtractor(a,b,bin,d,bout);
    input  a,b,bin;
    output  d,bout;
    // wire xor1, and1, and2, not1, not2;

    //not (not1, a);
    //xor (xor1, a, b);
    //and (and1, not1, b);
    //not (not2, xor1);
    //xor (d, bin, xor1);
    //and (and2, not2, and1);
    //or (bout, and2, and1);
	assign d = (bin ^ (a ^ b));
	assign bout = ((~a) & b) | ((~(a ^ b)) & bin);


endmodule
