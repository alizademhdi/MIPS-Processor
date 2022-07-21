module ID(
    rs_data,
    rt_data,
    pc4_in,
    pc4_out,
    inst,
    inst_50,
    inst_2016,
    inst_1511,
    rd_data,
    rd_num,
    destination_register,
    ALU_src,
    ALU_OP,
    //mem_write, // Need to be replaced
    //mem_read, // Need to be replaced
    register_write_out,
    register_write_in,
    register_src,
    jump,
    jump_register,
    branch,
    pc_enable,
    halted,
    imm_extend,
    cache_input_type,
    set_dirty,
    set_valid,
    memory_address_type,
    we_cache,
    clk,
    rst_b
);

    input [31:0] pc4_in;
    input [31:0] inst;
    input [31:0] rd_data;
    input [4:0] rd_num;
    input register_write_in;
    input halted;
    input clk;
    input rst_b;
    

    output reg [31:0] rs_data;
    output reg [31:0] rt_data;
    output [31:0] pc4_out;
    output [6:0] inst_50;
    output [4:0] inst_2016;
    output [4:0] inst_1511;
    output reg [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    output reg ALU_src;
    output reg [4:0] ALU_OP;
    output reg mem_write;
    output reg mem_read;
    output reg register_write_out;
    output reg [1:0] register_src;
    output reg jump;
    output reg jump_register;
    output reg branch;
    output reg pc_enable;
    output reg [31:0] imm_extend;
    output reg we_cache;
    output reg cache_input_type;
    output reg set_dirty;
    output reg set_valid;
    output reg memory_address_type;

    assign pc4_out = pc4_in;
    assign inst_50 = inst[5:0];
    assign inst_2016 = inst[20:16];
    assign inst_1511 = inst[15:11];

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
        .we_memory(mem_write_en),
        .register_src(register_src),
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write_out),
        .is_unsigned(is_unsigned),
        .pc_enable(pc_enable),
        .opcode(inst[31:26]),
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


    endmodule
