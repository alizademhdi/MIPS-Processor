module ID(
    rs_data,
    rt_data,
    frs_data,
    frt_data,
    inst,
    inst_50,
    inst_2016,
    inst_1511,
    inst_106,
    rd_data,
    frd_data,
    rd_num,
    destination_register,
    ALU_src,
    ALU_OP,
    register_write_out,
    fregister_write_out,
    register_write_in,
    fregister_write_in,
    register_src,
    fregister_src,
    jump,
    jump_register,
    jea,
    branch,
    pc_enable,
    last_stage_halted,
    halted_controller_in,
    imm_extend,
    cache_input_type,
    set_dirty,
    set_valid,
    memory_address_type,
    we_cache,
    we_memory,
    is_word,
    inst_addr_in,
    is_nop,
    halted,
    clk,
    rst_b
);

    input [31:0] inst_addr_in;
    input [31:0] inst;
    input [31:0] rd_data;
    input [31:0] frd_data;
    input [4:0] rd_num;
    input register_write_in;
    input fregister_write_in;
    input halted_controller_in;
    input clk;
    input rst_b;
    input last_stage_halted;


    output [31:0] rs_data;
    output [31:0] rt_data;
    output [31:0] frs_data;
    output [31:0] frt_data;
    output [5:0] inst_50;
    output [4:0] inst_2016;
    output [4:0] inst_1511;
    output [4:0] inst_106;
    output [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    output ALU_src;
    output [4:0] ALU_OP;
    output we_memory;
    output register_write_out;
    output fregister_write_out;
    output [1:0] register_src;
    output [1:0] fregister_src;
    output jump;
    output jump_register;
    output [25:0] jea;
    output branch;
    output pc_enable;
    output [31:0] imm_extend;
    output cache_input_type;
    output we_cache;
    output set_dirty;
    output set_valid;
    output memory_address_type;
    output is_word;
    output is_nop;
    output halted;

    assign inst_50 = inst[5:0];
    assign inst_2016 = inst[20:16];
    assign inst_1511 = inst[15:11];
    assign inst_106 = inst[10:6];
    assign halted = last_stage_halted;
    assign jea = inst[25:0];

    wire [5:0] opcode;
    assign opcode = inst == 32'b0 ? 6'b111111 : inst[31:26];

    // Create register file
    regfile regs(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(register_write_in),
        .clk(clk),
        .rst_b(rst_b),
        .print(1'b1),
        .halted(last_stage_halted)
    );

    regfile regs_floating_point(
        .rs_data(frs_data),
        .rt_data(frt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(frd_data),
        .rd_we(fregister_write_in),
        .clk(clk),
        .rst_b(rst_b),
        .print(1'b0),
        .halted(last_stage_halted)
    );


    // Create Controller
    wire is_unsigned;

    Controller controller(
        .destination_register(destination_register),
        .jump(jump),
        .branch(branch),
        .jump_register(jump_register),
        .we_memory(we_memory),
        .register_src(register_src),
        .fregister_src(fregister_src),
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write_out),
        .fregister_write(fregister_write_out),
        .is_unsigned(is_unsigned),
        .pc_enable(pc_enable),
        .opcode(opcode),
        .we_cache(we_cache),
        .cache_input_type(cache_input_type),
        .memory_address_type(memory_address_type),
        .set_dirty(set_dirty),
        .set_valid(set_valid),
        .is_word(is_word),
        .is_nop(is_nop),
        .func(inst[5:0]),
        .clk(clk)
    );

    // Create imm extender
    Extender sign_extender(
        .num(inst[15:0]),
        .extended(imm_extend),
        .is_unsign_extend(is_unsigned)
    );


endmodule
