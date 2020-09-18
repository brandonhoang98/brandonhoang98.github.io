// Xilinx Verilog netlist produced by netgen application (version G.26)
// Command      : -intstyle ise -s 4 -pcf Half_Adder.pcf -ngm Half_Adder.ngm -w -ofmt verilog -sim Half_Adder_map.ncd Half_Adder_map.v 
// Input file   : Half_Adder_map.ncd
// Output file  : Half_Adder_map.v
// Design name  : Half_Adder
// # of Modules : 1
// Xilinx       : C:/XilinxISE6
// Device       : 3s50pq208-4 (PREVIEW 1.27 2003-11-04)

// This verilog netlist is a simulation model and uses simulation 
// primitives which may not represent the true implementation of the 
// device, however the netlist is functionally correct and should not 
// be modified. This file cannot be synthesized and should only be used 
// with supported simulation tools.

`timescale 1 ns/1 ps

module Half_Adder (
  s, c, b, a
);
  output s;
  output c;
  input b;
  input a;
  wire s_OBUF;
  wire a_IBUF;
  wire b_IBUF;
  wire c_OBUF;
  wire GSR = glbl.GSR;
  wire GTS = glbl.GTS;
  wire \s/ENABLE ;
  wire \s/GTS_OR_T ;
  wire \s/O ;
  wire \a/INBUF ;
  wire \b/INBUF ;
  wire \c/ENABLE ;
  wire \c/GTS_OR_T ;
  wire \c/O ;
  wire \s_OBUF/F ;
  wire \s_OBUF/G ;
  wire VCC;
  initial $sdf_annotate("half_adder_map.sdf");
  X_OPAD \s/PAD  (
    .PAD(s)
  );
  X_TRI s_OBUF_0 (
    .I(\s/O ),
    .CTL(\s/ENABLE ),
    .O(s)
  );
  X_INV \s/ENABLEINV  (
    .I(\s/GTS_OR_T ),
    .O(\s/ENABLE )
  );
  X_BUF \s/GTS_OR_T_1  (
    .I(GTS),
    .O(\s/GTS_OR_T )
  );
  X_IPAD \a/PAD  (
    .PAD(a)
  );
  X_BUF a_IBUF_2 (
    .I(a),
    .O(\a/INBUF )
  );
  X_IPAD \b/PAD  (
    .PAD(b)
  );
  X_BUF b_IBUF_3 (
    .I(b),
    .O(\b/INBUF )
  );
  X_OPAD \c/PAD  (
    .PAD(c)
  );
  X_TRI c_OBUF_4 (
    .I(\c/O ),
    .CTL(\c/ENABLE ),
    .O(c)
  );
  X_INV \c/ENABLEINV  (
    .I(\c/GTS_OR_T ),
    .O(\c/ENABLE )
  );
  X_BUF \c/GTS_OR_T_5  (
    .I(GTS),
    .O(\c/GTS_OR_T )
  );
  X_BUF \s_OBUF/XUSED  (
    .I(\s_OBUF/F ),
    .O(s_OBUF)
  );
  X_BUF \s_OBUF/YUSED  (
    .I(\s_OBUF/G ),
    .O(c_OBUF)
  );
  defparam c1.INIT = 16'h8888;
  X_LUT4 c1 (
    .ADR0(a_IBUF),
    .ADR1(b_IBUF),
    .ADR2(VCC),
    .ADR3(VCC),
    .O(\s_OBUF/G )
  );
  defparam Mxor_s_Result1.INIT = 16'h6666;
  X_LUT4 Mxor_s_Result1 (
    .ADR0(b_IBUF),
    .ADR1(a_IBUF),
    .ADR2(VCC),
    .ADR3(VCC),
    .O(\s_OBUF/F )
  );
  X_BUF \s/OUTPUT/OFF/OMUX  (
    .I(s_OBUF),
    .O(\s/O )
  );
  X_BUF \a/IFF/IMUX  (
    .I(\a/INBUF ),
    .O(a_IBUF)
  );
  X_BUF \b/IFF/IMUX  (
    .I(\b/INBUF ),
    .O(b_IBUF)
  );
  X_BUF \c/OUTPUT/OFF/OMUX  (
    .I(c_OBUF),
    .O(\c/O )
  );
  X_ONE NlwBlock_Half_Adder_VCC (
    .O(VCC)
  );
endmodule

