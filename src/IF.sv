module IF(
    pc4,
    pc_src,
    result,
    inst,
    inst_addr,
    clk,
    rst_b
);

    input   [31:0] inst;
    input          clk;
    input          rst_b;
    input          pc_src;
    input          result;

    output  [31:0] inst_addr;
    output         pc4;

    output reg [31:0] pc;
    initial
		pc = 32'd0;

	assign pc4 = pc + 4;

    pc_controller pc_controller(
        .pc(inst_addr),
        .jea(inst[25:0]),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .rs_data(rs_data),
        .imm_sign_extend(imm_extend),
        .zero(zero),
        .pc_enable(pc_enable),
        .clk(clk)
    );

    endmodule


