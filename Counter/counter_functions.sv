module counter #(
    parameter WIDTH = 5
) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire enab,
    input wire [WIDTH-1:0] cnt_in,
    output reg [WIDTH-1:0] cnt_out
);

// Function to calculate next counter value
// This encapsulates the combinational logic
function [WIDTH-1:0] next_count;
    input [WIDTH-1:0] current_count;
    input rst_in;
    input load_in;
    input enab_in;
    input [WIDTH-1:0] data_in;
    begin
        if (rst_in) begin
            next_count = {WIDTH{1'b0}};  // Reset to 0
        end
        else if (load_in) begin
            next_count = data_in;         // Load input value
        end
        else if (enab_in) begin
            next_count = current_count + 1'b1;  // Increment
        end
        else begin
            next_count = current_count;   // Hold current value
        end
    end
endfunction

// Sequential logic - call the function to get next value
always @(posedge clk) begin
    cnt_out <= next_count(cnt_out, rst, load, enab, cnt_in);
end

endmodule
