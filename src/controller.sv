module control(
    destination_register,
    jump,
    branch,
    we_memory,
    memory_to_register,
    ALU_OP,
    ALU_src,
    register_write,
    opcode
);

    input wire [5:0] opcode;

    output reg destination_register;
    output reg jump;
    output reg branch;
    output reg we_memory;
    output reg memory_to_register;
    output reg [1:0] ALU_OP;
    output reg ALU_src;
    output reg register_write;

    //R type
    parameter Rtype_code = 6'b000000;

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


    always @(opcode)
    begin
        case(opcode)
            Rtype_code:
            begin
                destination_register = 1;
                jump = 0;
                branch = 0;
                we_memory = 0;
                ALU_src = 0;
                ALU_OP = 2'b11;
                memory_to_register = 0;
                register_write = 1;
            end
        endcase
    end

endmodule