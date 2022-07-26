module MEM(
    inst_mem_in,
    register_write_in,
    register_src_in,
    register_write,
    ALU_result_in,
    rd_num_in,
    we_cache,
    we_memory,
    cache_input_type,
    set_dirty,
    set_valid,
    memory_address_type,
    is_word_in,
    is_word,
    mem_addr,
    mem_data_out,
    mem_data_in,
    cache_hit,
    cache_dirty,
    inst_addr_in,
    cache_data_out,
    rt_data,
    byte_number,
    halted_controller_in,
    pc_enable,
    lock,
    clk
);

    input [31:0] inst_mem_in;
    input [31:0] inst_addr_in;
    input [7:0] mem_data_out[0:3];
    input [31:0] ALU_result_in;
    input we_cache;
    input cache_input_type;
    input set_dirty;
    input set_valid;
    input memory_address_type;
    input is_word_in;
    input [4:0] rd_num_in;
    input [1:0] register_src_in;
    input register_write_in;
    input [31:0] rt_data;
    input halted_controller_in;
    input clk;

    output reg cache_hit;
    output reg cache_dirty;
    output reg [31:0] mem_addr;
    output [7:0] mem_data_in[0:3];
    output reg [7:0] cache_data_out[0:3];
    output reg [1:0] byte_number;
    output we_memory;
    output pc_enable;
    output is_word;
    output lock;
    output register_write;

    assign mem_data_in[0] = cache_data_out[0];
    assign mem_data_in[1] = cache_data_out[1];
    assign mem_data_in[2] = cache_data_out[2];
    assign mem_data_in[3] = cache_data_out[3];

    always @(memory_address_type2)
    begin
        if (memory_address_type2) begin
            mem_addr = memory_write_address;
        end
        else begin
            mem_addr = ALU_result_in;
        end
    end

    // Create cache

    wire [31:0] memory_write_address;
    reg [31:0] cache_data_in2;
    wire [5:0] opcode;
    wire we_cache2;
    wire cache_input_type2;
    wire memory_address_type2;
    wire is_word;
    wire register_write2;
    wire set_dirty2;
    wire set_valid2;

    assign opcode = inst_mem_in == 32'b0 ? 6'b111111 : inst_mem_in[31:26];

    Cache cache(
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .data_out(cache_data_out),
        .memory_write_address(memory_write_address),
        .byte_number(byte_number),
        .we_cache(we_cache2),
        .cache_addr(ALU_result_in),
        .data_in(cache_data_in2),
        .set_valid(set_valid2),
        .set_dirty(set_dirty2),
        .is_word(is_word),
        .clk(clk)
    );

    CacheController cache_controller(
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .opcode(opcode),
        .we_memory(we_memory),
        .we_cache(we_cache2),
        .cache_input_type(cache_input_type2),
        .memory_address_type(memory_address_type2),
        .is_word(is_word),
        .register_write(register_write),
        .set_dirty(set_dirty2),
        .set_valid(set_valid2),
        .pc_enable(pc_enable),
        .lock(lock),
        .clk(clk)
    );

    assign cache_data_in2 = cache_input_type2 == 1'b0 ? {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]} : rt_data;

    // always $display("time: %d, lock: %b, opcode: %b, address: %h, we_memory: %b, cache_data_out: %h", $time, lock, opcode, memory_write_address, we_memory, cache_data_out);

endmodule