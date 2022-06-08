module Cache (
    cache_hit,
    cache_dirty,
    data_out,
    memory_write_address,
    we_cache,
    cache_addr,
    data_in,
    set_valid,
    set_dirty,
    clk
);
    output wire cache_hit;
    output wire cache_dirty;
    output wire [7:0] data_out[0:3];
    output wire [31:0] memory_write_address;

    input wire [31:0] cache_addr;
    input wire [31:0] data_in;
    input wire set_valid;
    input wire set_dirty;
    input wire we_cache;
    input wire clk;


    parameter size = 64;
    reg [31:0] cache[0:size - 1];
    reg [9:0] tag_array [0:size - 1];
    reg valid_array [0:size - 1];
    reg dirty_array [0:size - 1];

    initial
	begin: initialization
		integer i;
		for (i = 0; i < size; i = i + 1)
		begin
			valid_array[i] = 1'b0;
            dirty_array[i] = 1'b0;
			tag_array[i] = 10'b0000000000;
		end
	end

    assign cache_hit = valid_array[cache_addr[5:0]] & (cache_addr[15:6] == tag_array[cache_addr[5:0]]);
    assign cache_dirty = dirty_array[cache_addr[5:0]];

    assign data_out[0] = cache[cache_addr[5:0]][7:0];
    assign data_out[1] = cache[cache_addr[5:0]][15:8];
    assign data_out[2] = cache[cache_addr[5:0]][23:16];
    assign data_out[3] = cache[cache_addr[5:0]][31:24];

    assign memory_write_address = {16'b0, tag_array[cache_addr[5:0]], cache_addr[5:0]};

    always @(posedge clk)
    begin
        if (we_cache) begin
            cache[cache_addr[5:0]] <= data_in;
            tag_array[cache_addr[5:0]] <= cache_addr[15:6];
        end

        if(set_valid == 1)
            valid_array[cache_addr[5:0]] <= 1'b1;
        else
            valid_array[cache_addr[5:0]] <= 1'b0;

        if(set_dirty == 1)
            dirty_array[cache_addr[5:0]] <= 1'b1;
        else
            dirty_array[cache_addr[5:0]] <= 1'b0;
    end

    integer j;

    always @(*) begin
        for (j = 0; j < size; j = j + 1) begin
            $display("tag: %b, valid: %b, dirty: %b, word: %h",
                tag_array[j],
                valid_array[j],
                dirty_array[j],
                cache[j]
            );
        end
    end

endmodule