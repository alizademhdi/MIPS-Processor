module SignedComparator(
    data_in1,
    data_in2,
    g
);

    input   [31:0]  data_in1;
    input   [31:0]  data_in2;

    output reg [31:0] g;

    always @(data_in1 or data_in2) begin

        if (data_in1[31] == 0 && data_in2[31] == 0)
            g = data_in1 > data_in2 ? 32'b1 : 32'b0;
        else if (data_in1[31] == 0 && data_in2[31] == 1)
            g = 32'b1;
        else if (data_in1[31] == 1 && data_in2[31] == 0)
            g = 32'b0;
        else
            g = data_in1 > data_in2 ? 32'b0 : 32'b1;

    end

endmodule