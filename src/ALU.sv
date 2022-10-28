module ALU(
    data_out,
    zero,
    ALU_OP,
    data_in1,
    data_in2,
    shift_amount
);
    input wire [4:0] ALU_OP;
    input wire [31:0] data_in1;
    input wire [31:0] data_in2;
    input wire [4:0] shift_amount;

    output reg [31:0] data_out;
    output zero;


    parameter XOR_OP = 5'b00000;
    parameter SLL_OP = 5'b00001;
    parameter SLLV_OP = 5'b11001;
    parameter SRL_OP = 5'b00010;
    parameter SRLV_OP = 5'b11010;
    parameter SRA_OP = 5'b00011;
    parameter ADD_OP = 5'b00100;
    parameter SUB_OP = 5'b00101;
    parameter MULT_OP = 5'b00110;
    parameter DIV_OP = 5'b00111;
    parameter OR_OP = 5'b01000;
    parameter NOR_OP = 5'b01001;
    parameter AND_OP = 5'b01010;
    parameter SLT_OP = 5'b01011;
    parameter JR_OP = 5'b01100;
    parameter BEQ_OP = 5'b01101;
    parameter BNE_OP = 5'b01110;
    parameter BLEZ_OP = 5'b01111;
    parameter BGTZ_OP = 5'b10000;
    parameter BGEZ_OP = 5'b10001;
    parameter LUI_OP = 5'b10010;


    // Create arethmetic shifter to shifting data_in2 for sra

    wire [31:0] shifted_data_in2;

    ArithmeticShifter a(
        .data(data_in2),
        .shift_amount(shift_amount),
        .output_data(shifted_data_in2)
    );


    // Create signed comparator for compare signed data_in1 and signed data_in2

    wire [31:0] is_data1_greater_than_data2;

    SignedComparator signedComparator(
        .data_in1(data_in1),
        .data_in2(data_in2),
        .g(is_data1_greater_than_data2)
    );

    always @(*)
    begin
        case (ALU_OP)
            XOR_OP: data_out = data_in1 ^ data_in2;
            SLL_OP: data_out = data_in2 << shift_amount;
            SLLV_OP: data_out = data_in2 << data_in1;
            SRL_OP: data_out = data_in2 >> shift_amount;
            SRLV_OP: data_out = data_in2 >> data_in1;
            SRA_OP: data_out = shifted_data_in2;
            ADD_OP: data_out = data_in1 + data_in2;
            SUB_OP: data_out = data_in1 - data_in2;
            MULT_OP: data_out = data_in1 * data_in2;
            DIV_OP: data_out = data_in1 % data_in2;
            OR_OP: data_out = data_in1 | data_in2;
            NOR_OP: data_out = ~(data_in1 | data_in2);
            AND_OP: data_out = data_in1 & data_in2;
            SLT_OP: data_out = $signed(data_in1) < $signed(data_in2) ? 1 : 0;
            LUI_OP: data_out = {data_in2[15:0], 16'b0};
            BEQ_OP:
                begin
                    if(data_in1 == data_in2)
                        data_out = 1;
                    else
                        data_out = 0;
                end
            BNE_OP:
                begin
                    if(data_in1 != data_in2)
                        data_out = 1;
                    else
                        data_out = 0;
                end
            BLEZ_OP:
                begin
                    if(data_in1[31] == 1 || data_in1 == 32'b0)
                        data_out = 1;
                    else
                        data_out = 0;
                end
            BGTZ_OP:
                begin
                    if(data_in1[31] == 0 && data_in1 != 32'b0)
                        data_out = 1;
                    else
                        data_out = 0;
                end
            BGEZ_OP:
                begin
                    if(data_in1[31] == 0)
                        data_out = 1;
                    else
                        data_out = 0;
                end
            default: data_out = 0;
        endcase

    end

    assign zero = (data_out == 0) ? 1 : 0;

endmodule
