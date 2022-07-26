module WB(
    register_src,
    fregister_src_wb,
    frs_data_wb,
    frt_data_wb,
    rs_data_wb,
    rt_data_wb,
    rd_data,
    frd_data,
    rd_num_in,
    is_word,
    cache_data_out,
    inst_addr,
    ALU_result,
    fALU_result_wb,
    byte_number,
    halted_controller,
    clk
);

    input [1:0] register_src;
    input [1:0] fregister_src_wb;
    input [4:0] rd_num_in;
    input is_word;
    input [31:0] inst_addr;
    input [31:0] ALU_result;
    input [31:0] fALU_result_wb;
    input [31:0] frs_data_wb;
    input [31:0] frt_data_wb;
    input [31:0] rs_data_wb;
    input [31:0] rt_data_wb;
    input [7:0] cache_data_out[0:3];
    input [1:0] byte_number;
    input halted_controller;
    input clk;

    output reg [31:0] rd_data;
    output reg [31:0] frd_data;

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
                2'b11: rd_data = fALU_result_wb;
                default:
                    rd_data = ALU_result;
            endcase

            case (fregister_src_wb)
                2'b00: frd_data = fALU_result_wb;
                2'b01: frd_data = rs_data_wb;
                2'b10: // memory
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
                default: frd_data = fALU_result_wb;
            endcase
        end

    // always $display("time: %d, ALU_result_out_wb: %d, rd_data: %d, halted: %b", $time, ALU_result, rd_data, halted_controller);

endmodule