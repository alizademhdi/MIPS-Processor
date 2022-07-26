module Buffer_IF_ID(
    halted_controller_if,
    halted_controller_id,
    inst_addr_if,
    inst_addr_id,
    inst_if,
    inst_id,
    clk,
    rst_b,
    lock
);

    input clk;
    input rst_b;
    input [31:0] inst_if;
    input halted_controller_if;
    input [31:0] inst_addr_if;
    input lock;

    output reg [31:0] inst_id;
    output reg halted_controller_id;
    output [31:0] inst_addr_id;

    // move inst to next stage
    lock_dff #(32) inst_lock_dff(
        .d(inst_if),
        .q(inst_id),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    lock_dff #(32) inst_addr_lock_dff(
        .d(inst_addr_if),
        .q(inst_addr_id),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

    // move halted to next stage (for register file)
    lock_dff #(1) halted_lock_dff(
        .d(halted_controller_if),
        .q(halted_controller_id),
        .clk(clk),
        .rst_b(rst_b),
        .lock(lock)
    );

endmodule