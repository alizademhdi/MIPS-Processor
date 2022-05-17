module Extender(
    num,
    extended,
    is_sign_extend,
    clk);

    input [15:0] num;
    input is_sign_extend;
    input clk;

    output reg [31:0] extended;

    always @(posedge clk)
    begin
        if (is_sign_extend)
            extended[31:0] <= { { 16{num[15]} }, num[15:0]};
        else
            extended[31:0] <= { { 16'h0 }, num[15:0]};
    end

endmodule