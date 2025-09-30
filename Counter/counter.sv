module counter #(parameter WIDTH = 5)
  (
  input clk,
  input rst,
  input load,
  input enab,
    input [WIDTH-1:0] cnt_in,
    output reg [WIDTH-1:0] cnt_out
  
);
  
  //internal signal for next state
  reg [WIDTH-1:0] next_val;
  
  always@(*)begin
    if(rst)begin
      next_val = {WIDTH{1'b0}};end
    else if (load) begin
      next_val = cnt_in; end//loading input value
    else if (enab) begin
      next_val = cnt_out + 1; end
    else begin
      next_val = cnt_out;
  	end
  end
      
      always@(posedge clk) begin
       cnt_out<= next_val; 
      end
  
endmodule
  
