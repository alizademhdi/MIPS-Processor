module IF(
    pc4,
    pc_src,
    baddr,
    inst,
    inst_addr,
    pc_enable,
    rs_data,
    jump_register,
    jump,
    halted,
    clk
);

    input [31:0] inst;
    input clk;
    input  pc_src;
    input [31:0] baddr;
    input jump;
    input jump_register;
    input [31:0] rs_data;
    input pc_enable;
    

    output reg [31:0] inst_addr;
    output reg halted;

    output reg [31:0] pc4;

    // halted

    always @(inst)
    begin
        if(inst == 32'h000c)
            halted = 1;
        else
            halted = 0;
    end

    initial
		pc = 32'd0;

    assign pc4 = pc + 4;

    // create pc controller IF

    pc_controller_IF pc_controller_IF(
        .pc(inst_addr),
        .jea(inst[25:0]),
        .jump(jump),
        .jump_register(jump_register),
        .rs_data(rs_data),
        .pc_src(pc_src),
        .baddr(baddr),
        .pc_enable(pc_enable),
        .clk(clk)
    );

endmodule
