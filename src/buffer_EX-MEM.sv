module Buffer_EX_MEM(
    inst_addr_ex,
    register_write_ex,
    register_src_ex,
    ALU_result_ex,
    rt_data_ex,
    rd_num_ex,
    we_cache_ex,
    we_memory_ex,
    cache_input_type_ex,
    set_dirty_ex,
    set_valid_ex,
    memory_address_type_ex,
    is_word_ex,
    jump_register_ex,
    jump_ex,
    branch_ex,
    zero_ex,
    pc_enable_ex,
    is_nop_ex,
    halted_controller_ex,
    inst_addr_mem,
    register_write_mem,
    register_src_mem,
    ALU_result_mem,
    rt_data_mem,
    rd_num_mem,
    we_cache_mem,
    we_memory_mem,
    cache_input_type_mem,
    set_dirty_mem,
    set_valid_mem,
    memory_address_type_mem,
    is_word_mem,
    jump_register_mem,
    jump_mem,
    branch_mem,
    zero_mem,
    pc_enable_mem,
    is_nop_mem,
    halted_controller_mem,
    clk,
    rst_b

);

    input [31:0] inst_addr_ex;
    input register_write_ex;
    input [1:0] register_src_ex;
    input [31:0] ALU_result_ex;
    input [31:0] rt_data_ex;
    input [4:0] rd_num_ex;
    input we_cache_ex;
    input we_memory_ex;
    input cache_input_type_ex;
    input set_dirty_ex;
    input set_valid_ex;
    input memory_address_type_ex;
    input is_word_ex;
    input halted_controller_ex;
    input clk;
    input rst_b;
    input jump_register_ex;
    input jump_ex;
    input branch_ex;
    input zero_ex;
    input pc_enable_ex;
    input is_nop_ex;

    output [31:0] inst_addr_mem;
    output register_write_mem;
    output [1:0] register_src_mem;
    output [31:0] ALU_result_mem;
    output [31:0] rt_data_mem;
    output [4:0] rd_num_mem;
    output we_cache_mem;
    output we_memory_mem;
    output cache_input_type_mem;
    output set_dirty_mem;
    output set_valid_mem;
    output memory_address_type_mem;
    output is_word_mem;
    output jump_register_mem;
    output jump_mem;
    output branch_mem;
    output zero_mem;
    output pc_enable_mem;
    output is_nop_mem;
    output halted_controller_mem;

    dff jump_register(
        .d(jump_register_ex),
        .q(jump_register_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff jump(
        .d(jump_ex),
        .q(jump_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff branch(
        .d(branch_ex),
        .q(branch_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff zero(
        .d(zero_ex),
        .q(zero_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff pc_enable(
        .d(pc_enable_ex),
        .q(pc_enable_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff is_nop(
        .d(is_nop_ex),
        .q(is_nop_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff halted(
        .d(halted_controller_ex),
        .q(halted_controller_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) inst_addr_dff(
        .d(inst_addr_ex),
        .q(inst_addr_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) register_write_dff(
        .d(register_write_ex),
        .q(register_write_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(2) register_src_dff(
        .d(register_src_ex),
        .q(register_src_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) ALU_result_dff(
        .d(ALU_result_ex),
        .q(ALU_result_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(32) rt_data_dff(
        .d(rt_data_ex),
        .q(rt_data_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(5) rd_num_dff(
        .d(rd_num_ex),
        .q(rd_num_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) we_cache_dff(
        .d(we_cache_ex),
        .q(we_cache_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) we_memory_dff(
        .d(we_memory_ex),
        .q(we_memory_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) cache_input_type_dff(
        .d(cache_input_type_ex),
        .q(cache_input_type_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) set_dirty_dff(
        .d(set_dirty_ex),
        .q(set_dirty_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) set_valid_dff(
        .d(set_valid_ex),
        .q(set_valid_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) memory_address_type_dff(
        .d(memory_address_type_ex),
        .q(memory_address_type_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) is_word_dff(
        .d(is_word_ex),
        .q(is_word_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    dff #(1) halted_controller_dff(
        .d(halted_controller_ex),
        .q(halted_controller_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    // always $display("time: %d, ALU_result_ex: %d, ALU_result_mem: %d", $time, ALU_result_ex, ALU_result_mem);


endmodule