module Buffer_MEM_WB(
    inst_addr_mem,
    mem_addr_mem,
    ALU_result_mem,
    rt_data_mem,
    rd_num_mem,
    register_src_mem,
    register_write_mem,
    register_write,
    register_write_wb_cache,
    is_word_mem,
    mem_data_in_mem,
    cache_data_out_mem,
    byte_number_mem,
    halted_controller_mem,
    inst_addr_wb,
    mem_addr_wb,
    ALU_result_wb,
    rd_num_wb,
    register_src_wb,
    register_write_wb,
    is_word_wb,
    mem_data_in_wb,
    cache_data_out_wb,
    byte_number_wb,
    halted_controller_wb,
    clk,
    rst_b,
    lock
);

    input [31:0] inst_addr_mem;
    input [31:0] mem_addr_mem;
    input [31:0] ALU_result_mem;
    input [31:0] rt_data_mem;
    input [4:0] rd_num_mem;
    input [1:0] register_src_mem;
    input register_write_mem;
    input is_word_mem;
    input [7:0] mem_data_in_mem[0:3];
    input [7:0] cache_data_out_mem[0:3];
    input [1:0] byte_number_mem;
    input halted_controller_mem;
    input clk;
    input rst_b;
    input lock;
    input register_write;

    output reg [31:0] inst_addr_wb;
    output reg [31:0] mem_addr_wb;
    output reg [31:0] ALU_result_wb;
    output reg [4:0] rd_num_wb;
    output reg [1:0] register_src_wb;
    output reg register_write_wb;
    output reg is_word_wb;
    output reg [7:0] mem_data_in_wb[0:3];
    output reg [7:0] cache_data_out_wb[0:3];
    output reg [1:0] byte_number_wb;
    output reg halted_controller_wb;
    output register_write_wb_cache;

    lock_dff halted(
        .d(halted_controller_mem),
        .q(halted_controller_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) inst_addr_lock_dff(
        .d(inst_addr_mem),
        .q(inst_addr_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) mem_addr_lock_dff(
        .d(mem_addr_mem),
        .q(mem_addr_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) ALU_result_lock_dff(
        .d(ALU_result_mem),
        .q(ALU_result_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(5) rd_num_lock_dff(
        .d(rd_num_mem),
        .q(rd_num_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(2) register_src_lock_dff(
        .d(register_src_mem),
        .q(register_src_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) register_write_lock_dff2(
        .d(register_write_mem),
        .q(register_write_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) register_write_lock_dff(
        .d(register_write),
        .q(register_write_wb_cache),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) is_word_lock_dff(
        .d(is_word_mem),
        .q(is_word_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(1) halted_controller_lock_dff(
        .d(halted_controller_mem),
        .q(halted_controller_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(8) mem_data_in_lock_dff[0:3](
        .d(mem_data_in_mem),
        .q(mem_data_in_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(8) cache_data_out_lock_dff[0:3](
        .d(cache_data_out_mem),
        .q(cache_data_out_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(2) byte_number_lock_dff(
        .d(byte_number_mem),
        .q(byte_number_wb),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    // DO NOT REMOVE THIS LINE!!!!!!!!!!!!!!!!!!!!!!!!!!
    // always $display("time: %d, register_write_mem: %b", $time, register_write_mem);

endmodule