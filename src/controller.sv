module Controller(
    destination_register,
    jump,
    branch,
    jump_register,
    we_memory,
    register_src,
    fregister_src,
    ALU_OP,
    ALU_src,
    register_write,
    fregister_write,
    is_unsigned,
    pc_enable,
    set_valid,
    set_dirty,
    opcode,
    cache_input_type, // 0 for memory, 1 for else
    memory_address_type, // 0 for alu, 1 for cache
    we_cache,
    is_word,
    is_nop,
    func,
    clk
);

    input wire [5:0] opcode;
    input wire [5:0] func;
    input wire clk;

    output reg [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    output reg jump;
    output reg branch;
    output reg jump_register;
    output reg we_memory;
    output reg [1:0] register_src; // 01 for memory and 00 for ALU result and 10 for PC
    output reg [1:0] fregister_src; // 01 for memory and 00 for ALU result and 10 for PC
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
    output reg is_nop = 0;
    output reg fregister_write;


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
    parameter ADDs_func = 6'b010011;
    parameter SUBs_func = 6'b010100;
    parameter MULs_func = 6'b010101;
    parameter DIVs_func = 6'b010110;
    parameter INVRSs_func = 6'b010111;
    parameter ROUNDs_func = 6'b011100;

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

    // Coproccesor
    parameter MTC_code = 6'b110000;
    parameter MFC_code = 6'b110001;

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
                fregister_src = 2'b00;
                ALU_OP = 0;
                ALU_src = 0;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
                is_nop = 1;
            end
            Rtype_code:
            begin
                is_nop = 0;
                destination_register = 2'b01;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                register_src = 2'b00;
                fregister_src = 2'b00;
                is_unsigned = 0;

                case (func)
                    XOR_func:
                    begin
                        ALU_OP = 5'b00000;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SLL_func: begin
                        ALU_OP = 5'b00001;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SLLV_func: begin
                        ALU_OP = 5'b11001;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SRL_func: begin
                        ALU_OP = 5'b00010;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SRLV_func: begin
                        ALU_OP = 5'b11010;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SRA_func: begin
                         ALU_OP = 5'b00011;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    ADD_func: begin
                         ALU_OP= 5'b00100;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    ADDU_func: begin
                        ALU_OP= 5'b00100;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SUB_func: begin
                        ALU_OP = 5'b00101;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SUBU_func: begin
                        ALU_OP = 5'b00101;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    MULT_func: begin
                        ALU_OP = 5'b00110;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    DIV_func: begin
                        ALU_OP = 5'b00111;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    OR_func: begin
                        ALU_OP = 5'b01000;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    NOR_func: begin
                        ALU_OP = 5'b01001;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    AND_func: begin
                        ALU_OP = 5'b01010;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    SLT_func: begin
                        ALU_OP = 5'b01011;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    ADDs_func:
                    begin
                        ALU_OP = 5'b10011;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    SUBs_func:
                    begin
                        ALU_OP = 5'b10100;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    MULs_func:
                    begin
                        ALU_OP = 5'b10101;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    DIVs_func:
                    begin
                        ALU_OP = 5'b10110;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    INVRSs_func:
                    begin
                        ALU_OP = 5'b10111;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    ROUNDs_func:
                    begin
                        ALU_OP = 5'b11000;
                        register_write = 0;
                        fregister_write = 1;
                    end
                    JR_func:
                    begin
                        ALU_OP = 5'b01100;
                        jump_register = 1;
                        register_write = 1;
                        fregister_write = 0;
                    end
                    default: begin
                        ALU_OP = 5'b00100;
                        register_write = 1;
                        fregister_write = 0;
                    end
                endcase
            end

            MTC_code:
            begin
                is_nop = 0;
                destination_register = 2'b01;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b00000;
                register_src = 2'b11;
                fregister_src = 2'b01;
                register_write = 0;
                fregister_write = 1;
                is_unsigned = 0;
            end

            MFC_code:
            begin
                is_nop = 0;
                destination_register = 2'b01;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b11001;
                register_src = 2'b11;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 0;
            end

            ADDI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 0;
            end

            ADDIU_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 1;
            end

            ANDI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01010;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 1;
            end

            XORI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 1;
            end

            ORI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01000;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 1;
            end

            LW_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b01;
                fregister_src = 2'b00;
                register_write = 1'b0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            LB_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b01;
                fregister_src = 2'b00;
                register_write = 1'b0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            SW_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1'b0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            SB_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1'b0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            BEQ_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01101;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            BNE_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01110;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            BLEZ_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01111;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            BGTZ_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10000;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            BGEZ_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 1;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10001;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            SLTI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01011;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 0;
            end

            LUI_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10010;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 1;
            end

            J_code:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 1;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b00100;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 0;
                fregister_write = 0;
                is_unsigned = 0;
            end

            JAL_code:
            begin
                is_nop = 0;
                destination_register = 2'b10;
                jump = 1;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 5'b00100;
                register_src = 2'b10;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 0;
            end

            default:
            begin
                is_nop = 0;
                destination_register = 2'b00;
                jump = 0;
                branch = 0;
                jump_register = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                register_src = 2'b00;
                fregister_src = 2'b00;
                register_write = 1;
                fregister_write = 0;
                is_unsigned = 0;
            end
        endcase
    end

endmodule
