module EX(
    rs_data_in,
    rs_data_out,
    rt_data_in,
    rt_data_out,
    inst_50,
    inst_2016,
    inst_1511,
    inst_106,
    destination_register,
    ALU_src,
    ALU_OP,
    register_write_in,
    register_write_out,
    register_src_in,
    register_src_out,
    branch_in,
    branch_out,
    jump_in,
    jump_out,
    jump_register_in,
    jump_register_out,
    jea_in,
    jea_out,
    pc_enable_in,
    pc_enable_out,
    zero,
    imm_extend_in,
    imm_extend_out,
    ALU_result,
    rd_num,
    we_cache_in,
    we_cache_out,
    we_memory_in,
    we_memory_out,
    cache_input_type_in,
    cache_input_type_out,
    set_dirty_in,
    set_dirty_out,
    set_valid_in,
    set_valid_out,
    memory_address_type_in,
    memory_address_type_out,
    is_word_in,
    is_word_out,
    inst_addr_in,
    inst_addr_out,
    halted_controller_in,
    halted_controller_out,
    clk
);

    input [31:0] inst_addr_in;
    input [31:0] rs_data_in;
    input [31:0] rt_data_in;
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

    output [31:0] rs_data_out;
    output [31:0] inst_addr_out;
    output register_write_out;
    output [1:0] register_src_out;
    output reg [31:0] ALU_result;
    output [31:0] rt_data_out;
    output reg [4:0] rd_num;
    output [31:0] imm_extend_out;
    output branch_out;
    output jump_out;
    output jump_register_out;
    output [25:0] jea_out;
    output pc_enable_out;
    output reg zero;
    output we_cache_out;
    output we_memory_out;
    output cache_input_type_out;
    output set_dirty_out;
    output set_valid_out;
    output memory_address_type_out;
    output halted_controller_out;
    output is_word_out;

    assign rs_data_out = rs_data_in;
    assign register_write_out = register_write_in;
    assign register_src_out = register_src_in;
    assign rt_data_out = rt_data_in;
    assign imm_extend_out = imm_extend_in;
    assign branch_out = branch_in;
    assign jump_out = jump_in;
    assign jump_register_out = jump_register_in;
    assign jea_out = jea_in;
    assign pc_enable_out = pc_enable_in;
    assign we_cache_out = we_cache_in;
    assign we_memory_out = we_memory_in;
    assign cache_input_type_out = cache_input_type_in;
    assign set_dirty_out = set_dirty_in;
    assign set_dirty_out = set_valid_in;
    assign memory_address_type_out = memory_address_type_in;
    assign is_word_out = is_word_in;
    assign inst_addr_out = inst_addr_in;
    assign halted_controller_out = halted_controller_in;


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

    // initial $monitor("reg_we: %b", register_write_in);

endmodule

