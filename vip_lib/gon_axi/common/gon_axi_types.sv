`ifndef GON_AXI_TYPES_SV
`define GON_AXI_TYPES_SV

  typedef enum bit[1:0]{
    FIXED  = 2'b00,
    INCR   = 2'b01,
    WRAP   = 2'b10,
    RESERV = 2'b11
  } burst_type_e;

  typedef enum bit[2:0]{
    BYTE_001 = 3'b000,
    BYTE_002 = 3'b001,
    BYTE_004 = 3'b010,
    BYTE_008 = 3'b011,
    BYTE_016 = 3'b100,
    BYTE_032 = 3'b101,
    BYTE_064 = 3'b110,
    BYTE_128 = 3'b111
  } burst_size_e;

  typedef enum bit[3:0]{
    LENGTH_01 = 4'b0000,
    LENGTH_02 = 4'b0001,
    LENGTH_03 = 4'b0010,
    LENGTH_04 = 4'b0011,
    LENGTH_05 = 4'b0100,
    LENGTH_06 = 4'b0101,
    LENGTH_07 = 4'b0110,
    LENGTH_08 = 4'b0111,
    LENGTH_09 = 4'b1000,
    LENGTH_10 = 4'b1001,
    LENGTH_11 = 4'b1010,
    LENGTH_12 = 4'b1011,
    LENGTH_13 = 4'b1100,
    LENGTH_14 = 4'b1101,
    LENGTH_15 = 4'b1110,
    LENGTH_16 = 4'b1111
  } burst_length_e;

  typedef enum bit{
    WRITE = 1'b1,
    READ  = 1'b0
  } wr_rd_e;
  
  typedef enum bit[1:0]{
    OKEY   = 2'b00,
    EXOKEY = 2'b01,
    SLVERR = 2'b10,
    DECERR = 2'b11
  } resp_e;

`endif
