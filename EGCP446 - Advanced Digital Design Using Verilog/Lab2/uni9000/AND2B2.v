
/*

FUNCTION	: 2-INPUT AND GATE

*/

`timescale  100 ps / 10 ps

`celldefine

module AND2B2 (O, I0, I1);


    output O;

    input  I0, I1;

    not N1 (i1_inv, I1);
    not N0 (i0_inv, I0);
    and A1 (O, i0_inv, i1_inv);

    specify
	(I0 *> O) = (0, 0);
	(I1 *> O) = (0, 0);
    endspecify

endmodule

`endcelldefine
