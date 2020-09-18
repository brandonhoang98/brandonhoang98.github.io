// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/s/ROM256X1.v,v 1.8 2003/01/21 01:55:43 wloo Exp $

/*

FUNCTION	: ROM 256x1

*/

`timescale  100 ps / 10 ps


module ROM256X1 (O, A0, A1, A2, A3, A4, A5, A6, A7);

    parameter INIT = 256'h0000000000000000000000000000000000000000000000000000000000000000;

    output O;

    input  A0, A1, A2, A3, A4, A5, A6, A7;

    wire dout;
    wire [7:0] adr;

    reg mem [0:255];
    reg  [15:0] count;

    buf b0 (adr[7], A7);
    buf b1 (adr[6], A6);
    buf b2 (adr[5], A5);
    buf b3 (adr[4], A4);
    buf b4 (adr[3], A3);
    buf b5 (adr[2], A2);
    buf b6 (adr[1], A1);
    buf b7 (adr[0], A0);
    buf b8 (O, dout);

    initial begin
	for(count = 0; count < 256; count = count + 1)
	    mem[count] = INIT[count];
    end

    assign dout = mem[adr];

    specify
	(A7 => O) = (0, 0);
	(A6 => O) = (0, 0);
	(A5 => O) = (0, 0);
	(A4 => O) = (0, 0);
	(A3 => O) = (0, 0);
	(A2 => O) = (0, 0);
	(A1 => O) = (0, 0);
	(A0 => O) = (0, 0);
    endspecify

endmodule

