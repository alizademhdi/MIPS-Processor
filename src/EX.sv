module EX(
);
always @(inst)
    begin

        case (destination_register)
            2'b00: rd_num = inst[20:16];
            2'b01: rd_num = inst[15:11];
            2'b10: rd_num = 5'b11111;
            default:
                rd_num = inst[20:16];
        endcase

    end
endmodule