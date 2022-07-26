module IF(
    pc,
    inst,
    inst_ex,
    rs_data,
    jump_register,
    jump,
    branch,
    imm_extend,
    zero,
    pc_enable,
    halted_controller,
    is_nop,
    clk
);

    input [31:0] inst;
    input [31:0] inst_ex;
    input clk;
    input jump;
    input jump_register;
    input branch;
    input [31:0] imm_extend;
    input zero;
    input [31:0] rs_data;
    input pc_enable;
    input is_nop;

    output reg halted_controller;
    output reg [31:0] pc;

    // halted_controller
    always @(inst)
    begin
        if(inst == 32'h000c)
            halted_controller = 1;
        else
            halted_controller = 0;
    end


    wire [31:0] pc;

    pc_controller pc_controller(
        .pc(pc),
        .jea(inst_ex[25:0]),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .rs_data(rs_data),
        .imm_sign_extend(imm_extend),
        .zero(zero),
        .pc_enable(pc_enable),
        .is_nop(is_nop),
        .clk(clk)
    );

endmodule
