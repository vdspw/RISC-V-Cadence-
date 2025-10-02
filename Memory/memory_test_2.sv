// Code your testbench here
// or browse Examples
module memory_test;
  localparam integer AWIDTH = 5;
  localparam integer DWIDTH = 8;
  
  reg               clk;
  reg               wr;
  reg               rd;
  reg  [AWIDTH-1:0] addr;
  wire [DWIDTH-1:0] data;
  reg  [DWIDTH-1:0] rdata;
  
  assign data = rdata;
  
  // Instantiate the memory module
  memory #(
    .AWIDTH(AWIDTH),
    .DWIDTH(DWIDTH)
  ) memory_inst (
    .clk(clk),
    .wr(wr),
    .rd(rd),
    .addr(addr),
    .data(data)
  );
  
  // Task for writing to memory
  task write_mem;
    input [AWIDTH-1:0] write_addr;
    input [DWIDTH-1:0] write_data;
    begin
      $display("Writing addr=%b data=%b", write_addr, write_data);
      wr = 1;
      rd = 0;
      memory_test.addr = write_addr;
      rdata = write_data;
      @(negedge clk);
    end
  endtask
  
  // Task for reading from memory
  task read_mem;
    input [AWIDTH-1:0] read_addr;
    input [DWIDTH-1:0] expected_data;
    begin
      $display("Reading addr=%b data=%b", read_addr, expected_data);
      wr = 0;
      rd = 1;
      memory_test.addr = read_addr;
      rdata = 'bz;
      @(negedge clk);
      expect_1(expected_data);
    end
  endtask
  
  // Task to check expected data
  task expect_1;
    input [DWIDTH-1:0] exp_data;
    begin
      if (data !== exp_data) begin
        $display("TEST FAILED");
        $display("%0d addr=%b, exp_data= %b, data=%b", $time, addr, exp_data, data);
        $finish;
      end else begin
        $display("%0d addr=%b, exp_data= %b, data=%b", $time, addr, exp_data, data);
      end
    end
  endtask
  
  // Clock generation
  initial repeat (67) begin 
    #5 clk = 1; 
    #5 clk = 0; 
  end
  
  // Test sequence
  initial @(negedge clk) begin : TEST
    reg [AWIDTH-1:0] test_addr;
    reg [DWIDTH-1:0] test_data;
    
    // Write and read two specific addresses
    test_addr = 0; 
    test_data = -1;
    write_mem(test_addr, test_data);
    
    test_addr = -1; 
    test_data = 0;
    write_mem(test_addr, test_data);
    
    test_addr = 0; 
    test_data = -1;
    read_mem(test_addr, test_data);
    
    test_addr = -1; 
    test_data = 0;
    read_mem(test_addr, test_data);
    
    // Write ascending data to descending addresses
    $display("Writing ascending data to   descending addresses");
    test_addr = -1; 
    test_data = 0;
    while (test_addr) begin
      write_mem(test_addr, test_data);
      test_addr = test_addr - 1;
      test_data = test_data + 1;
    end
    
    // Read ascending data from descending addresses
    $display("Reading ascending data from descending addresses");
    test_addr = -1; 
    test_data = 0;
    while (test_addr) begin
      read_mem(test_addr, test_data);
      test_addr = test_addr - 1;
      test_data = test_data + 1;
    end
    
    $display("TEST PASSED");
    $finish;
  end
  
endmodule
