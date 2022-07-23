module Buffer_IF_ID(
    halted_controller_if,
    halted_controller_id,
    inst_if,
    inst_id,
    clk,
    rst_b
);

    input clk;
    input rst_b;
    input [31:0] inst_if;
    input halted_controller_if;

    output reg [31:0] inst_id;
    output reg halted_controller_id;

    // move inst to next stage
    dff #(32) inst_dff(
        .d(inst_if),
        .q(inst_id),
        .clk(clk),
        .rst_b(rst_b)
    );

    // move halted to next stage (for register file)
    dff #(1) halted_dff(
        .d(halted_controller_if),
        .q(halted_controller_id),
        .clk(clk),
        .rst_b(rst_b)
    );

endmodule