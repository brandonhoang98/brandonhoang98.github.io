

module multiplexer_multiplexer_tb_v_tf();

    reg x;
    reg y;
    reg cbin;
    reg op;

    wire fout;
    wire s;

    multiplexer uut (
        .x(x), 
        .y(y), 
        .cbin(cbin), 
        .op(op), 
        .fout(fout), 
        .s(s)
        );

        initial begin
            x = 0;
            y = 0;
            cbin = 0;
            op = 0;
			#100;
			x = 0;
			y = 0;
			cbin = 0;
			op = 1;
			#100;
			x = 0;
			y = 0;
			cbin = 1;
			op = 0;
			#100;
			x = 0;
			y = 0;
			cbin = 1;
			op = 1;
			#100;
			x = 0;
			y = 1;
			cbin = 0;
			op = 0;
			#100;
			x = 0;
			y = 1;
			cbin = 0;
			op = 1;
			#100;
			x = 0;
			y = 1;
			cbin = 1;
			op = 0;
			#100;
			x = 0;
			y = 1;
			cbin = 1;
			op = 1;
			#100;
			x = 1;
			y = 0;
			cbin = 0;
			op = 0;
			#100;
			x = 1;
			y = 0;
			cbin = 0;
			op = 1;
			#100;
			x = 1;
			y = 0;
			cbin = 1;
			op = 0;
			#100;
			x = 1;
			y = 0;
			cbin = 1;
			op = 1;
			#100;
			x = 1;
			y = 1;
			cbin =0;
			op = 0;
			#100;
			x = 1;
			y = 1;
			cbin = 0;
			op = 1;
			#100;
			x = 1;
			y = 1;
			cbin = 1;
			op = 0;
			#100;
			x = 1;
			y = 1;
			cbin = 1;
			op = 1;
        end

endmodule

