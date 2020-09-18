

module full_subtractor_full_subtractor_tb_v_tf();


    reg a;
    reg b;
    reg bin;


    wire d;
    wire bout;


    full_subtractor uut (
        .a(a), 
        .b(b), 
        .bin(bin), 
        .d(d), 
        .bout(bout)
        );

        initial begin
            a = 0;
            b = 0;
            bin = 0;
		  #100;
		  a = 0;
		  b = 0;
		  bin = 1;
		  #100;
		  a = 0;
		  b = 1;
		  bin = 0;
		  #100;
		  a = 0;
		  b = 1;
		  bin = 1;
		  #100;
		  a = 1;
		  b = 0;
		  bin = 0;
		  #100;
		  a = 1;
		  b = 0;
		  bin = 1;
		  #100;
		  a = 1;
		  b = 1;
		  bin = 0;
		  #100;
		  a = 1;
		  b = 1;
		  bin = 1;
        end

endmodule

