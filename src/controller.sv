module Controller(
    destination_register,
    jump,
    branch,
    jump_register,
    we_memory,
    register_src,
    ALU_OP,
    ALU_src,
    register_write,
    is_unsigned,
    pc_enable,
    set_valid,
    set_dirty,
    opcode,
    cache_input_type, // 0 for memory, 1 for else
    memory_address_type, // 0 for alu, 1 for cache
    we_cache,
    cache_hit,
    cache_dirty,
    is_word,
    func,
    clk
);

    input wire cache_hit;
    input wire cache_dirty;
    input wire [5:0] opcode;
    input wire [5:0] func;
    input wire clk;

    output reg [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    output reg jump;
    output reg branch;
    output reg jump_register;
    output reg we_memory;
    output reg [1:0] register_src; // 01 for memory and 00 for ALU result and 10 for PC
    output reg [4:0] ALU_OP;
    output reg ALU_src;
    output reg register_write;
    output reg is_unsigned;
    output reg pc_enable;
    output reg we_cache;
    output reg set_valid = 0;
    output reg cache_input_type = 0;
    output reg memory_address_type = 0;
    output reg set_dirty = 0;
    output reg is_word = 1;


    reg [3:0] p_state = S0;
    reg [3:0] n_state;

    parameter S0    = 4'b0000;
    parameter S1    = 4'b0001;
    parameter S2    = 4'b0010;
    parameter S3    = 4'b0011;
    parameter S4    = 4'b0100;
    parameter S5    = 4'b0101;
    parameter S6    = 4'b0110;
    parameter S7    = 4'b0111;
    parameter S8    = 4'b1000;
    parameter S9    = 4'b1001;
    parameter S10   = 4'b1010;
    parameter S11   = 4'b1011;
    parameter S12   = 4'b1100;

    //R type
    parameter Rtype_code = 6'b000000;

    parameter XOR_func = 6'b100110;
    parameter SLL_func = 6'b000000;
    parameter SLLV_func = 6'b000100;
    parameter SRL_func = 6'b000010;
    parameter SUB_func = 6'b100010;
    parameter SRLV_func = 6'b000110;
    parameter SLT_func = 6'b101010;
    parameter SYSCALL_func = 6'b101010;
    parameter SUBU_func = 6'b100011;
    parameter OR_func = 6'b100101;
    parameter NOR_func = 6'b100111;
    parameter ADDU_func = 6'b100001;
    parameter MULT_func = 6'b011000;
    parameter DIV_func = 6'b011010;
    parameter AND_func = 6'b100100;
    parameter ADD_func = 6'b100000;
    parameter JR_func = 6'b001000;
    parameter SRA_func = 6'b000011;

    //I type
    parameter ADDI_code = 6'b001000;
    parameter ADDIU_code = 6'b001001;
    parameter ANDI_code = 6'b001100;
    parameter XORI_code = 6'b001110;
    parameter ORI_code = 6'b001101;
    parameter BEQ_code = 6'b000100;
    parameter BNE_code = 6'b000101;
    parameter BLEZ_code = 6'b000110;
    parameter BGTZ_code = 6'b000111;
    parameter BGEZ_code = 6'b000001;
    parameter LW_code = 6'b100011;
    parameter SW_code = 6'b101011;
    parameter LB_code = 6'b100000;
    parameter SB_code = 6'b101000;
    parameter SLTI_code = 6'b001010;
    parameter LUI_code = 6'b001111;

    //J type
    parameter J_code = 6'b000010;
    parameter JAL_code = 6'b000011;

    // NOP
    parameter NOP_code = 6'b111111;

    always @(posedge clk)
    begin
        p_state = n_state;
    end

    always @(*)
    begin
        case (opcode)
            NOP_code:
            begin
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                destination_register = 2'b00;
                register_src = 0; // 01 for memory and 00 for ALU result and 10 for PC
                ALU_OP = 0;
                ALU_src = 0;
                register_write = 0;
                is_unsigned = 0;
            end
            Rtype_code:
            begin
                destination_register = 2'b01;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 0;

                case (func)
                    XOR_func: ALU_OP = 5'b00000;
                    SLL_func: ALU_OP = 5'b00001;
                    SLLV_func: ALU_OP = 5'b11001;
                    SRL_func: ALU_OP = 5'b00010;
                    SRLV_func: ALU_OP = 5'b11010;
                    SRA_func: ALU_OP = 5'b00011;
                    ADD_func: ALU_OP= 5'b00100;
                    ADDU_func: ALU_OP= 5'b00100;
                    SUB_func: ALU_OP = 5'b00101;
                    SUBU_func: ALU_OP = 5'b00101;
                    MULT_func: ALU_OP = 5'b00110;
                    DIV_func: ALU_OP = 5'b00111;
                    OR_func: ALU_OP = 5'b01000;
                    NOR_func: ALU_OP = 5'b01001;
                    AND_func: ALU_OP = 5'b01010;
                    SLT_func: ALU_OP = 5'b01011;
                    JR_func:
                    begin
                        ALU_OP = 5'b01100;
                        jump_register = 1;
                    end
                    default: ALU_OP = 5'b00100;
                endcase
            end

            ADDI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 0;
            end

            ADDIU_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 1;
            end

            ANDI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01010;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 1;
            end

            XORI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 1;
            end

            ORI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01000;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 1;
            end

            LW_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b01;
                register_write = 1'b0;
                is_unsigned = 0;
            end

            LB_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b01;
                register_write = 1'b0;
                is_unsigned = 0;
            end

            SW_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                register_write = 1'b0;
                is_unsigned = 0;
            end

            SB_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                register_write = 1'b0;
                is_unsigned = 0;
            end

            BEQ_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01101;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            BNE_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01110;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            BLEZ_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01111;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            BGTZ_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10000;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            BGEZ_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10001;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            SLTI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01011;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 0;
            end

            LUI_code:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10010;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 1;
            end

            J_code:
            begin
                destination_register = 2'b00;
                jump = 1;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                register_write = 0;
                is_unsigned = 0;
            end

            JAL_code:
            begin
                destination_register = 2'b10;
                jump = 1;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b00100;
                register_src = 2'b10;
                register_write = 1;
                is_unsigned = 0;
            end

            default:
            begin
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                register_src = 2'b00;
                register_write = 1;
                is_unsigned = 0;
            end
        endcase
    end

    always_latch @(p_state or opcode)
    begin
        we_memory = 1'b0;
        we_cache = 1'b0;
        cache_input_type = 1'b1;
        is_word = (opcode == LW_code) || (opcode == SW_code);

        case (p_state)
            S0: begin
                // start of lw
                if (opcode == LW_code || opcode == LB_code) begin
                    if (cache_hit) begin
                        n_state = S0;
                        register_write = 1'b1;
                        pc_enable = 1'b1;
                    end
                    else begin
                        pc_enable = 1'b0;
                        register_write = 1'b0;
                        if (cache_dirty) begin
                            we_memory = 1'b1;
                            n_state = S6;
                            memory_address_type = 1'b1;
                        end
                        else begin
                            n_state = S1;
                        end
                    end
                end
                // start of sw
                else if (opcode == SW_code || opcode == SB_code) begin
                    if (cache_dirty & ~cache_hit) begin
                        n_state = S1;
                        we_memory = 1'b1;
                        pc_enable = 1'b0;
                        memory_address_type = 1'b1;
                    end
                    else begin
                        we_cache = 1'b1;
                        pc_enable = 1'b1;
                        cache_input_type = 1'b1;
                        set_dirty = 1'b1;
                        set_valid = 1'b1;
                        n_state = S0;
                    end
                end
                else begin
                    n_state = S0;
                    pc_enable = 1'b1;
                end
            end

            S1: begin
                n_state = S2;
                if (opcode == LW_code || opcode == LB_code) begin
                    memory_address_type = 1'b0;
                end
                else if (opcode == SW_code || opcode == SB_code) begin
                    cache_input_type = 1'b0;
                end
            end

            S2: begin
                n_state = S3;
            end

            S3: begin
                n_state = S10;
            end

            S4: begin
                if (opcode == LW_code || opcode == LB_code) begin
                    we_cache = 1'b1;
                    is_word = 1'b1;
                    cache_input_type = 1'b0;
                    set_valid = 1'b1;
                    set_dirty = 1'b0;
                    n_state = S11;
                end
                else if (opcode == SW_code || opcode == SB_code) begin
                    we_cache = 1'b1;
                    n_state = S0;
                    set_valid = 1'b1;
                    set_dirty = 1'b1;
                    pc_enable = 1'b1;
                end
            end

            S5: begin
                if (opcode == LW_code || opcode == LB_code) begin
                    register_write = 1'b1;
                    pc_enable = 1'b1;
                    n_state = S0;
                end
            end

            S6: begin
                n_state = S7;
            end

            S7: begin
                n_state = S8;
            end

            S8: begin
                n_state = S9;
            end

            S9: begin
                n_state = S1;
            end

            S10: begin
                n_state = S4;
            end

            S11: begin
                register_write = 1'b1;
                pc_enable = 1'b1;
                n_state = S0;
            end

            default: n_state = S0;
        endcase
    end

endmodule
