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

    input   [31:0] inst;
    input clk;
    input wire pc_src;
    input wire baddr;
    input wire jump;
    input wire jump_register;
    input wire [31:0] rs_data;
    input wire pc_enable;
    

    output  [31:0] inst_addr;
    output pc4;
    output reg halted;

    output reg [31:0] pc;

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


