module mips_core(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);


    input [31:0] inst;
    input [7:0] mem_data_out[0:3];
    input clk;
    input rst_b;

    output [31:0] inst_addr;
    output reg [31:0] mem_addr;
    output [7:0]  mem_data_in[0:3];
    output mem_write_en;
    output halted;

    wire [31:0] inst_if;
    wire [31:0] rs_data_id;
    wire [31:0] rs_data_ex;
    wire [31:0] rt_data_id;
    wire jump_register;
    wire jump;
    wire halted_controller_if;
    wire pc_enable;
    wire zero;
    wire jump_register_ex;
    wire jump_ex;
    wire pc_enable_ex;
    wire [31:0] inst_ex;
    wire is_nop_ex;
    wire [25:0] jea_ex;
    wire [25:0] jea_if;
    wire [31:0] rs_data_if;
    wire branch_if;
    wire jump_if;
    wire jump_register_if;
    wire pc_enable_if;
    wire [31:0] imm_extend_if;
    wire is_nop_if;
    wire zero_if;
    wire [31:0] imm_extend_ex;

    assign inst_if = inst;

    IF IF(
        .pc(inst_addr),
        .inst(inst_if),
        .inst_ex(inst_ex),
        .rs_data(rs_data_if),
        .jump_register(jump_register_if),
        .jump(jump_if),
        .branch(branch_if),
        .imm_extend(imm_extend_ex),
        .zero(zero),
        .pc_enable(pc_enable_if),
        .halted_controller(halted_controller_if),
        .is_nop(is_nop_if),
        .clk(clk)
    );

    wire [31:0] inst_id;
    wire halted_controller_in_id;

    Buffer_IF_ID Buffer_IF_ID(
        .halted_controller_if(halted_controller_if),
        .halted_controller_id(halted_controller_in_id),
        .inst_if(inst_if),
        .inst_id(inst_id),
        .clk(clk),
        .rst_b(rst_b)
    );

    wire [5:0] inst_50_id;
    wire [20:16] inst_2016_id;
    wire [15:11] inst_1511_id;
    wire [10:6] inst_106_id;
    wire [4:0] rd_num_in_wb;
    wire [4:0] rd_num_out_wb;
    wire [31:0] rd_data;
    wire [1:0] destination_register_id;
    wire ALU_src_id;
    wire [4:0] ALU_OP_id;
    wire register_write_wb;
    wire register_write_id;
    wire [1:0] register_src_id;
    wire branch_id;
    wire [31:0] imm_extend_id;
    wire cache_input_type_id;
    wire set_dirty_id;
    wire set_valid_id;
    wire we_cache_id;
    wire cache_hit;
    wire cache_dirty;
    wire we_memory_id;
    wire is_word_id;
    wire [31:0] inst_addr_in_id;
    wire [31:0] inst_addr_out_id;
    wire [31:0] inst_addr_in_ex;
    wire [31:0] inst_addr_out_ex;
    wire memory_address_type_id;
    wire halted_controller_out_id;
    wire jump_id;
    wire jump_register_id;
    wire pc_enable_id;
    wire [25:0] jea_id;
    wire is_nop_id;

    wire last_stage_halted;

    ID ID(
        .rs_data(rs_data_id),
        .rt_data(rt_data_id),
        .inst(inst_id),
        .inst_50(inst_50_id),
        .inst_2016(inst_2016_id),
        .inst_1511(inst_1511_id),
        .inst_106(inst_106_id),
        .rd_data(rd_data),
        .rd_num(rd_num_out_wb),
        .destination_register(destination_register_id),
        .ALU_src(ALU_src_id),
        .ALU_OP(ALU_OP_id),
        .register_write_out(register_write_id),
        .register_write_in(register_write_wb),
        .register_src(register_src_id),
        .jump(jump_id),
        .jump_register(jump_register_id),
        .jea(jea_id),
        .branch(branch_id),
        .pc_enable(pc_enable_id),
        .halted(halted),
        .last_stage_halted(last_stage_halted), // halted from wb stage
        .halted_controller_in(halted_controller_in_id),
        .halted_controller_out(halted_controller_out_id),
        .imm_extend(imm_extend_id),
        .cache_input_type(cache_input_type_id),
        .set_dirty(set_dirty_id),
        .set_valid(set_valid_id),
        .memory_address_type(memory_address_type_id),
        .we_cache(we_cache_id),
        .we_memory(we_memory_id),
        .is_word(is_word_id),
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .inst_addr_in(inst_addr_in_id),
        .inst_addr_out(inst_addr_out_id),
        .is_nop(is_nop_id),
        .clk(clk),
        .rst_b(rst_b)
    );

    wire we_memory_in_ex;
    wire we_memory_out_ex;
    wire [31:0] rt_data_in_ex;
    wire [31:0] rt_data_out_ex;
    wire [5:0] inst_50_ex;
    wire [20:16] inst_2016_ex;
    wire [15:11] inst_1511_ex;
    wire [10:6] inst_106_ex;
    wire [31:0] rd_data;
    wire [1:0] destination_register_ex;
    wire ALU_src_ex;
    wire [4:0] ALU_OP_ex;
    wire register_write_in_ex;
    wire register_write_out_ex;
    wire [1:0] register_src_in_ex;
    wire [1:0] register_src_out_ex;
    wire branch_ex;
    wire cache_input_type_in_ex;
    wire cache_input_type_out_ex;
    wire set_dirty_in_ex;
    wire set_dirty_out_ex;
    wire set_valid_in_ex;
    wire set_valid_out_ex;
    wire we_cache_in_ex;
    wire we_cache_out_ex;
    wire is_word_in_ex;
    wire is_word_out_ex;
    wire memory_address_type_in_ex;
    wire memory_address_type_out_ex;
    wire halted_controller_in_ex;

    Buffer_ID_EX Buffer_ID_EX(
        .inst_addr_id(inst_addr_out_id),
        .rs_data_id(rs_data_id),
        .rt_data_id(rt_data_id),
        .inst_id(inst_id),
        .is_nop_id(is_nop_id),
        .inst_50_id(inst_50_id),
        .inst_2016_id(inst_2016_id),
        .inst_1511_id(inst_1511_id),
        .inst_106_id(inst_106_id),
        .destination_register_id(destination_register_id),
        .ALU_src_id(ALU_src_id),
        .ALU_OP_id(ALU_OP_id),
        .we_memory_id(we_memory_id),
        .register_write_id(register_write_id),
        .register_src_id(register_src_id),
        .branch_id(branch_id),
        .jump_id(jump_id),
        .jump_register_id(jump_register_id),
        .jea_id(jea_id),
        .pc_enable_id(pc_enable_id),
        .imm_extend_id(imm_extend_id),
        .cache_input_type_id(cache_input_type_id),
        .we_cache_id(we_cache_id),
        .set_dirty_id(set_dirty_id),
        .set_valid_id(set_valid_id),
        .memory_address_type_id(memory_address_type_id),
        .is_word_id(is_word_id),
        .inst_addr_ex(inst_addr_in_ex),
        .rs_data_ex(rs_data_ex),
        .rt_data_ex(rt_data_in_ex),
        .inst_ex(inst_ex),
        .is_nop_ex(is_nop_ex),
        .inst_50_ex(inst_50_ex),
        .inst_2016_ex(inst_2016_ex),
        .inst_1511_ex(inst_1511_ex),
        .inst_106_ex(inst_106_ex),
        .destination_register_ex(destination_register_ex),
        .ALU_src_ex(ALU_src_ex),
        .ALU_OP_ex(ALU_OP_ex),
        .we_memory_ex(we_memory_in_ex),
        .register_write_ex(register_write_in_ex),
        .register_src_ex(register_src_in_ex),
        .branch_ex(branch_ex),
        .jump_ex(jump_ex),
        .jump_register_ex(jump_register_ex),
        .jea_ex(jea_ex),
        .pc_enable_ex(pc_enable_ex),
        .imm_extend_ex(imm_extend_ex),
        .cache_input_type_ex(cache_input_type_in_ex),
        .we_cache_ex(we_cache_in_ex),
        .set_dirty_ex(set_dirty_in_ex),
        .set_valid_ex(set_valid_in_ex),
        .memory_address_type_ex(memory_address_type_in_ex),
        .is_word_ex(is_word_in_ex),
        .halted_controller_id(halted_controller_out_id),
        .halted_controller_ex(halted_controller_in_ex),
        .clk(clk),
        .rst_b(rst_b)
    );

    wire [31:0] ALU_result_ex;
    wire [4:0] rd_num_ex;
    wire halted_controller_out_ex;

    EX EX(
        .rs_data_in(rs_data_ex),
        .rs_data_out(rs_data_if),
        .rt_data_in(rt_data_in_ex),
        .rt_data_out(rt_data_out_ex),
        .inst_50(inst_50_ex),
        .inst_2016(inst_2016_ex),
        .inst_1511(inst_1511_ex),
        .inst_106(inst_106_ex),
        .destination_register(destination_register_ex),
        .ALU_src(ALU_src_ex),
        .ALU_OP(ALU_OP_ex),
        .register_write_in(register_write_in_ex),
        .register_write_out(register_write_out_ex),
        .register_src_in(register_src_in_ex),
        .register_src_out(register_src_out_ex),
        .branch_in(branch_ex),
        .branch_out(branch_if),
        .jump_in(jump_ex),
        .jump_out(jump_if),
        .jump_register_in(jump_register_ex),
        .jump_register_out(jump_register_if),
        .jea_in(jea_ex),
        .jea_out(jea_if),
        .pc_enable_in(pc_enable_ex),
        .pc_enable_out(pc_enable_if),
        .zero(zero),
        .imm_extend_in(imm_extend_ex),
        .imm_extend_out(imm_extend_if),
        .ALU_result(ALU_result_ex),
        .rd_num(rd_num_ex),
        .we_cache_in(we_cache_in_ex),
        .we_cache_out(we_cache_out_ex),
        .we_memory_in(we_memory_in_ex),
        .we_memory_out(we_memory_out_ex),
        .cache_input_type_in(cache_input_type_in_ex),
        .cache_input_type_out(cache_input_type_out_ex),
        .set_dirty_in(set_dirty_in_ex),
        .set_dirty_out(set_dirty_out_ex),
        .set_valid_in(set_valid_in_ex),
        .set_valid_out(set_valid_out_ex),
        .memory_address_type_in(memory_address_type_in_ex),
        .memory_address_type_out(memory_address_type_out_ex),
        .is_word_in(is_word_in_ex),
        .is_word_out(is_word_out_ex),
        .is_nop_in(is_nop_ex),
        .is_nop_out(is_nop_if),
        .inst_addr_in(inst_addr_in_ex),
        .inst_addr_out(inst_addr_out_ex),
        .halted_controller_in(halted_controller_in_ex),
        .halted_controller_out(halted_controller_out_ex),
        .clk(clk)
    );


    wire [31:0] inst_addr_in_mem;
    wire [31:0] inst_addr_out_mem;
    wire register_write_in_mem;
    wire register_write_out_mem;
    wire [1:0] register_src_in_mem;
    wire [1:0] register_src_out_mem;
    wire [31:0] ALU_result_in_mem;
    wire [31:0] ALU_result_out_mem;
    wire [31:0] rt_data_mem;
    wire [4:0] rd_num_in_mem;
    wire [4:0] rd_num_out_mem;
    wire we_cache_mem;
    wire we_memory_mem;
    wire cache_input_type_mem;
    wire set_dirty_mem;
    wire set_valid_mem;
    wire is_word_in_mem;
    wire is_word_out_mem;
    wire memory_address_type_mem;
    wire halted_controller_in_mem;

    Buffer_EX_MEM Buffer_EX_MEM(
        .inst_addr_ex(inst_addr_out_ex),
        .register_write_ex(register_write_out_ex),
        .register_src_ex(register_src_out_ex),
        .ALU_result_ex(ALU_result_ex),
        .rt_data_ex(rt_data_out_ex),
        .rd_num_ex(rd_num_ex),
        .we_cache_ex(we_cache_out_ex),
        .we_memory_ex(we_memory_out_ex),
        .cache_input_type_ex(cache_input_type_out_ex),
        .set_dirty_ex(set_dirty_out_ex),
        .set_valid_ex(set_valid_out_ex),
        .memory_address_type_ex(memory_address_type_out_ex),
        .is_word_ex(is_word_out_ex),
        .jump_register_ex(jump_register_ex),
        .jump_ex(jump_ex),
        .branch_ex(branch_ex),
        .zero_ex(zero),
        .pc_enable_ex(pc_enable_ex),
        .is_nop_ex(is_nop_ex),
        .inst_addr_mem(inst_addr_in_mem),
        .register_write_mem(register_write_in_mem),
        .register_src_mem(register_src_in_mem),
        .ALU_result_mem(ALU_result_in_mem),
        .rt_data_mem(rt_data_mem),
        .rd_num_mem(rd_num_in_mem),
        .we_cache_mem(we_cache_mem),
        .we_memory_mem(we_memory_mem),
        .cache_input_type_mem(cache_input_type_mem),
        .set_dirty_mem(set_dirty_mem),
        .set_valid_mem(set_valid_mem),
        .memory_address_type_mem(memory_address_type_mem),
        .is_word_mem(is_word_in_mem),
        .jump_register_mem(jump_register_if),
        .jump_mem(jump_if),
        .branch_mem(branch_if),
        .zero_mem(zero_if),
        .pc_enable_mem(pc_enable_if),
        .is_nop_mem(is_nop_if),
        .halted_controller_ex(halted_controller_out_ex),
        .halted_controller_mem(halted_controller_in_mem),
        .clk(clk),
        .rst_b(rst_b)
    );

    wire halted_controller_out_mem;
    wire [7:0] cache_data_out_mem[0:3];
    wire [1:0] byte_number_mem;

    MEM MEM(
        .register_write_in(register_write_in_mem),
        .register_write_out(register_write_out_mem),
        .register_src_in(register_src_in_mem),
        .register_src_out(register_src_out_mem),
        .ALU_result_in(ALU_result_in_mem),
        .ALU_result_out(ALU_result_out_mem),
        .rd_num_in(rd_num_in_mem),
        .rd_num_out(rd_num_out_mem),
        .we_cache(we_cache_mem),
        .we_memory(we_memory_mem),
        .cache_input_type(cache_input_type_mem),
        .set_dirty(set_dirty_mem),
        .set_valid(set_valid_mem),
        .memory_address_type(memory_address_type_mem),
        .is_word_in(is_word_in_mem),
        .is_word_out(is_word_out_mem),
        .mem_addr(mem_addr),
        .mem_data_out(mem_data_out),
        .mem_data_in(mem_data_in),
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .inst_addr_in(inst_addr_in_mem),
        .inst_addr_out(inst_addr_out_mem),
        .cache_data_out(cache_data_out_mem),
        .rt_data(rt_data_mem),
        .byte_number(byte_number_mem),
        .halted_controller_in(halted_controller_in_mem),
        .halted_controller_out(halted_controller_out_mem),
        .clk(clk)
    );

    wire [31:0] inst_addr_wb;
    wire [31:0] ALU_result_wb;
    wire [1:0] register_src_wb;
    wire register_write_wb;
    wire is_word_wb;

    wire [7:0] mem_data_in_mem [0:3];
    wire [31:0] mem_addr_mem;
    wire [31:0] mem_addr_wb;
    wire [7:0] cache_data_out_wb[0:3];
    wire [7:0] mem_data_in_wb[0:3];
    wire [1:0] byte_number_wb;
    wire halted_controller_in_wb;

    Buffer_MEM_WB Buffer_MEM_WB(
        .inst_addr_mem(inst_addr_out_mem),
        .mem_addr_mem(mem_addr_mem),
        .ALU_result_mem(ALU_result_out_mem),
        .rt_data_mem(rt_data_mem),
        .rd_num_mem(rd_num_out_mem),
        .register_src_mem(register_src_out_mem),
        .register_write_mem(register_write_out_mem),
        .is_word_mem(is_word_out_mem),
        .mem_data_in_mem(mem_data_in_mem[0:3]),
        .cache_data_out_mem(cache_data_out_mem[0:3]),
        .byte_number_mem(byte_number_mem),
        .inst_addr_wb(inst_addr_wb),
        .mem_addr_wb(mem_addr_wb),
        .ALU_result_wb(ALU_result_wb),
        .rd_num_wb(rd_num_in_wb),
        .register_src_wb(register_src_wb),
        .register_write_wb(register_write_wb),
        .is_word_wb(is_word_wb),
        .mem_data_in_wb(mem_data_in_wb),
        .cache_data_out_wb(cache_data_out_wb),
        .byte_number_wb(byte_number_wb),
        .halted_controller_mem(halted_controller_out_mem),
        .halted_controller_wb(halted_controller_in_wb),
        .clk(clk),
        .rst_b(rst_b)
    );

    WB WB(
        .byte_number(byte_number_wb),
        .register_src(register_src_wb),
        .rd_data(rd_data),
        .rd_num_in(rd_num_in_wb),
        .rd_num_out(rd_num_out_wb),
        .is_word(is_word_wb),
        .cache_data_out(cache_data_out_wb),
        .inst_addr(inst_addr_wb),
        .ALU_result(ALU_result_wb),
        .halted_controller(halted_controller_in_wb),
        .last_stage_halted(last_stage_halted),
        .clk(clk)
    );

endmodule
