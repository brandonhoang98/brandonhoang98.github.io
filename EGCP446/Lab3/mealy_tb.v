

module mealy_mealy_tb_v_tf();

    reg clk;
    reg rst;
    reg up;

    wire [1:0] W;

    mealy uut (
        .clk(clk), 
        .rst(rst), 
        .up(up), 
        .W(W)
        );

        initial begin
            clk = 0;
            rst = 1;
            up = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  #100;
		  clk = 1;
		  #100;
		  clk = 0;
		  rst = 0;
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
		  up = 1;
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

