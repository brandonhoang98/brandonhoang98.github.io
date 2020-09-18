// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ROM32X1.v,v 1.8 2003/01/21 01:55:43 wloo Exp $

/*

FUNCTION	: ROM 32x1

*/

`timescale  100 ps / 10 ps


module ROM32X1 (O, A0, A1, A2, A3, A4);

    parameter INIT = 32'h00000000;

    output O;

    input  A0, A1, A2, A3, A4;

    wire dout;
    wire [4:0] adr;

    reg mem [0:31];
    reg  [5:0] count;

    buf b0 (adr[4], A4);
    buf b1 (adr[3], A3);
    buf b2 (adr[2], A2);
    buf b3 (adr[1], A1);
    buf b4 (adr[0], A0);
    buf b5 (O, dout);

    initial begin
	for(count = 0; count < 32; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A4 => O) = (0, 0);
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

