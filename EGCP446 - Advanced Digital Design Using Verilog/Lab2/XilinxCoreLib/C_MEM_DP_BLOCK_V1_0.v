// $Id: C_MEM_DP_BLOCK_V1_0.v,v 1.1 2003/05/13 11:03:05 cc Exp $
//
// Dual port block ram behavioral template
//

`define MINCLKCLKTIME 1

module C_MEM_DP_BLOCK_V1_0 (ENA, ENB, WEA, WEB, RSTA, RSTB, CLKA, CLKB, ADDRA, ADDRB, DIA, DIB, DOA, DOB);

  parameter C_ADDRESS_WIDTH_A = 12;
  parameter C_ADDRESS_WIDTH_B = 12;
  parameter C_CLKA_POLARITY   = 1;
  parameter C_CLKB_POLARITY   = 1;
  parameter C_DEFAULT_DATA    = "0";
  parameter C_DEPTH_A         = 4096;
  parameter C_DEPTH_B         = 4096;
  parameter C_ENA_POLARITY    = 1;
  parameter C_ENB_POLARITY    = 1;
  parameter C_GENERATE_MIF    = 0;
  parameter C_HAS_DIA         = 1;
  parameter C_HAS_DIB         = 1;
  parameter C_HAS_DOA         = 1;
  parameter C_HAS_DOB         = 1;
  parameter C_HAS_ENA         = 1;
  parameter C_HAS_ENB         = 1;
  parameter C_HAS_RSTA        = 1;
  parameter C_HAS_RSTB        = 1;
  parameter C_HAS_WEA         = 1;
  parameter C_HAS_WEB         = 1;
  parameter C_MEM_INIT_FILE   = "null.mif";
  parameter C_MEM_INIT_RADIX  = 2;
  parameter C_PIPE_STAGES     = 0;
  parameter C_READ_MIF        = 1;
  parameter C_RSTA_POLARITY   = 1;
  parameter C_RSTB_POLARITY   = 1;
  parameter C_WEA_POLARITY    = 1;
  parameter C_WEB_POLARITY    = 1;
  parameter C_WIDTH_A         = 1;
  parameter C_WIDTH_B         = 1;

  input ENA, ENB, WEA, WEB, RSTA, RSTB, CLKA, CLKB;
  input [C_ADDRESS_WIDTH_A-1 : 0] ADDRA;
  input [C_ADDRESS_WIDTH_B-1 : 0] ADDRB;
  input [C_WIDTH_A-1 : 0] DIA;
  input [C_WIDTH_B-1 : 0] DIB;
  output [C_WIDTH_A-1 : 0] DOA;
  output [C_WIDTH_B-1 : 0] DOB;

  reg ram_data [C_DEPTH_A*C_WIDTH_A-1 : 0]; // Giant array of bits
  // temp reg file to get data from file...
  reg [C_WIDTH_A-1 : 0] ram_temp [0 : C_DEPTH_A-1];
  reg [C_WIDTH_A-1 : 0] default_data;
  reg [C_WIDTH_A-1 : 0] data_a;
  reg [C_WIDTH_B-1 : 0] data_b;
  reg [C_WIDTH_A-1 : 0] bitval;
  reg [C_WIDTH_A-1 : 0] doa_int;
  reg [C_WIDTH_B-1 : 0] dob_int;
  reg [C_WIDTH_A-1 : 0] pipelinea [0 : C_PIPE_STAGES];
  reg [C_WIDTH_B-1 : 0] pipelineb [0 : C_PIPE_STAGES];
  reg                   lastcka;
  reg                   lastckb;

  wire [C_WIDTH_A-1 : 0] DOA = doa_int;
  wire [C_WIDTH_B-1 : 0] DOB = dob_int;
  wire wea_int;
  wire [C_WIDTH_A-1 : 0] dia_int;
  wire ena_int;
  wire rsta_int;
  wire clka_int;
  wire web_int;
  wire [C_WIDTH_B-1 : 0] dib_int;
  wire enb_int;
  wire rstb_int;
  wire clkb_int;
  wire generate_mif = 0;

  assign wea_int  = defval( defval( WEA, C_WEA_POLARITY, ~WEA ), C_HAS_WEA, 0);
  assign dia_int  = (C_HAS_DIA === 1)?DIA:'b0;
  assign ena_int  = defval( defval( ENA, C_ENA_POLARITY, ~ENA ), C_HAS_ENA, 1);
  assign rsta_int = defval( defval( RSTA, C_RSTA_POLARITY, ~RSTA ), C_HAS_RSTA, 0);
  assign clka_int = defval( CLKA, C_CLKA_POLARITY, ~CLKA);
  assign web_int  = defval( defval( WEB, C_WEB_POLARITY, ~WEB ), C_HAS_WEB, 0);
  assign dib_int  = (C_HAS_DIB === 1)?DIB:'b0;
  assign enb_int  = defval( defval( ENB, C_ENB_POLARITY, ~ENB ), C_HAS_ENB, 1);
  assign rstb_int = defval( defval( RSTB, C_RSTB_POLARITY, ~RSTB ), C_HAS_RSTB, 0);
  assign clkb_int = defval( CLKB, C_CLKB_POLARITY, ~CLKB);

  integer Aabs, Babs, i, j, overlap, incr;
  time clkatime;
  time clkbtime;
  time clktoclktime;
  event checkconflicts;


  function integer ADDR_A_IS_X;
    input [C_ADDRESS_WIDTH_A-1 : 0] value;
    integer i;
  begin
    ADDR_A_IS_X = 0;
    for(i = 0; i < C_ADDRESS_WIDTH_A; i = i + 1)
      if(value[i] === 1'bX)
        ADDR_A_IS_X = 1;
  end
  endfunction

  function integer ADDR_B_IS_X;
    input [C_ADDRESS_WIDTH_B-1 : 0] value;
    integer i;
  begin
    ADDR_B_IS_X = 0;
    for(i = 0; i < C_ADDRESS_WIDTH_B; i = i + 1)
      if(value[i] === 1'bX)
        ADDR_B_IS_X = 1;
  end
  endfunction
 
  function defval;
    input i;
    input hassig;
    input val;
  begin
    if(hassig == 1)
      defval = i;
    else
      defval = val;
    end
  endfunction
	
  always @(negedge clka_int)
  begin
  
    if (generate_mif == 1)
      write_meminit_file;
    lastcka = clka_int;
  end

  always @(posedge clka_int)
  begin : RandWa
    // Capture the time
    clkatime = $time;
    clktoclktime = clkatime - clkbtime;
    // Calculate Absolute addresses (in bits)
    Aabs = 0;
    incr = 1;
    for(i = 0; i < C_ADDRESS_WIDTH_A; i=i+1)
    begin
      if(ADDRA[i] === 1)
        Aabs = Aabs + incr;
      incr = incr * 2;
    end
    Aabs = Aabs * C_WIDTH_A;

    Babs = 0;
    incr = 1;
    for(i = 0; i < C_ADDRESS_WIDTH_B; i=i+1)
    begin
      if(ADDRB[i] === 1)
        Babs = Babs + incr;
      incr = incr * 2;
    end
    Babs = Babs * C_WIDTH_B;


    if(clka_int === 1'bX || (clka_int === 1 && lastcka === 1'bX))
    begin
      if(ADDR_A_IS_X(ADDRA) || ADDRA < C_DEPTH_A )
      begin
        if(ena_int === 1 || ena_int === 1'bX)
        begin
          for(i = 0; i < C_WIDTH_A; i = i + 1)
          begin
            data_a[i] = 1'bX;
            // For Pipelined Block RAM - Pipeline registers are all
            // compromised.
            for(j = 0; j <= C_PIPE_STAGES; j = j + 1)
              pipelinea[j] = 1'bX;
          end
          // When their position is unknown, or upstream
          // prior to the RAM primitives the whole
          // RAM is assumed compromised.
          if(C_PIPE_STAGES > 0 && (C_HAS_WEA==1 || C_HAS_DIA==1))
          begin
            for(i = 0; i < C_DEPTH_A*C_WIDTH_A; i = i + 1)
              ram_data[i] = 1'bX;
          end
          else if(wea_int === 1 || wea_int === 1'bX) // MAY be writing data
          begin
            if(ADDR_A_IS_X(ADDRA))
              // Entire RAM is set to X's
              for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                ram_data[i] = 1'bX;
            else // Don't know if data is written
              for(i = 0; i < C_WIDTH_A; i = i + 1)
                ram_data[Aabs+i] = 1'bX;
          end
        end 
      end
      else
      begin
        if((ena_int === 1 || ena_int === 1'bX) &&
           (rsta_int === 1 || rsta_int === 1'bX ))
        begin
          for(i = 0; i < C_WIDTH_A; i = i + 1)
            data_a[i] = 1'bX;
        end
      end
    end
    else
    begin
      if(ADDR_A_IS_X(ADDRA) || ADDRA < C_DEPTH_A)
      begin
        if(ena_int === 1)
        begin : defRandWa
          for(i = C_PIPE_STAGES; i > 0; i = i - 1)
            pipelinea[i] = pipelinea[i-1];
          if(rsta_int === 1)   // Sync reset
          begin
            for(i = 0; i < C_WIDTH_A; i = i + 1)
              data_a[i] = 1'b0;

            if(wea_int === 1)
            begin
              if(ADDR_A_IS_X(ADDRA))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Place data into RAM
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = dia_int[i];
            end
            else if(wea_int === 1'bX) // MAY be writing data
            begin
              if(ADDR_A_IS_X(ADDRA))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = 1'bX;
            end

          end
          else if(rsta_int === 0)
          begin
            if(wea_int === 1)
            begin
              if(ADDR_A_IS_X(ADDRA))
              begin
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  data_a[i] = 1'bX;
              end
              else // Place data into RAM
              begin
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = dia_int[i];
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  data_a[i] = dia_int[i];
              end
            end
            else if(wea_int === 1'bX) // MAY be writing data
            begin
              for(i = 0; i < C_WIDTH_A; i = i + 1)
                data_a[i] = 1'bX;
              if(ADDR_A_IS_X(ADDRA))
              begin
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              end
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = 1'bX;
            end
            else // wea_int === 0
            begin
              if(ADDR_A_IS_X(ADDRA))
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  data_a[i] = 1'bX;
              else
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  data_a[i] = ram_data[Aabs+i];
            end
          end
          else //rsta_int === X
          begin
            for(i = 0; i < C_WIDTH_A; i = i + 1)
              data_a[i] = 1'bX;

            if(wea_int === 1)
            begin
              if(ADDR_A_IS_X(ADDRA))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Place data into RAM
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = dia_int[i];
            end
            else if(wea_int === 1'bX) // MAY be writing data
            begin
              if(ADDR_A_IS_X(ADDRA))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_A; i = i + 1)
                  ram_data[Aabs+i] = 'bX;
            end

          end

        end // defRandWa
        else if(ena_int === 1'bX)
        begin
          for(i = 0; i < C_WIDTH_A; i = i + 1)
          begin
            data_a[i] = 1'bX;
            // For Pipelined Block RAM - Pipeline registers are all
            // compromised.
            for(j = 0; j <= C_PIPE_STAGES; j = j + 1)
              pipelinea[j] = 1'bX;
          end
          // When their position is unknown, or upstream
          // prior to the RAM primitives the whole
          // RAM is assumed compromised.
          if(C_PIPE_STAGES > 0 && (C_HAS_WEA==1 || C_HAS_DIA==1))
          begin
            for(i = 0; i < C_DEPTH_A*C_WIDTH_A; i = i + 1)
              ram_data[i] = 1'bX;
          end
          else if(wea_int === 1 || wea_int === 1'bX) // MAY be writing data
          begin
            if(ADDR_A_IS_X(ADDRA))
              // Entire RAM is set to X's
              for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                ram_data[i] = 1'bX;
            else // Don't know if data is written
              for(i = 0; i < C_WIDTH_A; i = i + 1)
                ram_data[Aabs+i] = 'bX;
          end
        end
      end
      else
      begin
        if((ena_int === 1 || ena_int === 1'bX) &&
           (rsta_int === 1 || rsta_int === 1'bX))
        begin
          if(ena_int === 1'bX || rsta_int === 1'bX)
            for(i = 0; i < C_WIDTH_A; i = i + 1)
              data_a[i] = 1'bX;
          else
            for(i = 0; i < C_WIDTH_A; i = i + 1)
              data_a[i] = 1'b0;
        end
      end
      // Now check for bus conflicts
      ->checkconflicts;
    end
    pipelinea[0] = data_a;
    lastcka = clka_int;
    doa_int <= pipelinea[C_PIPE_STAGES];
  end // RandWa

  always @(negedge clkb_int)
  begin
  
    if (generate_mif == 1)
      write_meminit_file;
    lastckb = clkb_int;
  end

  always @(posedge clkb_int)
  begin : RandWb
    // capture the time
    clkbtime = $time;
    clktoclktime = clkbtime - clkatime;
    // Calculate Absolute addresses (in bits)
    Aabs = 0;
    incr = 1;
    for(i = 0; i < C_ADDRESS_WIDTH_A; i=i+1)
    begin
      if(ADDRA[i] === 1)
        Aabs = Aabs + incr;
      incr = incr * 2;
    end
    Aabs = Aabs * C_WIDTH_A;

    Babs = 0;
    incr = 1;
    for(i = 0; i < C_ADDRESS_WIDTH_B; i=i+1)
    begin
      if(ADDRB[i] === 1)
        Babs = Babs + incr;
      incr = incr * 2;
    end
    Babs = Babs * C_WIDTH_B;

    if(clkb_int === 1'bX || (clkb_int === 1 && lastckb === 1'bX))
    begin
      if(ADDR_B_IS_X(ADDRB) || ADDRB < C_DEPTH_B )
      begin
        if(enb_int === 1 || enb_int === 1'bX)
        begin
          for(i = 0; i < C_WIDTH_B; i = i + 1)
          begin
            data_b[i] = 1'bX;
            // For Pipelined Block RAM - Pipeline registers are all
            // compromised.
            for(j = 0; j <= C_PIPE_STAGES; j = j + 1)
              pipelineb[j] = 1'bX;
          end
          // When their position is unknown, or upstream
          // prior to the RAM primitives the whole
          // RAM is assumed compromised.
          if(C_PIPE_STAGES > 0 && (C_HAS_WEB==1 || C_HAS_DIB==1))
          begin
            for(i = 0; i < C_DEPTH_A*C_WIDTH_A; i = i + 1)
              ram_data[i] = 1'bX;
          end
          else if(web_int === 1 || web_int === 1'bX) // MAY be writing data
          begin
            if(ADDR_B_IS_X(ADDRB))
              // Entire RAM is set to X's
              for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                ram_data[i] = 1'bX;
            else // Don't know if data is written
              for(i = 0; i < C_WIDTH_B; i = i + 1)
                ram_data[Babs+i] = 1'bX;
          end
        end
      end
      else
      begin
        if((enb_int === 1 || enb_int === 1'bX) &&
           (rstb_int === 1 || rstb_int === 1'bX ))
        begin
          for(i = 0; i < C_WIDTH_B; i = i + 1)
            data_b[i] = 1'bX;
        end
      end
    end
    else
    begin
      if(ADDR_B_IS_X(ADDRB) || ADDRB < C_DEPTH_B )
      begin
        if(enb_int === 1)
        begin : defRandWb
          for(i = C_PIPE_STAGES; i > 0; i = i - 1)
            pipelineb[i] = pipelineb[i-1];
          if(rstb_int === 1)   // Sync reset
          begin
            for(i = 0; i < C_WIDTH_B; i = i + 1)
              data_b[i] = 1'b0;

            if(web_int === 1)
            begin
              if(ADDR_B_IS_X(ADDRB))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Place data into RAM
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = dib_int[i];
            end
            else if(web_int === 1'bX) // MAY be writing data
            begin
              if(ADDR_B_IS_X(ADDRB))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = 1'bX;
            end
  
          end
          else if(rstb_int === 0)
          begin
            if(web_int === 1)
            begin
              if(ADDR_B_IS_X(ADDRB))
              begin
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  data_b[i] = 1'bX;
              end
              else // Place data into RAM
              begin
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = dib_int[i];
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  data_b[i] = dib_int[i];
              end
            end
            else if(web_int === 1'bX) // MAY be writing data
            begin
              for(i = 0; i < C_WIDTH_B; i = i + 1)
                data_b[i] = 1'bX;
              if(ADDR_B_IS_X(ADDRB))
              begin
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 1'bX;
              end
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = 1'bX;
            end
            else // web_int === 0
            begin
              if(ADDR_B_IS_X(ADDRB))
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  data_b[i] = 1'bX;
              else
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  data_b[i] = ram_data[Babs+i];
            end
          end
          else //rstb_int === X
          begin
            for(i = 0; i < C_WIDTH_B; i = i + 1)
              data_b[i] = 1'bX;

            if(web_int === 1)
            begin
              if(ADDR_B_IS_X(ADDRB))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 'bX;
              else // Place data into RAM
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = dib_int[i];
            end
            else if(web_int === 1'bX) // MAY be writing data
            begin
              if(ADDR_B_IS_X(ADDRB))
                // Entire RAM is set to X's
                for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                  ram_data[i] = 'bX;
              else // Don't know if data is written
                for(i = 0; i < C_WIDTH_B; i = i + 1)
                  ram_data[Babs+i] = 'bX;
            end
  
          end
  
        end // defRandWb
        else if(enb_int === 1'bX)
        begin
          for(i = 0; i < C_WIDTH_B; i = i + 1)
          begin
            data_b[i] = 1'bX;
            // For Pipelined Block RAM - Pipeline registers are all
            // compromised.
            for(j = 0; j <= C_PIPE_STAGES; j = j + 1)
              pipelineb[j] = 1'bX;
          end
          // When their position is unknown, or
          // prior to the RAM primitives the whole
          // RAM is assumed compromised.
          if(C_PIPE_STAGES > 0 && (C_HAS_WEB==1 || C_HAS_DIB==1))
          begin
            for(i = 0; i < C_DEPTH_A*C_DEPTH_A; i = i + 1)
              ram_data[i] = 1'bX;
          end
          else if(web_int === 1 || web_int === 1'bX)
          begin
            if(ADDR_B_IS_X(ADDRB))
              // Entire RAM is set to X's
              for(i = 0; i < C_WIDTH_A*C_DEPTH_A; i = i + 1)
                ram_data[i] = 1'bX;
            else // Don't know if data is written
              for(i = 0; i < C_WIDTH_B; i = i + 1)
                ram_data[Babs+i] = 'bX;
          end
        end
      end
      else
      begin
        if((enb_int === 1 || enb_int === 1'bX) &&
           (rstb_int === 1 || rstb_int === 1'bX))
        begin
          if(enb_int === 1'bX || rstb_int === 1'bX)
            for(i = 0; i < C_WIDTH_B; i = i + 1)
              data_b[i] = 1'bX;
          else
            for(i = 0; i < C_WIDTH_B; i = i + 1)
              data_b[i] = 1'b0;
        end
      end
      // Now check for bus conflicts
      ->checkconflicts;
    end
    pipelineb[0] = data_b;
    lastckb = clkb_int;
    dob_int <= pipelineb[C_PIPE_STAGES];
  end //RandWb


  // Now check for conflicts on addresses
  always @checkconflicts
  begin
    if(ena_int === 1 && enb_int === 1 && wea_int === 1 && web_int === 1)
    // Two writes to the same address?
    begin
      overlap = -1;
      if(Aabs >= Babs && Aabs < Babs+C_WIDTH_B)
        overlap = Aabs - Babs;
      if(overlap >= 0 && clktoclktime < `MINCLKCLKTIME)
      begin
        for(i = 0; i < C_WIDTH_A; i=i+1)
        begin
          ram_data[Aabs+i] = 1'bX;
        end
        for(i = overlap; i < overlap+C_WIDTH_A; i=i+1)
        begin
          if(~rstb_int)
            data_b[i] = 1'bX;
        end
        for(i = 0; i < C_WIDTH_A; i=i+1)
        begin
          if(~rsta_int)
            data_a[i] = 1'bX;
        end
      end
    end
    else if(ena_int === 1 && enb_int === 1 && wea_int === 1 && web_int === 0)
    // Write on A and read on B - The write will occur ok, but the read data will be (partially) invalid perhaps
    begin
      overlap = -1;
      if(Aabs >= Babs && Aabs < Babs+C_WIDTH_B)
        overlap = Aabs - Babs;
      if(overlap >= 0 && clktoclktime < `MINCLKCLKTIME)
      begin
        // This is WRONG !!!!!!! Only the overlapped part will be X
        //for(i = 0; i < C_WIDTH_a; i=i+1)
        for(i = overlap; i < overlap+C_WIDTH_A; i=i+1)
        begin
          if(~rstb_int)
            data_b[i] = 1'bX;
        end
      end
    end
    else if(ena_int === 1 && enb_int === 1 && wea_int === 0 && web_int === 1)
    // Write on B and read on A - The write will occur ok, but the read data will be (partially) invalid perhaps
    begin
      overlap = -1;
      if(Aabs >= Babs && Aabs < Babs+C_WIDTH_B)
        overlap = Aabs - Babs;
      if(overlap >= 0 && clktoclktime < `MINCLKCLKTIME)
      begin
        for(i = 0; i < C_WIDTH_A; i=i+1)
        begin
          if(~rsta_int)
            data_a[i] = 1'bX;
        end
      end
    end

  end

  initial
  begin
    if(C_HAS_WEA != C_HAS_DIA)
    begin
      $display("Memory must have both WEA and DIA or neither");
      $finish;
    end
    if(C_HAS_WEB != C_HAS_DIB)
    begin
      $display("Memory must have both WEB and DIB or neither");
      $finish;
    end

    clkatime = 0;
    clkbtime = 0;
    clktoclktime = 0;

    default_data = 'b0;
    case (C_MEM_INIT_RADIX)
       2 : default_data = binstr_conv(C_DEFAULT_DATA);
      10 : default_data = decstr_conv(C_DEFAULT_DATA);
      16 : default_data = hexstr_conv(C_DEFAULT_DATA);
      default : $display("ERROR : BAD DATA RADIX");
    endcase

    for(i = 0; i < C_DEPTH_A; i = i + 1)
      ram_temp[i] = default_data;

    if(C_READ_MIF == 1)
    begin
      $readmemb(C_MEM_INIT_FILE, ram_temp);
    end

    for(i = 0; i < C_DEPTH_A; i = i + 1)
      for(j = 0; j < C_WIDTH_A; j = j + 1)
      begin
        bitval = (1'b1 << j);
        ram_data[(i*C_WIDTH_A) + j] = (ram_temp[i] & bitval) >> j;
      end

    for(i = 0; i < C_WIDTH_A; i = i + 1)
      data_a[i] = 1'b0;

    for(i = 0; i < C_WIDTH_B; i = i + 1)
      data_b[i] = 1'b0;
  end

  function [C_WIDTH_A-1:0] decstr_conv;
    input [(8*C_WIDTH_A)-1:0] def_data;

    reg [3:0] bin,ten;
    reg [C_WIDTH_A-1:0] mult, mult10;
    integer i;

    begin

      decstr_conv = 'b0;
      ten = 4'b1010;
      mult10 = 'b1;

      for( i=C_WIDTH_A-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          default :
          begin
            $display("ERROR : NOT A DECIMAL CHARACTER");
            bin = 4'bX;
          end
        endcase
        mult = mult10*bin;
        decstr_conv = decstr_conv + mult;
        mult10 = mult10*ten;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [C_WIDTH_A-1:0] binstr_conv;
    input [(8*C_WIDTH_A)-1:0] def_data;

    integer index,i;

    begin
      index = 0;
      binstr_conv = 'b0;

      for( i=C_WIDTH_A-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 : i = -1;
          8'b00110000 : binstr_conv[index] = 1'b0;
          8'b00110001 : binstr_conv[index] = 1'b1;
          default :
          begin
            $display("ERROR : NOT A BINARY CHARACTER");
            binstr_conv[index] = 1'bX;
          end
        endcase
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  function [C_WIDTH_A-1:0] hexstr_conv;
    input [(8*C_WIDTH_A)-1:0] def_data;

    integer index,i,j;
    reg [3:0] bin;

    begin
      index = 0;
      hexstr_conv = 'b0;
      for( i=C_WIDTH_A-1; i>=0; i=i-1 )
      begin
        case (def_data[7:0])
          8'b00000000 :
          begin
            bin = 4'b0000;
            i = -1;
          end
          8'b00110000 : bin = 4'b0000;
          8'b00110001 : bin = 4'b0001;
          8'b00110010 : bin = 4'b0010;
          8'b00110011 : bin = 4'b0011;
          8'b00110100 : bin = 4'b0100;
          8'b00110101 : bin = 4'b0101;
          8'b00110110 : bin = 4'b0110;
          8'b00110111 : bin = 4'b0111;
          8'b00111000 : bin = 4'b1000;
          8'b00111001 : bin = 4'b1001;
          8'b01000001 : bin = 4'b1010;
          8'b01000010 : bin = 4'b1011;
          8'b01000011 : bin = 4'b1100;
          8'b01000100 : bin = 4'b1101;
          8'b01000101 : bin = 4'b1110;
          8'b01000110 : bin = 4'b1111;
          8'b01100001 : bin = 4'b1010;
          8'b01100010 : bin = 4'b1011;
          8'b01100011 : bin = 4'b1100;
          8'b01100100 : bin = 4'b1101;
          8'b01100101 : bin = 4'b1110;
          8'b01100110 : bin = 4'b1111;
          default :
          begin
            $display("ERROR : NOT A HEX CHARACTER");
            bin = 4'bx;
          end
        endcase
        for( j=0; j<4; j=j+1)
        begin
          if ((index*4)+j < C_WIDTH_A)
          begin
            hexstr_conv[(index*4)+j] = bin[j];
          end
        end
        index = index + 1;
        def_data = def_data >> 8;
      end
    end
  endfunction

  task write_meminit_file;
  
    integer addrs, outfile, bit;
    
    reg [C_WIDTH_A-1 : 0] conts;
    reg anyX;
    
    begin
      outfile = $fopen(C_MEM_INIT_FILE);
      for( addrs = 0; addrs < C_DEPTH_A; addrs=addrs+1)
      begin
        anyX = 1'b0;
        for(bit = 0; bit < C_WIDTH_A; bit=bit+1)
        begin
          if(ram_data[(addrs*C_WIDTH_A)+bit] === 1'bX) anyX = 1'b1;
          conts[bit] = ram_data[(addrs*C_WIDTH_A)+bit];
        end
        if(anyX == 1'b1)  
          $display("ERROR : MEMORY CONTAINS UNKNOWNS");
        $fdisplay(outfile,"%b",conts);
      end
      $fclose(outfile);
    end
  endtask
  
endmodule
