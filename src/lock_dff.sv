module lock_dff #(
    parameter WIDTH = 1
) (
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    input clk,
    input rst_b,
    input lock
);

    always @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            q <= 0;
        end else if (~lock) begin
            q <= d;
        end
    end

endmodule