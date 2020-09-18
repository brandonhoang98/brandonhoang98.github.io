module mealy(clk, rst, up, W);
	input clk, rst, up;
	output [1:0] W;
	reg [1:0] state_reg, state_next;
	
	parameter a = 2'b00;
	parameter b = 2'b01;
	parameter c = 2'b10;
	parameter d = 2'b11;
	always @(posedge clk, posedge rst)
	if (rst) state_reg <= a;
	else
		state_reg <= state_next; 
		
	always @(*)
	case (state_reg)
	a: if(up) state_next = b;
		else state_next = d;
	b: 	if(up) state_next = c;
		else 	state_next = a;
	c: 	if(up) 	state_next = d;
		else	state_next = b;
	d:	if(up)	state_next = a;
		else	state_next = c;
	
	default: state_next = a;
	endcase
	assign W = state_reg;
	
endmodule
	