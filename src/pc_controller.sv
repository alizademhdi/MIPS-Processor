module pc_controller(
    pc,
    jea,
    branch,
    jump,
    jump_register,
    rs_data,
    imm_sign_extend,
    zero,
    pc_enable,
    is_nop,
    clk
);
    input wire [25:0] jea;
    input wire branch;
    input wire jump;
    input wire jump_register;
    input wire [31:0] rs_data;
    input wire [31:0] imm_sign_extend;
    input wire zero;
    input wire pc_enable;
    input wire clk;
    input wire is_nop;

    output reg [31:0] pc;


    initial
		pc = 32'd0;

	wire [31:0] pc4;  // PC + 4
	assign pc4 = pc + 4;

    wire [31:0] jaddr;
    assign jaddr = {pc4[31:28], jea, 2'b00};

    wire [31:0] baddr;
    assign baddr = (imm_sign_extend << 2) + pc4;

    always @(posedge clk) begin
        if (pc_enable) begin
            if (jump == 1)
                pc = jaddr;
            else if (((branch && zero) && ~is_nop) == 1)
                pc = baddr;
            else if (jump_register == 1)
                pc = rs_data;
            else
                pc = pc4;
        end
    end

    // always $display("time: %d, pc_enable: %b, pc: %d, jump: %b, jaddr: %d, jump_register: %b, branch: %b, zero: %b, is_nop: %b, baddr: %d, rs_data: %d\n", $time, pc_enable, pc, jump, jaddr, jump_register, branch, zero, is_nop, baddr, rs_data);

endmodule
