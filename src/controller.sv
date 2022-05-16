module controller(
    destination_register,
    jump,
    branch,
    we_memory,
    memory_to_register,
    ALU_OP,
    ALU_src,
    register_write,
    opcode,
    func
);

    input wire [5:0] opcode;
    input wire [5:0] func;

    output reg destination_register; // 1 for rd and 0 for rt
    output reg jump;
    output reg branch;
    output reg we_memory;
    output reg memory_to_register;
    output reg [4:0] ALU_OP;
    output reg ALU_src;
    output reg register_write;

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
    parameter SLTI_code = 6'b001010;
    parameter LUI_code = 6'b001111;

    //J type
    parameter J_code = 6'b000010;
    parameter JAL_code = 6'b000011;


    always @(opcode)
    begin
        case (opcode)
            Rtype_code:
            begin
                destination_register = 1;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 0;
                memory_to_register = 0;
                register_write = 1;

                case (func)
                    XOR_func: ALU_OP = 5'b00000;
                    SLL_func: ALU_OP = 5'b00001;
                    SLLV_func: ALU_OP = 5'b00001;
                    SRL_func: ALU_OP = 5'b00010;
                    SRLV_func: ALU_OP = 5'b00010;
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
                    JR_func: ALU_OP = 5'b01100;
                    default: ALU_OP = 5'b00100;
                endcase

            end

            ADDI_code, ADDIU_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                memory_to_register = 0;
                register_write = 1;
            end

            ANDI_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01010;
                memory_to_register = 0;
                register_write = 1;
            end

            XORI_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                memory_to_register = 0;
                register_write = 1;
            end

            ORI_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01000;
                memory_to_register = 0;
                register_write = 1;
            end

            LW_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                memory_to_register = 1;
                register_write = 1;
            end

            SW_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 1;
                ALU_src = 1;
                ALU_OP = 5'b00100;
                memory_to_register = 0;
                register_write = 0;
            end

            BEQ_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 1;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01101;
                memory_to_register = 0;
                register_write = 0;
            end

            BNE_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 1;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01110;
                memory_to_register = 0;
                register_write = 0;
            end

            BLEZ_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 1;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01111;
                memory_to_register = 0;
                register_write = 0;
            end

            BGTZ_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 1;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10000;
                memory_to_register = 0;
                register_write = 0;
            end

            BGEZ_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 1;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10001;
                memory_to_register = 0;
                register_write = 0;
            end

            SLTI_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b01011;
                memory_to_register = 0;
                register_write = 1;
            end

            LUI_code:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b10010;
                memory_to_register = 0;
                register_write = 1;
            end


            default:
            begin
                destination_register = 0;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 1;
                ALU_OP = 5'b00000;
                memory_to_register = 0;
                register_write = 1;
            end
        endcase
    end

endmodule