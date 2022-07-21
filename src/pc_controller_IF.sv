module pc_controller_IF(
    pc,
    jea,
    jump,
    jump_register,
    rs_data,
    pc_src,
    baddr,
    pc_enable,
    clk
);
    input wire [25:0] jea;
    input wire jump;
    input wire jump_register;
    input wire [31:0] rs_data;
    input wire pc_src;
    input wire [31:0] baddr;
    input wire pc_enable;
    input wire clk;

    output reg [31:0] pc;

    initial
		pc = 32'd0;

	wire [31:0] pc4;  // PC + 4
	assign pc4 = pc + 4;

    wire [31:0] jaddr;
    assign jaddr = {pc4[31:28], jea, 2'b00};


    always_ff @(posedge clk) begin
        if (pc_enable) begin
            if (jump == 1)
                pc <= jaddr;
            else if (pc_src == 1)
                pc <= baddr;
            else if (jump_register == 1)
                pc <= rs_data;
            else
                pc <= pc4;
        end
    end

endmodule
