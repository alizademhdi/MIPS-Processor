module ID(
    rs_data,
    rt_data,
    pc4_in,
    pc4_out,
    inst,
    inst_50,
    inst_2016,
    inst_1511,
    inst_106,
    rd_data,
    rd_num,
    destination_register,
    ALU_src,
    ALU_OP,
    register_write_out,
    register_write_in,
    register_src,
    jump,
    jump_register,
    branch,
    pc_enable,
    halted,
    last_stage_halted,
    halted_controller_in,
    halted_controller_out,
    imm_extend,
    cache_input_type,
    set_dirty,
    set_valid,
    memory_address_type,
    we_cache,
    we_memory,
    is_word,
    cache_hit,
    cache_dirty,
    inst_addr_in,
    inst_addr_out,
    clk,
    rst_b
);

    input [31:0] inst_addr_in;
    input [31:0] pc4_in;
    input [31:0] inst;
    input [31:0] rd_data;
    input [4:0] rd_num;
    input register_write_in;
    input cache_hit;
    input cache_dirty;
    input halted_controller_in;
    input clk;
    input rst_b;
    input last_stage_halted;


    output [31:0] inst_addr_out;
    output reg [31:0] rs_data;
    output reg [31:0] rt_data;
    output [31:0] pc4_out;
    output [5:0] inst_50;
    output [4:0] inst_2016;
    output [4:0] inst_1511;
    output [4:0] inst_106;
    output reg [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    output reg ALU_src;
    output reg [4:0] ALU_OP;
    output reg we_memory;
    output reg register_write_out;
    output reg [1:0] register_src;
    output reg jump;
    output reg jump_register;
    output reg branch;
    output reg pc_enable;
    output reg [31:0] imm_extend;
    output reg cache_input_type;
    output reg we_cache;
    output reg set_dirty;
    output reg set_valid;
    output reg memory_address_type;
    output reg is_word;
    output reg halted_controller_out;
    output halted;

    assign pc4_out = pc4_in;
    assign inst_50 = inst[5:0];
    assign inst_2016 = inst[20:16];
    assign inst_1511 = inst[15:11];
    assign inst_106 = inst[10:6];
    assign inst_addr_out = inst_addr_in;
    assign halted_controller_out = halted_controller_in;
    assign halted = last_stage_halted;

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
        .halted(halted)
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
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write_out),
        .is_unsigned(is_unsigned),
        .pc_enable(pc_enable),
        .opcode(opcode),
        .we_cache(we_cache),
        .cache_input_type(cache_input_type),
        .memory_address_type(memory_address_type),
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .set_dirty(set_dirty),
        .set_valid(set_valid),
        .is_word(is_word),
        .func(inst[5:0]),
        .clk(clk)
    );

    // Create imm extender

    Extender sign_extender(
        .num(inst[15:0]),
        .extended(imm_extend),
        .is_unsign_extend(is_unsigned)
    );

    // always $display("time: %d, first_reg: %d, second_reg: %d, imm: %d", $time, rs_data, rt_data, imm_extend);

    endmodule
