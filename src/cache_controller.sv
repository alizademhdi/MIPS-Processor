module CacheController(
    opcode,
    cache_hit,
    cache_dirty,
    we_memory,
    we_cache,
    cache_input_type,
    memory_address_type,
    is_word,
    register_write,
    lock,
    set_dirty,
    set_valid,
    pc_enable,
    clk
);

    input wire [5:0] opcode;
    input wire cache_hit;
    input wire cache_dirty;
    input clk;

    output reg we_memory;
    output reg we_cache;
    output reg cache_input_type;
    output reg memory_address_type;
    output reg is_word;
    output reg register_write;
    output reg lock;
    output reg set_dirty;
    output reg set_valid;
    output reg pc_enable;

    parameter LW_code = 6'b100011;
    parameter SW_code = 6'b101011;
    parameter LB_code = 6'b100000;
    parameter SB_code = 6'b101000;

    reg [3:0] p_state = S0;
    reg [3:0] n_state;

    parameter S0    = 4'b0000;
    parameter S1    = 4'b0001;
    parameter S2    = 4'b0010;
    parameter S3    = 4'b0011;
    parameter S4    = 4'b0100;
    parameter S5    = 4'b0101;
    parameter S6    = 4'b0110;
    parameter S7    = 4'b0111;
    parameter S8    = 4'b1000;
    parameter S9    = 4'b1001;
    parameter S10   = 4'b1010;
    parameter S11   = 4'b1011;
    parameter S12   = 4'b1100;

    always @(posedge clk)
    begin
        p_state <= n_state;
    end

    always_latch @(p_state or opcode)
    begin
        we_memory <= 1'b0;
        we_cache <= 1'b0;
        cache_input_type <= 1'b1;
        is_word <= (opcode == LW_code) || (opcode == SW_code);

        case (p_state)
            S0: begin
                // start of lw
                if (opcode == LW_code || opcode == LB_code) begin
                    if (cache_hit) begin
                        n_state <= S0;
                        register_write <= 1'b1;
                        pc_enable <= 1'b1;
                    end
                    else begin
                        pc_enable <= 1'b0;
                        register_write <= 1'b0;
                        if (cache_dirty) begin
                            we_memory <= 1'b1;
                            n_state <= S6;
                            memory_address_type <= 1'b1;
                        end
                        else begin
                            n_state <= S1;
                        end
                    end
                end
                // start of sw
                else if (opcode == SW_code || opcode == SB_code) begin
                    if (cache_dirty & ~cache_hit) begin
                        n_state <= S1;
                        we_memory <= 1'b1;
                        pc_enable <= 1'b0;
                        memory_address_type <= 1'b1;
                    end
                    else begin
                        we_cache <= 1'b1;
                        pc_enable <= 1'b1;
                        cache_input_type <= 1'b1;
                        set_dirty <= 1'b1;
                        set_valid <= 1'b1;
                        n_state <= S0;
                    end
                end
                else begin
                    n_state <= S0;
                    pc_enable <= 1'b1;
                end
            end

            S1: begin
                n_state <= S2;
                if (opcode == LW_code || opcode == LB_code) begin
                    memory_address_type <= 1'b0;
                end
                else if (opcode == SW_code || opcode == SB_code) begin
                    cache_input_type <= 1'b0;
                end
            end

            S2: begin
                n_state <= S3;
            end

            S3: begin
                n_state <= S10;
            end

            S4: begin
                if (opcode == LW_code || opcode == LB_code) begin
                    we_cache <= 1'b1;
                    is_word <= 1'b1;
                    cache_input_type <= 1'b0;
                    set_valid <= 1'b1;
                    set_dirty <= 1'b0;
                    n_state <= S11;
                end
                else if (opcode == SW_code || opcode == SB_code) begin
                    we_cache <= 1'b1;
                    n_state <= S0;
                    set_valid <= 1'b1;
                    set_dirty <= 1'b1;
                    pc_enable <= 1'b1;
                end
            end

            S5: begin
                if (opcode == LW_code || opcode == LB_code) begin
                    register_write <= 1'b1;
                    pc_enable <= 1'b1;
                    n_state <= S0;
                end
            end

            S6: begin
                n_state <= S7;
            end

            S7: begin
                n_state <= S8;
            end

            S8: begin
                n_state <= S9;
            end

            S9: begin
                n_state <= S1;
            end

            S10: begin
                n_state <= S4;
            end

            S11: begin
                register_write <= 1'b1;
                pc_enable <= 1'b1;
                n_state <= S0;
            end

            default: n_state <= S0;
        endcase
    end

    // always $display("time: %d, cache_input_type: %b", $time, cache_input_type);

endmodule