// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/RAM64X1S_1.v,v 1.8 2003/01/21 01:55:41 wloo Exp $

/*

FUNCTION	: 64x1 Static RAM with synchronous write capability

*/

`timescale  100 ps / 10 ps


module RAM64X1S_1 (O, A0, A1, A2, A3, A4, A5, D, WCLK, WE);

    parameter INIT = 64'h0000000000000000;

    output O;

    input  A0, A1, A2, A3, A4, A5, D, WCLK, WE;

    reg  mem [63:0];
    wire [5:0] adr;
    reg  [6:0] count;
    wire d_in, wclk_in, we_in;

    buf b_d    (d_in, D);
    buf b_wclk (wclk_in, WCLK);
    buf b_we   (we_in, WE);

    buf b_a5 (adr[5], A5);
    buf b_a4 (adr[4], A4);
    buf b_a3 (adr[3], A3);
    buf b_a2 (adr[2], A2);
    buf b_a1 (adr[1], A1);
    buf b_a0 (adr[0], A0);

    buf b_o (O, o_int);

    buf b_o_int (o_int, mem[adr]);

    initial begin
	for (count = 0; count < 64; count = count + 1)
	    mem[count] <= INIT[count];
    end

    always @(negedge wclk_in) begin
	if (we_in == 1'b1)
	    mem[adr] <= d_in;
    end

    specify
	if (WE)
	    (WCLK => O) = (0, 0);

	(A5 => O) = (0, 0);
	(A4 => O) = (0, 0);
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

