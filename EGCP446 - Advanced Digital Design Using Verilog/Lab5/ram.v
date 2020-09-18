module RAM(addr,clk,din,dout,we);
    input [1:0] addr;
    input clk;
    input [3:0] din;
    output [3:0] dout;
    input we;

  reg [3:0] Mem_out[0:3];

  always@(posedge clk)
  begin

  if(we)
  Mem_out[addr] <= din;	 

  else
 
	Mem_out[addr] <= Mem_out[addr];
   
  end 

		assign dout = Mem_out[addr];

endmodule
