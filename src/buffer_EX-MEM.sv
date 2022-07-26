module Buffer_EX_MEM(
    inst_addr_ex,
    inst_ex_out,
    inst_mem_in,
    register_write_ex,
    fregister_write_ex,
    fregister_write_mem,
    register_src_ex,
    fregister_src_ex,
    ALU_result_ex,
    fALU_result_ex,
    fALU_result_mem,
    imm_extend_ex,
    imm_extend_mem,
    rs_data_ex,
    rs_data_mem,
    rt_data_ex,
    rd_num_ex,
    frs_data_ex,
    frt_data_ex,
    frs_data_mem,
    frt_data_mem,
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
    fregister_src_mem,
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
    rst_b,
    lock
);

    input [31:0] inst_addr_ex;
    input [31:0] inst_ex_out;
    input register_write_ex;
    input fregister_write_ex;
    input [1:0] register_src_ex;
    input [1:0] fregister_src_ex;
    input [31:0] ALU_result_ex;
    input [31:0] fALU_result_ex;
    input [31:0] rs_data_ex;
    input [31:0] rt_data_ex;
    input [31:0] frs_data_ex;
    input [31:0] frt_data_ex;
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
    input [31:0] imm_extend_ex;
    input lock;

    output [31:0] inst_addr_mem;
    output [31:0] inst_mem_in;
    output register_write_mem;
    output fregister_write_mem;
    output [1:0] register_src_mem;
    output [1:0] fregister_src_mem;
    output [31:0] ALU_result_mem;
    output [31:0] fALU_result_mem;
    output [31:0] rs_data_mem;
    output [31:0] rt_data_mem;
    output [31:0] frs_data_mem;
    output [31:0] frt_data_mem;
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
    output [31:0] imm_extend_mem;

    lock_dff #(32) imm_extend(
        .d(imm_extend_ex),
        .q(imm_extend_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) inst(
        .d(inst_ex_out),
        .q(inst_mem_in),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff jump_register(
        .d(jump_register_ex),
        .q(jump_register_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff jump(
        .d(jump_ex),
        .q(jump_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff branch(
        .d(branch_ex),
        .q(branch_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff zero(
        .d(zero_ex),
        .q(zero_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff pc_enable(
        .d(pc_enable_ex),
        .q(pc_enable_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff is_nop(
        .d(is_nop_ex),
        .q(is_nop_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff halted(
        .d(halted_controller_ex),
        .q(halted_controller_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) inst_addr_lock_dff(
        .d(inst_addr_ex),
        .q(inst_addr_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) register_write_lock_dff(
        .d(register_write_ex),
        .q(register_write_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) fregister_write_lock_dff(
        .d(fregister_write_ex),
        .q(fregister_write_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(2) register_src_lock_dff(
        .d(register_src_ex),
        .q(register_src_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(2) fregister_src_lock_dff(
        .d(fregister_src_ex),
        .q(fregister_src_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) ALU_result_lock_dff(
        .d(ALU_result_ex),
        .q(ALU_result_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) fALU_result_lock_dff(
        .d(fALU_result_ex),
        .q(fALU_result_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) rt_data_lock_dff(
        .d(rt_data_ex),
        .q(rt_data_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) rs_data_lock_dff(
        .d(rs_data_ex),
        .q(rs_data_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) frt_data_lock_dff(
        .d(frt_data_ex),
        .q(frt_data_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) frs_data_lock_dff(
        .d(frs_data_ex),
        .q(frs_data_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(5) rd_num_lock_dff(
        .d(rd_num_ex),
        .q(rd_num_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) we_cache_lock_dff(
        .d(we_cache_ex),
        .q(we_cache_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) we_memory_lock_dff(
        .d(we_memory_ex),
        .q(we_memory_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) cache_input_type_lock_dff(
        .d(cache_input_type_ex),
        .q(cache_input_type_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) set_dirty_lock_dff(
        .d(set_dirty_ex),
        .q(set_dirty_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) set_valid_lock_dff(
        .d(set_valid_ex),
        .q(set_valid_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) memory_address_type_lock_dff(
        .d(memory_address_type_ex),
        .q(memory_address_type_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) is_word_lock_dff(
        .d(is_word_ex),
        .q(is_word_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) halted_controller_lock_dff(
        .d(halted_controller_ex),
        .q(halted_controller_mem),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    // always $display("time: %d, ALU_result_ex: %d, ALU_result_mem: %d", $time, ALU_result_ex, ALU_result_mem);


endmodule