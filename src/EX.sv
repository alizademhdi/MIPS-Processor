module EX(
    rs_data_in,
    rt_data_in,
    frs_data_ex,
    frt_data_ex,
    division_by_zero,
    QNaN,
    SNaN,
    inexact,
    underflow,
    overflow,
    inst_50,
    inst_2016,
    inst_1511,
    inst_106,
    inst_ex_in,
    destination_register,
    ALU_src,
    ALU_OP,
    register_write_in,
    register_src_in,
    branch_in,
    jump_in,
    jump_register_in,
    jea_in,
    pc_enable_in,
    zero,
    imm_extend_in,
    ALU_result,
    fALU_result,
    rd_num,
    we_cache_in,
    we_memory_in,
    cache_input_type_in,
    set_dirty_in,
    set_valid_in,
    memory_address_type_in,
    is_word_in,
    inst_addr_in,
    is_nop_in,
    halted_controller_in,
    clk
);

    input [31:0] inst_addr_in;
    input [31:0] inst_ex_in;
    input [31:0] rs_data_in;
    input [31:0] rt_data_in;
    input [31:0] frs_data_ex;
    input [31:0] frt_data_ex;
    input [5:0] inst_50;
    input [4:0] inst_2016;
    input [4:0] inst_1511;
    input [4:0] inst_106;
    input [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    input ALU_src;
    input [4:0] ALU_OP;
    input register_write_in;
    input [1:0] register_src_in;
    input branch_in;
    input jump_in;
    input jump_register_in;
    input [25:0] jea_in;
    input pc_enable_in;
    input [31:0] imm_extend_in;
    input we_cache_in;
    input we_memory_in;
    input cache_input_type_in;
    input set_dirty_in;
    input set_valid_in;
    input memory_address_type_in;
    input is_word_in;
    input halted_controller_in;
    input clk;
    input is_nop_in;

    output reg [31:0] ALU_result;
    output reg [31:0] fALU_result;
    output reg [4:0] rd_num;
    output reg zero;
    output division_by_zero;
    output QNaN;
    output SNaN;
    output inexact;
    output underflow;
    output overflow;

    // Create ALU
    reg [31:0] data_in2;

    ALU alu(
        .data_out(ALU_result),
        .zero(zero),
        .ALU_OP(ALU_OP),
        .data_in1(rs_data_in),
        .data_in2(data_in2),
        .shift_amount(inst_106)
    );

    floating_point_ALU f_alu(
        .data_out(fALU_result),
        .division_by_zero(division_by_zero),
        .QNaN(QNaN),
        .SNaN(SNaN),
        .inexact(inexact),
        .underflow(underflow),
        .overflow(overflow),
        .data_in1(frs_data_ex),
        .data_in2(frt_data_ex),
        .ALU_OP(ALU_OP)
    );

    always @(ALU_src)
    begin
        if (ALU_src) begin
            data_in2 = imm_extend_in;
        end else
            data_in2 = rt_data_in;
    end

    always @(inst_1511, inst_2016)
        begin

            case (destination_register)
                2'b00: rd_num = inst_2016;
                2'b01: rd_num = inst_1511;
                2'b10: rd_num = 5'b11111;
                default:
                    rd_num = inst_2016;
            endcase
        end
endmodule

