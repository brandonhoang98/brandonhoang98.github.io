module ClockDivider(CLKin,RESET,CLKout);
    input CLKin;
    input RESET;
    output reg CLKout;

    parameter CLKoriginal = 50000000;
    integer CLKvalue = 0;
    always @(posedge CLKin, posedge RESET)
    if (RESET	== 1'b1)
    		CLKvalue <= 0;
 	else 
		if (CLKvalue == CLKoriginal)
		begin
			CLKout = 1'b1;
			CLKvalue <=  0;
		end
		else
		begin
			CLKvalue <= CLKvalue + 1;
			CLKout = 1'b0;
		end

    
endmodule
