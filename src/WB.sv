module WB(
    register_src,
    rd_data,
    rd_num_in,
    rd_num_out,
    is_word,
    cache_data_out,
    inst_addr,
    ALU_result,
    byte_number,
    halted_controller,
    halted,
    clk
);

    input [1:0] register_src;
    input [4:0] rd_num_in;
    input is_word;
    input [31:0] inst_addr;
    input [31:0] ALU_result;
    input [7:0] cache_data_out[0:3];
    input [1:0] byte_number;
    input halted_controller;
    input clk;

    output reg [31:0] rd_data;
    output [4:0] rd_num_out;
    output halted;

    assign rd_num_out = rd_num_in;
    assign halted = halted_controller;

    always @(*)
        begin

            case (register_src)
                2'b00: rd_data = ALU_result;
                2'b01:
                begin
                    if(is_word)
                        rd_data = {cache_data_out[3], cache_data_out[2], cache_data_out[1], cache_data_out[0]};
                    else begin
                        case (byte_number)
                            2'b00: rd_data = {{24{cache_data_out[3][7]}}, cache_data_out[3]};
                            2'b01: rd_data = {{24{cache_data_out[2][7]}}, cache_data_out[2]};
                            2'b10: rd_data = {{24{cache_data_out[1][7]}}, cache_data_out[1]};
                            2'b11: rd_data = {{24{cache_data_out[0][7]}}, cache_data_out[0]};
                            default: rd_data = {{24{cache_data_out[0][7]}}, cache_data_out[0]};
                        endcase
                    end

                end
                2'b10: rd_data = inst_addr + 4;
                default:
                    rd_data = ALU_result;
            endcase

        end
    endmodule