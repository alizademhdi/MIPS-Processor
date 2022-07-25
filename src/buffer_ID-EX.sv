module Buffer_ID_EX(
    inst_addr_id,
    rs_data_id,
    rt_data_id,
    inst_id,
    inst_50_id,
    inst_2016_id,
    inst_1511_id,
    inst_106_id,
    inst_id_out,
    inst_ex_in,
    destination_register_id,
    ALU_src_id,
    ALU_OP_id,
    we_memory_id,
    register_write_id,
    register_src_id,
    is_nop_id,
    halted_controller_id,
    branch_id,
    jump_id,
    jump_register_id,
    jea_id,
    pc_enable_id,
    imm_extend_id,
    cache_input_type_id,
    we_cache_id,
    set_dirty_id,
    set_valid_id,
    memory_address_type_id,
    is_word_id,
    inst_addr_ex,
    rs_data_ex,
    rt_data_ex,
    inst_ex,
    inst_50_ex,
    inst_2016_ex,
    inst_1511_ex,
    inst_106_ex,
    destination_register_ex,
    ALU_src_ex,
    ALU_OP_ex,
    we_memory_ex,
    register_write_ex,
    register_src_ex,
    halted_controller_ex,
    branch_ex,
    jump_ex,
    jump_register_ex,
    jea_ex,
    is_nop_ex,
    pc_enable_ex,
    imm_extend_ex,
    cache_input_type_ex,
    we_cache_ex,
    set_dirty_ex,
    set_valid_ex,
    memory_address_type_ex,
    is_word_ex,
    clk,
    rst_b
);

    input [31:0] inst_addr_id;
    input [31:0] inst_id;
    input [31:0] inst_id_out;
    input [31:0] rs_data_id;
    input [31:0] rt_data_id;
    input [5:0] inst_50_id;
    input [4:0] inst_2016_id;
    input [4:0] inst_1511_id;
    input [4:0] inst_106_id;
    input [1:0] destination_register_id; // 01 for rd and 00 for rt and 10 for ra
    input ALU_src_id;
    input [4:0] ALU_OP_id;
    input we_memory_id;
    input register_write_id;
    input [1:0] register_src_id;
    input halted_controller_id;
    input jump_id;
    input jump_register_id;
    input pc_enable_id;
    input [25:0] jea_id;
    input branch_id;
    input [31:0] imm_extend_id;
    input cache_input_type_id;
    input we_cache_id;
    input set_dirty_id;
    input set_valid_id;
    input memory_address_type_id;
    input is_word_id;
    input is_nop_id;
    input clk;
    input rst_b;

    output [31:0] inst_ex;
    output [31:0] inst_ex_in;
    output reg [31:0] inst_addr_ex;
    output reg [31:0] rs_data_ex;
    output reg [31:0] rt_data_ex;
    output reg [5:0] inst_50_ex;
    output reg [4:0] inst_2016_ex;
    output reg [4:0] inst_1511_ex;
    output reg [4:0] inst_106_ex;
    output reg [1:0] destination_register_ex; // 01 for rd and 00 for rt and 10 for ra
    output reg ALU_src_ex;
    output reg [4:0] ALU_OP_ex;
    output reg we_memory_ex;
    output reg register_write_ex;
    output reg [1:0] register_src_ex;
    output reg jump_ex;
    output reg jump_register_ex;
    output reg [25:0] jea_ex;
    output reg pc_enable_ex;
    output reg branch_ex;
    output reg [31:0] imm_extend_ex;
    output reg cache_input_type_ex;
    output reg we_cache_ex;
    output reg set_dirty_ex;
    output reg set_valid_ex;
    output reg memory_address_type_ex;
    output reg is_word_ex;
    output is_nop_ex;
    output halted_controller_ex;

    // initial $monitor("reg_we: %b", register_write_id);

    dff halted(
        .d(halted_controller_id),
        .q(halted_controller_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff is_nop(
        .d(is_nop_id),
        .q(is_nop_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) inst_dff(
        .d(inst_id),
        .q(inst_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) inst_2_dff(
        .d(inst_id_out),
        .q(inst_ex_in),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) inst_addr_dff(
        .d(inst_addr_id),
        .q(inst_addr_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) rs_data_diff(
        .d(rs_data_id),
        .q(rs_data_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) rt_data_dff(
        .d(rt_data_id),
        .q(rt_data_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(6) inst_50_dff(
        .d(inst_50_id),
        .q(inst_50_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(5) inst_2016_dff(
        .d(inst_2016_id),
        .q(inst_2016_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(5) inst_1511_dff(
        .d(inst_1511_id),
        .q(inst_1511_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(5) inst_106_dff(
        .d(inst_106_id),
        .q(inst_106_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(2) destination_register_dff(
        .d(destination_register_id),
        .q(destination_register_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) ALU_src_dff(
        .d(ALU_src_id),
        .q(ALU_src_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(5) ALU_OP_dff(
        .d(ALU_OP_id),
        .q(ALU_OP_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) we_memory_dff(
        .d(we_memory_id),
        .q(we_memory_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) register_write_dff(
        .d(register_write_id),
        .q(register_write_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(2) register_src_dff(
        .d(register_src_id),
        .q(register_src_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) handler_controller_dff(
        .d(halted_controller_id),
        .q(halted_controller_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) branch_dff(
        .d(branch_id),
        .q(branch_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) jump_dff(
        .d(jump_id),
        .q(jump_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) pc_enable_dff(
        .d(pc_enable_id),
        .q(pc_enable_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) jump_register_dff(
        .d(jump_register_id),
        .q(jump_register_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(26) jea_dff(
        .d(jea_id),
        .q(jea_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) imm_extend_dff(
        .d(imm_extend_id),
        .q(imm_extend_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    always $display("time: %d, imm_id: %d, imm_ex: %d", $time, imm_extend_id, imm_extend_ex);

    dff #(1) cache_input_type_dff(
        .d(cache_input_type_id),
        .q(cache_input_type_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) we_cache_dff(
        .d(we_cache_id),
        .q(we_cache_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) set_dirty_dff(
        .d(set_dirty_id),
        .q(set_dirty_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) set_valid_dff(
        .d(set_valid_id),
        .q(set_valid_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) mempory_address_type_dff(
        .d(memory_address_type_id),
        .q(memory_address_type_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) is_word_dff(
        .d(is_word_id),
        .q(is_word_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

endmodule