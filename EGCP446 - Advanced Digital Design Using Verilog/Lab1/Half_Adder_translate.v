// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim Half_Adder.ngd Half_Adder_translate.v 
// Input file   : Half_Adder.ngd
// Output file  : Half_Adder_translate.v
// Design name  : Half_Adder
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module Half_Adder (
  a, b, c, s
);
  input a;
  input b;
  output c;
  output s;
  wire a_IBUF;
  wire b_IBUF;
  wire c_OBUF;
  wire s_OBUF;
  wire \c_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \s_OBUF.GTS.TRI ;
  wire \NlwInverterSignal_c_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_s_OBUF.GTS.TRI/CTL ;
  defparam c1.INIT = 4'h8;
  X_LUT2 c1 (
    .ADR0(a_IBUF),
    .ADR1(b_IBUF),
    .O(c_OBUF)
  );
  defparam Mxor_s_Result1.INIT = 4'h6;
  X_LUT2 Mxor_s_Result1 (
    .ADR0(b_IBUF),
    .ADR1(a_IBUF),
    .O(s_OBUF)
  );
  X_BUF a_IBUF_0 (
    .I(a),
    .O(a_IBUF)
  );
  X_BUF b_IBUF_1 (
    .I(b),
    .O(b_IBUF)
  );
  X_BUF c_OBUF_2 (
    .I(c_OBUF),
    .O(\c_OBUF.GTS.TRI )
  );
  X_BUF s_OBUF_3 (
    .I(s_OBUF),
    .O(\s_OBUF.GTS.TRI )
  );
  X_IPAD a_4 (
    .PAD(a)
  );
  X_IPAD b_5 (
    .PAD(b)
  );
  X_OPAD c_6 (
    .PAD(c)
  );
  X_OPAD s_7 (
    .PAD(s)
  );
  X_TRI \c_OBUF.GTS.TRI_8  (
    .I(\c_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_c_OBUF.GTS.TRI/CTL ),
    .O(c)
  );
  X_TRI \s_OBUF.GTS.TRI_9  (
    .I(\s_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_s_OBUF.GTS.TRI/CTL ),
    .O(s)
  );
  X_INV \NlwInverterBlock_c_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_c_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_s_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_s_OBUF.GTS.TRI/CTL )
  );
endmodule

