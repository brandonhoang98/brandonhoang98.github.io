module moore(clk,rst,W);
    input clk, rst;
    output [3:0] W;
	reg [4:0] state_reg, state_next;

	parameter S0 = 5'b00001;
	parameter S1 = 5'b00010;
	parameter S2 = 5'b00100;
	parameter S3 = 5'b01000;
	parameter S4 = 5'b10100;
	parameter S5 = 5'b10010;
	always @(posedge clk, posedge rst)
	
	if (rst) state_reg <= S0;
	else
		state_reg <= state_next;
	
	always @(*)
	case (state_reg)
	S0: state_next =  S1;
	S1: state_next =  S2;
	S2: state_next = S3;
	S3: state_next = S4;
	S4: state_next = S5;
	S5: state_next = S0;
	default: state_next = S0;
	endcase
	assign W = state_reg[3:0];

endmodule
