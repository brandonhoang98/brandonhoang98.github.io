module Half_Adder(a,b,s,c);
    input a,b;
    output s,c;

    xor (s,a,b);
    and (c,a,b);


endmodule
