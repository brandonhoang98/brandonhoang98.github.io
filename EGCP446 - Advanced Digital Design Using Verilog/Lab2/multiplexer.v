module multiplexer(x, y, cbin,op,fout,s);
    input   x, y, cbin,op;
    output reg fout,s;   
     always @*
    	if (op == 1'b0) 
		begin
	   	s = (cbin ^ (x ^ y));
		fout = (x & y) | (x & cbin) | (y & cbin);
		end
	else
		begin
		s = cbin ^ (x ^ y);
		fout = ((~x) & y) | ((~(x ^ y)) & cbin);
		end

endmodule
				  