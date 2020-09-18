// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -w -ofmt verilog -sim full_subtractor.ngd full_subtractor_translate.v 
// Input file   : full_subtractor.ngd
// Output file  : full_subtractor_translate.v
// Design name  : full_subtractor
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module full_subtractor (
  a, b, bin, d, bout
);
  input a;
  input b;
  input bin;
  output d;
  output bout;
  wire a_IBUF;
  wire b_IBUF;
  wire d_OBUF;
  wire bout_OBUF;
  wire bin_IBUF;
  wire \d_OBUF.GTS.TRI ;
  wire GTS = glbl.GTS;
  wire \bout_OBUF.GTS.TRI ;
  wire \NlwInverterSignal_d_OBUF.GTS.TRI/CTL ;
  wire \NlwInverterSignal_bout_OBUF.GTS.TRI/CTL ;
  defparam Mxor_d_Result1.INIT = 8'h96;
  X_LUT3 Mxor_d_Result1 (
    .ADR0(b_IBUF),
    .ADR1(a_IBUF),
    .ADR2(bin_IBUF),
    .O(d_OBUF)
  );
  defparam bout1.INIT = 8'h8E;
  X_LUT3 bout1 (
    .ADR0(b_IBUF),
    .ADR1(bin_IBUF),
    .ADR2(a_IBUF),
    .O(bout_OBUF)
  );
  X_BUF a_IBUF_0 (
    .I(a),
    .O(a_IBUF)
  );
  X_BUF b_IBUF_1 (
    .I(b),
    .O(b_IBUF)
  );
  X_BUF bin_IBUF_2 (
    .I(bin),
    .O(bin_IBUF)
  );
  X_BUF d_OBUF_3 (
    .I(d_OBUF),
    .O(\d_OBUF.GTS.TRI )
  );
  X_BUF bout_OBUF_4 (
    .I(bout_OBUF),
    .O(\bout_OBUF.GTS.TRI )
  );
  X_IPAD a_5 (
    .PAD(a)
  );
  X_IPAD b_6 (
    .PAD(b)
  );
  X_IPAD bin_7 (
    .PAD(bin)
  );
  X_OPAD d_8 (
    .PAD(d)
  );
  X_OPAD bout_9 (
    .PAD(bout)
  );
  X_TRI \d_OBUF.GTS.TRI_10  (
    .I(\d_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_d_OBUF.GTS.TRI/CTL ),
    .O(d)
  );
  X_TRI \bout_OBUF.GTS.TRI_11  (
    .I(\bout_OBUF.GTS.TRI ),
    .CTL(\NlwInverterSignal_bout_OBUF.GTS.TRI/CTL ),
    .O(bout)
  );
  X_INV \NlwInverterBlock_d_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_d_OBUF.GTS.TRI/CTL )
  );
  X_INV \NlwInverterBlock_bout_OBUF.GTS.TRI/CTL  (
    .I(GTS),
    .O(\NlwInverterSignal_bout_OBUF.GTS.TRI/CTL )
  );
endmodule

