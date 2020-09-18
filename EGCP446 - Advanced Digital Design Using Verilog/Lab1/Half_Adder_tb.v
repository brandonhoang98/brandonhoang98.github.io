

module Half_Adder_Half_Adder_tb_v_tf();

    reg a;
    reg b;


    wire s;
    wire c;



    Half_Adder uut(
        .a(a), 
        .b(b), 
        .s(s), 
        .c(c)
        );

        initial begin
            a = 0;
            b = 0;
		  #100;
		  a = 0;
		  b = 1;
		  #100;
		  a = 1;
		  b = 0;
		  #100;
		  a = 1;
		  b = 1;
		  #100;
        end

 


endmodule

