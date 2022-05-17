module SignExtender(
    num,
    extended,
    clk);

    input [15:0] num;
    input clk;

    output reg [31:0] extended;

    always @(posedge clk)
    begin
        extended[31:0] <= { { 16{num[15]} }, num[15:0]};
    end
    
endmodule