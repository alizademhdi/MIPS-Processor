module ArithmeticShifter(
    data,
    shift_amount,
    output_data
);

    input   [31:0]  data;
    input   [4:0]   shift_amount;

    output reg [31:0]  output_data;


    reg [4:0] shift_amount_reg;

    always @(shift_amount or data) begin
        reg [31:0] shift_result = 0;
        shift_amount_reg = shift_amount;

        while (shift_amount_reg != 0) begin
            shift_result = shift_result + ({data[31], 31'b0} >> (shift_amount_reg - 1));
            shift_amount_reg = shift_amount_reg - 1;
        end

        output_data = shift_result + (data >> shift_amount);
    end

endmodule