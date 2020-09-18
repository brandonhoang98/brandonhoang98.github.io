

module full_adder_full_adder_tb_v_tf();

    reg a;
    reg b;
    reg cin;

    wire sum;
    wire cout;

    full_adder uut (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout)
        );

        initial begin
            a = 0;
            b = 0;
            cin = 0;
		  #100;
		  a = 0;
		  b = 0;
		  cin = 1;
		  #100;
		  a = 0;
		  b = 1;
		  cin = 0;
		  #100;
		  a = 0;
		  b = 1;
		  cin = 1;
		  #100;
		  a = 1;
		  b = 0;
		  cin = 0;
		  #100;
		  a = 1;
		  b = 0;
		  cin = 1;
		  #100;
		  a = 1;
		  b = 1;
		  cin = 0;
		  #100;
		  a = 1;
		  b = 1;
		  cin = 1;
        end

endmodule

