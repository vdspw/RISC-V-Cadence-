module memory #(
    parameter DWIDTH = 8,
    parameter AWIDTH = 5
) (
    input wire clk,
    input wire [AWIDTH-1:0] addr,
    inout wire [DWIDTH-1:0] data,
    input wire rd,
    input wire wr
);

// Calculate DEPTH from AWIDTH - DEPTH = 2^AWIDTH
localparam DEPTH = 1 << AWIDTH;  // For AWIDTH=5, DEPTH=32

reg [DWIDTH-1:0] mem [0:DEPTH-1];
reg [DWIDTH-1:0] data_out;

// Tristate output control
assign data = (rd && !wr) ? data_out : {DWIDTH{1'bz}};

// Write operation
always @(posedge clk) begin
    if (wr && !rd) begin
        mem[addr] <= data;
    end
end

// Read operation (combinational)
always @(*) begin
    if (rd && !wr) begin
        data_out = mem[addr];
    end else begin
        data_out = {DWIDTH{1'bz}};
    end
end

endmodule
