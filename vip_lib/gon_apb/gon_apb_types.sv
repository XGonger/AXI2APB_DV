`ifndef GON_APB_TYPES_SV
`define GON_APB_TYPES_SV
  
  typedef enum bit[1:0]{
    IDLE = 2'b00,
    BUSY = 2'b01,
    NSEQ = 2'b10,
    SEQ  = 2'b11
  } trans_type_enum;

  typedef enum bit [2:0] {
    BURST_SIZE_8BIT    =  3'b000,
    BURST_SIZE_16BIT   =  3'b001,
    BURST_SIZE_32BIT   =  3'b010,
    BURST_SIZE_64BIT   =  3'b011,
    BURST_SIZE_128BIT  =  3'b100,
    BURST_SIZE_256BIT  =  3'b101,
    BURST_SIZE_512BIT  =  3'b110,
    BURST_SIZE_1024BIT = 3'b111
  } burst_size_enum;
  
  typedef enum bit {
    WRITE = 1'b1,
    READ  = 1'b0
  } xact_type_enum;
  
`endif // GON_APB_TYPES_SV
