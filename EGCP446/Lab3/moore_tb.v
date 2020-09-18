

module moore_moore_tb_v_tf();


    reg clk;
    reg rst;



    wire [3:0] W;

    moore uut (
        .clk(clk), 
        .rst(rst), 
        .W(W)
        );

        initial begin
            clk = 0;
            rst = 0;
		  #100;
		  rst = 1;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  rst = 0;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
        end

    

endmodule

