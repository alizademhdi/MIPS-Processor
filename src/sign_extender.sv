module Extender(
    num,
    extended,
    is_unsign_extend
    );

    input [15:0] num;
    input is_unsign_extend;

    output reg [31:0] extended;

    always @(num)
    begin
        if (~is_unsign_extend)
            extended[31:0] = { { 16{num[15]} }, num[15:0]};
        else
            extended[31:0] = { { 16'h0 }, num[15:0]};
    end

endmodule