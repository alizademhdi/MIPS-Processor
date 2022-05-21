
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


    input   [31:0] inst;
    input   [7:0]  mem_data_out[0:3];
    input          clk;
    input          rst_b;

    output  [31:0] inst_addr;
    output  [31:0] mem_addr;
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;

    assign mem_data_in[0] = rt_data[7:0];
    assign mem_data_in[1] = rt_data[15:8];
    assign mem_data_in[2] = rt_data[23:16];
    assign mem_data_in[3] = rt_data[31:24];
    assign mem_addr = ALU_result;


    // halted

    always @(inst)
    begin
        if(inst == 32'h000c)
            halted = 1;
        else
            halted = 0;
    end


    // Create Controller

    wire destination_register; // 1 for rd and 0 for rt
    wire jump;
    wire branch;
    wire jump_register;
    wire memory_to_register;
    wire [4:0] ALU_OP;
    wire ALU_src;
    wire register_write;
    wire is_unsigned;

    Controller controller(
        .destination_register(destination_register),
        .jump(jump),
        .branch(branch),
        .jump_register(jump_register),
        .we_memory(mem_write_en),
        .memory_to_register(memory_to_register),
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write),
        .is_unsigned(is_unsigned),
        .opcode(inst[31:26]),
        .func(inst[5:0])
    );


    // Create register file

    wire [31:0] rs_data;
    wire [31:0] rt_data;
    reg [31:0] rd_data;
    reg [4:0] rd_num;

    regfile regs(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(register_write),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

    always @(memory_to_register)
    begin

        if (memory_to_register)
            rd_data = {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]};
        else
            rd_data = ALU_result;

    end

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

    Extender unsign_extender(
        inst[15:0],
        imm_unsign_extend,
        0
    );

    reg [31:0] imm_sign_extend;
    reg [31:0] imm_unsign_extend;

    wire [31:0] ALU_result;
    reg [31:0] data_in2;
    wire zero;

    ALU alu(
        .data_out(ALU_result),
        .zero(zero),
        .ALU_OP(ALU_OP),
        .data_in1(rs_data),
        .data_in2(data_in2),
        .shift_amount(inst[10:6])
    );

    always @(ALU_src)
    begin
        if (ALU_src) begin
            if (is_unsigned)
                data_in2 = imm_unsign_extend;
            else
                data_in2 = imm_sign_extend;
        end else
            data_in2 = rt_data;
    end


    // Create PC controller

    pc_controller pc_controller(
        .pc(inst_addr),
        .jea(inst[25:0]),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .rs_data(rs_data),
        .imm_sign_extend(imm_sign_extend),
        .zero(zero),
        .clk(clk)
    );


endmodule
