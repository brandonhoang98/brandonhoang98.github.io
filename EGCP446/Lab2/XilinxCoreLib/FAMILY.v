/* $Header: /devl/xcs/repo/env/Databases/ip/src/com/xilinx/ip/unisim/simulation/FAMILY.v,v 1.5 2002/04/09 10:13:37 scott Exp $
--
-- Description - 
*/

`define any       "any"
`define x4k       "x4k"
`define x4ke      "x4ke"
`define x4kl      "x4kl"
`define x4kex     "x4kex"
`define x4kxl     "x4kxl"
`define x4kxv     "x4kxv"
`define x4kxla    "x4kxla"
`define spartan   "spartan"
`define spartanxl "spartanxl"
`define spartan2  "spartan2"
`define spartan2e "spartan2e"
`define virtex    "virtex"
`define virtexe   "virtexe"
`define virtex2   "virtex2"
`define virtex2p  "virtex2p"
`define spartan3  "spartan3"

module family ( );

/*
 * True if architecture "child" is derived from, or equal to,
 * the architecture "ancestor".
 * ANY, X4K, SPARTAN, SPARTANXL
 * ANY, X4K, X4KE, X4KL
 * ANY, X4K, X4KEX, X4KXL, X4KXV, X4KXLA
 * ANY, VIRTEX, SPARTAN2, SPARTAN2E
 * ANY, VIRTEX, VIRTEXE
 * ANY, VIRTEX, VIRTEX2, SPAERAN3
 * ANY, VIRTEX, VIRTEX2, VIRTEX2P
 */

function derived;
    input [9*8:1] child;
    input [9*8:1] ancestor;
    begin
        derived = 0;
        if ( child == `virtex ) 
	begin
	    if ( ancestor == `virtex || ancestor == `any )
	    begin
                derived = 1;
            end
	end
	else if ( child == `virtex2 )
	begin
	    if ( ancestor == `virtex2 || ancestor == `virtex || ancestor == `any )
	    begin
                derived = 1;
            end
	end
	else if ( child == `virtex2p )
	begin
	    if ( ancestor == `virtex2p || ancestor == `virtex2 || ancestor == `virtex || ancestor == `any )
	    begin
	        derived = 1;
            end
	end
	else if ( child == `spartan3 )
	begin
	    if ( ancestor == `spartan3 || ancestor == `virtex2 || ancestor == `virtex || ancestor == `any )
	    begin
	        derived = 1;
            end
	end
	else if ( child == `virtexe )
	begin
	    if ( ancestor == `virtexe || ancestor == `virtex || ancestor == `any )
	    begin
	        derived = 1;
            end	    
	end
	else if ( child == `spartan2 )
	begin
	    if ( ancestor == `spartan2 || ancestor == `virtex || ancestor == `any )
	    begin
	        derived = 1;
            end
	end
	else if ( child == `spartan2e )
	begin
	    if ( ancestor == `spartan2e || ancestor == `spartan2 || ancestor == `virtex || ancestor == `any )
	    begin
	        derived = 1;
            end
	end
        else if ( child == `x4k )
	begin
            if ( ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `x4kex )
	begin
            if ( ancestor == `x4kex || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `x4kxl )
	begin
            if ( ancestor == `x4kxl || ancestor == `x4kex || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `x4kxv )
	begin
            if ( ancestor == `x4kxv || ancestor == `x4kxl || ancestor == `x4kex || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `x4kxla )
	begin
            if ( ancestor == `x4kxla || ancestor == `x4kxv || ancestor == `x4kxl || ancestor == `x4kex || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `x4ke )
	begin
            if ( ancestor == `x4ke || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end 	    
	end
        else if ( child == `x4kl )
	begin
            if ( ancestor == `x4kl || ancestor == `x4ke || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `spartan )
	begin
            if ( ancestor == `spartan || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `spartanxl )
	begin
            if ( ancestor == `spartanxl || ancestor == `spartan || ancestor == `x4k || ancestor == `any )
	    begin
                derived = 1;
            end
	end
        else if ( child == `any )
	begin
            if ( ancestor == `any )
	    begin
                derived = 1;
            end
	end
    end
endfunction //my_func

endmodule
