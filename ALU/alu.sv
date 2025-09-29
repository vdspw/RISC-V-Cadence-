module alu #(parameter WIDTH = 8)
  ( 
    input [WIDTH-1:0] in_a,
    input [WIDTH-1:0] in_b,
    input [2:0] opcode,
    output reg[WIDTH-1:0] alu_out,
    output reg  a_is_zero
  );
  
  localparam[2:0]
  HLT = 3'b000,
  SKZ = 3'b001,
  ADD = 3'b010,
  AND = 3'b011,
  XOR = 3'b100,
  LDA = 3'b101,
  STO = 3'b110,
  JMP = 3'b111;
  
  always @(*) begin
    alu_out = {WIDTH{1'b0}};
    a_is_zero = 1'b0;
    
  case(opcode)
     HLT :  alu_out = in_a;
     SKZ :  alu_out = in_a;
     ADD :  alu_out = in_a + in_b;
     AND :  alu_out = in_a & in_b;
     XOR :  alu_out = in_a ^ in_b;
     LDA :  alu_out = in_b;
     STO :  alu_out = in_a;
     JMP :  alu_out = in_a;
    default : alu_out = 8'b0;
  
    endcase
    if(in_a == 8'b0)
      a_is_zero = 1'b1;
    else
      a_is_zero = 1'b0;
    
  end
endmodule
