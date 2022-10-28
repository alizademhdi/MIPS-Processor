module floating_point_ALU(
    data_out,
    division_by_zero,
    QNaN,
    SNaN,
    inexact,
    underflow,
    overflow,
    data_in1,
    data_in2,
    ALU_OP
);
    input [31:0] data_in1;
    input [31:0] data_in2;
    input  [4:0] ALU_OP;

    output reg [31:0] data_out;
    output reg division_by_zero,QNaN,SNaN,inexact,underflow,overflow;


    parameter ADD_F = 5'b10011;
    parameter SUB_F = 5'b10100;
    parameter MUL_F = 5'b10101;
    parameter DIV_F = 5'b10110;
    parameter INVRS_F = 5'b10111;
    parameter ROUND_F = 5'b11000;
    parameter NOP = 5'b11001;
    parameter SLT_F = 5'b11010;


    reg sign_input1, sign_input2, sign_output;
    reg [7:0] exp_input1, exp_input2, exp_output;
    reg [24:0] mantissa_input1, mantissa_input2, mantissa_output;
    reg [22:0] dummy;
    reg [63:0] mantissa_mul;

    always_latch @(data_in1, data_in2, ALU_OP)
    begin
        sign_input1 = data_in1[31];
        sign_input2 = data_in2[31];

        mantissa_input1 = {2'b00, data_in1[22 : 0]};
        mantissa_input2 = {2'b00, data_in2[22 : 0]};

        exp_input1 = data_in1[30:23];
        exp_input2 = data_in2[30:23];

        mantissa_input1[23] = 1;
        mantissa_input2[23] = 1;


        case(ALU_OP)
            NOP:
                data_out = data_in1;

            ADD_F:
            begin
                if(data_in2 == 0)
                    data_out = data_in1;

                else
                begin
                    if(data_in1 == 0)
                        data_out = data_in2;

                    else
                    begin
                        if(exp_input1 > exp_input2)
                        begin
                            while (exp_input1 != exp_input2)
                            begin
                                exp_input2 = exp_input2 + 1;
                                mantissa_input2 = mantissa_input2 >> 1;
                            end
                        end

                        if(exp_input2 > exp_input1)
                        begin
                            while (exp_input1 != exp_input2)
                            begin
                                exp_input1 = exp_input1 + 1;
                                mantissa_input1 = mantissa_input1 >> 1;
                            end
                        end

                        exp_output = exp_input1;

                        if(sign_input1 ^ sign_input2)
                        begin
                            if(sign_input1)
                                mantissa_output = mantissa_input2[24:0] +{1'b0, -(mantissa_input1[23:0])};

                            else
                                mantissa_output = mantissa_input1[24:0] + {1'b0,-(mantissa_input2[23:0])};

                            if(mantissa_output[24])
                            begin
                                if(mantissa_output [23 : 0] == 24'b0)
                                begin
                                    sign_output = 0;
                                    exp_output = 0;
                                    mantissa_output = 0;
                                end
                                else
                                begin
                                    while(mantissa_output[23] != 1)
                                    begin
                                        mantissa_output = mantissa_output << 1;
                                        exp_output = exp_output - 1;
                                    end
                                    sign_output = 0;
                                end
                            end
                            else
                            begin
                                mantissa_output = -mantissa_output;
                                sign_output = 1;
                                while(mantissa_output[23] != 1)
                                begin
                                    mantissa_output = mantissa_output << 1;
                                    exp_output = exp_output - 1;
                                end
                            end
                        end

                        else
                        begin
                            mantissa_output = mantissa_input1 + mantissa_input2;
                            sign_output = sign_input1;
                            if(mantissa_output[24])
                            begin
                                mantissa_output = mantissa_output >> 1;
                                exp_output = exp_output + 1;
                            end
                            else
                            begin
                                if(mantissa_output[23] == 0) begin
                                    if(mantissa_output[22:0] != 23'b0)
                                    begin
                                        while (mantissa_output[23] != 1)
                                        begin
                                            mantissa_output = mantissa_output << 1;
                                            exp_output = exp_output - 1;
                                        end
                                    end
                                end
                            end
                        end

                        data_out = {sign_output,exp_output,mantissa_output[22:0]};
                    end
                end
            end

            SUB_F:
            begin
                if(data_in1 == 0)
                    data_out = data_in1;

                else
                begin
                    if(data_in1 == 0)
                        data_out = data_in2;

                    else
                    begin
                        if(exp_input1 > exp_input2)
                        begin
                            while (exp_input1 != exp_input2)
                            begin
                                exp_input2 = exp_input2 + 1;
                                mantissa_input2 = mantissa_input2 >> 1;
                            end
                        end

                        if(exp_input2 > exp_input1)
                        begin
                            while (exp_input1 != exp_input2)
                            begin
                                exp_input1 = exp_input1 + 1;
                                mantissa_input1 = mantissa_input1 >> 1;
                            end
                        end

                        exp_output = exp_input1;

                        if(!(sign_input1 ^ sign_input2))
                        begin
                            if(sign_input1)
                                mantissa_output = mantissa_input2[24:0] + {1'b0, -(mantissa_input1[23:0])};

                            else
                                mantissa_output = mantissa_input1[24:0] + {1'b0,-(mantissa_input2[23:0])};

                            if(mantissa_output[24])
                            begin
                                if(mantissa_output [23 : 0] == 24'b0)
                                begin
                                    sign_output = 0;
                                    exp_output = 0;
                                    mantissa_output = 0;
                                end

                                else
                                begin
                                    while(mantissa_output[23] != 1)
                                    begin
                                        mantissa_output = mantissa_output << 1;
                                        exp_output = exp_output - 1;
                                    end
                                    sign_output = 0;
                                end
                            end

                            else
                            begin
                                mantissa_output = -mantissa_output;
                                sign_output = 1;
                                while(mantissa_output[23] != 1)
                                begin
                                    mantissa_output = mantissa_output << 1;
                                    exp_output = exp_output - 1;
                                end
                            end
                        end

                        else
                        begin
                            mantissa_output = mantissa_input1 + mantissa_input2;
                            sign_output = sign_input1;
                            if(mantissa_output[24])
                            begin
                                mantissa_output = mantissa_output >> 1;
                                exp_output = exp_output + 1;
                            end
                            else if(mantissa_output[23] == 0 && mantissa_output[22:0] != 23'b0)
                            begin
                                while (mantissa_output[23] != 1)
                                begin
                                    mantissa_output = mantissa_output << 1;
                                    exp_output = exp_output - 1;
                                end
                            end

                        end
                        data_out = {sign_output,exp_output,mantissa_output[22:0]};
                    end

                end
            end

            MUL_F:
            begin
                if (data_in1 == 0 || data_in2 == 0)
                         data_out = 0;

                else
                begin
                    sign_output = sign_input1 ^ sign_input2;
                    exp_output = exp_input1 + exp_input2 - 126;
                    mantissa_input1[24] = 0;
                    mantissa_input2[24] = 0;
                    mantissa_mul = mantissa_input1[23 : 0] * mantissa_input2 [23 : 0];
                    mantissa_output = {1'b0, mantissa_mul[47 : 24]};

                    if (mantissa_output[24] != 1)
                    begin
                        mantissa_output = mantissa_output << 1;
                        exp_output = exp_output - 1;
                    end

                    data_out = {sign_output, exp_output, mantissa_output[22 : 0]};
                end
            end

            DIV_F:
            begin
                if(data_in2 == 0)
                    division_by_zero = 1;

                else
                begin
                    if(data_in1 == 0)
                        data_out = 0;

                    else begin
                        sign_output = sign_input1 ^ sign_input2;
                        mantissa_output = 25'b0;

                        if(mantissa_input1 > mantissa_input2)
                        begin
                            mantissa_output[23] = mantissa_input1[0];
                            mantissa_input1 = mantissa_input1 >> 1;
                            exp_input1 = exp_input1 + 1;
                        end

                        exp_output = exp_input1 - exp_input2 + 126;

                        {dummy, mantissa_output} = ({mantissa_input1[23 : 0],mantissa_output[23 : 0]} / {24'd0, mantissa_input2[23 : 0]});

                        while(mantissa_output[23] > 1)
                        begin
                            mantissa_output = mantissa_output << 1;
                            exp_output = exp_output - 1;
                        end

                        data_out = {sign_output,exp_output,mantissa_output[22:0]};

                    end
                end
                // data_out = data_in1;
            end

            ROUND_F:
            begin
                exp_input2 = exp_input1 - 127;
                if(exp_input1 < 126)
                    data_out = 0;

                else
                begin
                    if(exp_input1 > 149)
                        data_out = data_in1;

                    else
                    begin
                        if(exp_input1 == 126)
                        begin
                            if(mantissa_input1[23])
                                data_out = {sign_input1, 8'b01111111, 23'b0};
                            else
                                data_out = 0;
                        end

                        else
                        begin
                            if(mantissa_input1[22 - exp_input2])
                            begin
                                mantissa_input2 = 0;
                                mantissa_input2[22 - exp_input2] = 1;
                                mantissa_output = mantissa_input1 + mantissa_input2;
                                mantissa_output = mantissa_output >> 22 - exp_input2;
                                mantissa_output = mantissa_output << 22 - exp_input2;
                                sign_output = sign_input1;
                                exp_output = exp_input1;

                                if(mantissa_output[24])
                                begin
                                    mantissa_output = mantissa_output >> 1;
                                    exp_output = exp_output + 1;
                                end
                            end

                            else
                            begin
                                mantissa_output = mantissa_input1;
                                mantissa_output = mantissa_output >> 22 - exp_input2;
                                mantissa_output = mantissa_output << 22 - exp_input2;
                                sign_output = sign_input1;
                                exp_output = exp_input1;
                            end
                            data_out = {sign_output,exp_output,mantissa_output[22:0]};
                        end
                    end
                end
            end

            SLT_F:
            begin
                if (sign_input1 > sign_input2)
                        data_out = 1;

                if (sign_input1 < sign_input2)
                        data_out = 0;

                if (sign_input1 == 0)
                begin
                    if (exp_input1 < exp_input2)
                        data_out = 1;
                    if (exp_input1 > exp_input2)
                        data_out = 0;
                    else
                    begin
                        if (mantissa_input1 < mantissa_input2)
                            data_out = 1;
                        else
                            data_out = 0;
                    end
                end
                else
                begin
                    if (exp_input1 > exp_input2)
                        data_out = 1;
                    if (exp_input1 < exp_input2)
                        data_out = 0;
                    else
                    begin
                        if (mantissa_input1 > mantissa_input2)
                            data_out = 1;
                        else
                            data_out = 0;
                    end
                end
            end

            INVRS_F:
            begin
                sign_input1 = 0;
                sign_input2 = data_in1[31];

                exp_input1 = 8'b01111111;
                exp_input2 = data_in1[30 : 23];

                mantissa_input1 = 25'd0;
                mantissa_input2 = {2'b00, data_in1[22 : 0]};
                mantissa_input1[23] = 1;
                mantissa_input2[23] = 1;

                if(data_in1 == 0)
                    division_by_zero = 1;

                else
                begin
                    if(data_in1 == 0)
                        data_out = 0;

                    else
                    begin
                        sign_output = sign_input1 ^ sign_input2;
                        mantissa_output = 25'b0;

                        if(mantissa_input1 > mantissa_input2)
                        begin
                            mantissa_output[23] = mantissa_input1[0];
                            mantissa_input1 = mantissa_input1 >> 1;
                            exp_input1 = exp_input1 + 1;
                        end

                        exp_output = exp_input1 - exp_input2 + 126;

                        {dummy, mantissa_output} = {mantissa_input1[23 : 0],mantissa_output[23 : 0]} / {24'b0, mantissa_input2[23 : 0]};

                        while(mantissa_output[23] != 1)
                        begin
                            mantissa_output = mantissa_output << 1;
                            exp_output = exp_output - 1;
                        end

                        data_out = {sign_output,exp_output,mantissa_output[22:0]};

                    end
                end
            end

            default: data_out = 0;
        endcase
    end

endmodule
