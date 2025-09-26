// Address multiplexer-- RISC-V

module multiplexor #(parameter WIDTH = 5
)  (

  input [WIDTH-1:0] in0,
  input [WIDTH-1:0] in1,
  output[WIDTH-1:0] mux_out,
  input sel
);
  reg [WIDTH-1:0] mux_out_reg;
  
  always@(*) begin
    if(sel)
       mux_out_reg = in1;
    else
       mux_out_reg = in0;
  end
  
  assign mux_out = mux_out_reg;
  
endmodule
