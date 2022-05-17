
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

    parameter XLEN = 32, size = 32;

    input   [31:0] inst;
    input   [7:0]  mem_data_out[0:3];
    input          clk;
    input          rst_b;

    output  [31:0] inst_addr;
    output  [31:0] mem_addr;
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;


    // Create Controller

    wire destination_register; // 1 for rd and 0 for rt
    wire jump;
    wire branch;
    wire we_memory;
    wire memory_to_register;
    wire [4:0] ALU_OP;
    wire ALU_src;
    wire register_write;

    Controller controller(
        .destination_register(destination_register),
        .jump(jump),
        .branch(branch),
        .we_memory(we_memory),
        .memory_to_register(memory_to_register),
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write),
        .opcode(inst[31:26]),
        .func(inst[5:0]));


    // Create register file

    wire [XLEN-1:0] write_data;
    wire [XLEN-1:0] rs_data;
    wire [XLEN-1:0] rt_data;
    reg [4:0] rd_num;
    wire reg_write_enable;

    regfile regs(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(write_data),
        .rd_we(reg_write_enable),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

    always @(inst)
    begin

        if (destination_register)
            rd_num = inst[15:11];
        else
            rd_num = inst[20:16];

    end


    // Create ALU

    Extender sign_extender(
        inst[15:0],
        imm_sign_extend,
        1
    );
    reg [31:0] imm_sign_extend;

    reg [31:0] data_in2;
    wire zero;

    ALU alu(
        .data_out(write_data),
        .zero(zero),
        .ALU_OP(ALU_OP),
        .data_in1(rs_data),
        .data_in2(data_in2),
        .shift_amount(inst[10:6])
    );

    always @(ALU_src)
    begin
        if (ALU_src)
            data_in2 = imm_sign_extend;
        else
            data_in2 = rt_data;
    end


endmodule
