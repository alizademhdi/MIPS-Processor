module pc_controller_EX(
    pc4,
    branch,
    imm_sign_extend,
    zero,
    pc_src,
    baddr,
    clk
);
    input wire branch;
    input wire [31:0] imm_sign_extend;
    input wire [31:0] pc4;
    input wire zero;
    input wire clk;

    output reg [31:0] baddr;
    output reg pc_src;
    
    always_ff @(posedge clk) begin
        pc_src = zero && branch;
        baddr = (imm_sign_extend << 2) + pc4;
    end
endmodule
