module controller (
    input [2:0] opcode,
    input [2:0] phase,
    input zero,
    output reg sel,
    output reg rd,
    output reg ld_ir,
    output reg inc_pc,
    output reg halt,
    output reg ld_pc,
    output reg data_e,
    output reg ld_ac,
    output reg wr
);

    // Named constants for opcodes
    localparam [2:0]
        HLT = 3'b000,
        SKZ = 3'b001,
        ADD = 3'b010,
        AND = 3'b011,
        XOR = 3'b100,
        LDA = 3'b101,
        STO = 3'b110,
        JMP = 3'b111;

    // Combinational logic
    always @(*) begin
        // Default all outputs to 0
        sel = 1'b0;
        rd = 1'b0;
        ld_ir = 1'b0;
        inc_pc = 1'b0;
        halt = 1'b0;
        ld_pc = 1'b0;
        data_e = 1'b0;
        ld_ac = 1'b0;
        wr = 1'b0;

        // Decode based on phase
        case (phase)
            3'd0: begin  // INST_ADDR
                sel = 1'b1;
            end
            
            3'd1: begin  // INST_FETCH
                sel = 1'b1;
                rd = 1'b1;
            end
            
            3'd2, 3'd3: begin  // INST_LOAD and IDLE
                sel = 1'b1;
                rd = 1'b1;
                ld_ir = 1'b1;
            end
            
            3'd4: begin  // OP_ADDR
                inc_pc = 1'b1;
                if (opcode == HLT)
                    halt = 1'b1;
            end
            
            3'd5: begin  // OP_FETCH
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA)
                    rd = 1'b1;
            end
            
            3'd6: begin  // ALU_OP
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA)
                    rd = 1'b1;
                else if (opcode == SKZ && zero)
                    inc_pc = 1'b1;
                else if (opcode == JMP)
                    ld_pc = 1'b1;
                else if (opcode == STO)
                    data_e = 1'b1;
            end
            
            3'd7: begin  // STORE
                if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
                    rd = 1'b1;
                    ld_ac = 1'b1;
                end
                else if (opcode == JMP)
                    ld_pc = 1'b1;
                else if (opcode == STO) begin
                    data_e = 1'b1;
                    wr = 1'b1;
                end
            end
        endcase
    end

endmodule
