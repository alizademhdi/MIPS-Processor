module Cache (
    cache_hit,
    cache_dirty,
    data_out,
    memory_write_address,
    byte_number,
    we_cache,
    cache_addr,
    data_in,
    set_valid,
    set_dirty,
    is_word,
    clk
);
    output wire cache_hit;
    output wire cache_dirty;
    output wire [7:0] data_out[0:3];
    output wire [31:0] memory_write_address;
    output wire [1:0] byte_number;

    input wire [31:0] cache_addr;
    input wire [31:0] data_in;
    input wire set_valid;
    input wire set_dirty;
    input wire we_cache;
    input wire is_word;
    input wire clk;


    parameter size = (1<<11);
    reg [31:0] cache[0:size - 1];
    reg [2:0] tag_array [0:size - 1];
    reg valid_array [0:size - 1];
    reg dirty_array [0:size - 1];

    initial
	begin: initialization
		integer i;
		for (i = 0; i < size; i = i + 1)
		begin
			valid_array[i] = 1'b0;
            dirty_array[i] = 1'b0;
			tag_array[i] = 3'b000;
		end
	end

    wire [10:0] block_addr;
    assign block_addr = cache_addr[12:2];

    assign byte_number = cache_addr[1:0];

    assign cache_hit = valid_array[block_addr] & (cache_addr[15:13] == tag_array[block_addr]);
    assign cache_dirty = dirty_array[block_addr];

    assign data_out[0] = cache[block_addr][7:0];
    assign data_out[1] = cache[block_addr][15:8];
    assign data_out[2] = cache[block_addr][23:16];
    assign data_out[3] = cache[block_addr][31:24];

    assign memory_write_address = {16'b0, tag_array[block_addr], block_addr, 2'b0};

    always @(posedge clk)
    begin
        if (we_cache) begin
            if(is_word) begin
                $display("shit");
                cache[block_addr] <= data_in;
                tag_array[block_addr] <= cache_addr[15:13];
            end
            else begin
                case (byte_number)
                    2'b00: cache[block_addr] <= {data_in[7:0], cache[block_addr][23:0]};
                    2'b01: cache[block_addr] <= {cache[block_addr][31:24], data_in[7:0], cache[block_addr][15:0]};
                    2'b10: cache[block_addr] <= {cache[block_addr][31:16], data_in[7:0], cache[block_addr][7:0]};
                    2'b11: cache[block_addr] <= {cache[block_addr][31:8], data_in[7:0]};
                    default: cache[block_addr] <= 32'b0;
                endcase
                tag_array[block_addr] <= cache_addr[15:13];
            end
        end

        if(set_valid == 1)
            valid_array[block_addr] <= 1'b1;
        else
            valid_array[block_addr] <= 1'b0;

        if(set_dirty == 1)
            dirty_array[block_addr] <= 1'b1;
        else
            dirty_array[block_addr] <= 1'b0;
    end

endmodule