module mips_core_v0(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);


    input   [31:0] inst;
    input   [7:0]  mem_data_out[0:3];
    input          clk;
    input          rst_b;

    output      [31:0] inst_addr;
    output reg  [31:0] mem_addr;
    output      [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;

    assign mem_data_in[0] = cache_data_out[0];
    assign mem_data_in[1] = cache_data_out[1];
    assign mem_data_in[2] = cache_data_out[2];
    assign mem_data_in[3] = cache_data_out[3];


    // halted

    always @(inst)
    begin
        if(inst == 32'h000c)
            halted = 1;
        else
            halted = 0;
    end


    // Create Controller

    wire [1:0] destination_register; // 01 for rd and 00 for rt and 10 for ra
    wire jump;
    wire branch;
    wire jump_register;
    wire [1:0] register_src;
    wire [4:0] ALU_OP;
    wire ALU_src;
    wire register_write;
    wire is_unsigned;
    wire pc_enable;
    wire we_cache;
    wire cache_input_type;
    wire set_dirty;
    wire set_valid;
    wire memory_address_type;
    wire is_nop;

    Controller controller(
        .destination_register(destination_register),
        .jump(jump),
        .branch(branch),
        .jump_register(jump_register),
        .we_memory(mem_write_en),
        .register_src(register_src),
        .ALU_OP(ALU_OP),
        .ALU_src(ALU_src),
        .register_write(register_write),
        .is_unsigned(is_unsigned),
        .pc_enable(pc_enable),
        .opcode(inst[31:26]),
        .we_cache(we_cache),
        .cache_input_type(cache_input_type),
        .memory_address_type(memory_address_type),
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .set_dirty(set_dirty),
        .set_valid(set_valid),
        .is_word(is_word),
        .is_nop(is_nop),
        .func(inst[5:0]),
        .clk(clk)
    );

    always @(memory_address_type)
    begin
        if (memory_address_type) begin
            mem_addr = memory_write_address;
        end
        else begin
            mem_addr = ALU_result;
        end
    end


    // Create cache

    wire cache_hit;
    wire cache_dirty;
    wire [31:0] memory_write_address;
    wire [7:0] cache_data_out [0:3];
    reg [31:0] cache_data_in;
    wire is_word;
    wire [1:0] byte_number;

    Cache cache(
        .cache_hit(cache_hit),
        .cache_dirty(cache_dirty),
        .data_out(cache_data_out),
        .memory_write_address(memory_write_address),
        .byte_number(byte_number),
        .we_cache(we_cache),
        .cache_addr(ALU_result),
        .data_in(cache_data_in),
        .set_valid(set_valid),
        .set_dirty(set_dirty),
        .is_word(is_word),
        .clk(clk)
    );

    always @(cache_input_type)
    begin
        if(cache_input_type == 1'b0)
        begin
            cache_data_in = {mem_data_out[3], mem_data_out[2], mem_data_out[1], mem_data_out[0]};
        end
        else
            cache_data_in = rt_data;
    end


    // Create register file

    wire [31:0] rs_data;
    wire [31:0] rt_data;
    reg [31:0] rd_data;
    reg [4:0] rd_num;

    regfile regs(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(register_write),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

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


    // Create imm extender

    reg [31:0] imm_extend;

    Extender sign_extender(
        .num(inst[15:0]),
        .extended(imm_extend),
        .is_unsign_extend(is_unsigned)
    );


    // Create ALU

    wire [31:0] ALU_result;
    reg [31:0] data_in2;
    wire zero;

    ALU alu(
        .data_out(ALU_result),
        .zero(zero),
        .ALU_OP(ALU_OP),
        .data_in1(rs_data),
        .data_in2(data_in2),
        .shift_amount(inst[10:6])
    );

    always @(ALU_src)
    begin
        if (ALU_src) begin
            data_in2 = imm_extend;
        end else
            data_in2 = rt_data;
    end


    // Create PC controller
    pc_controller pc_controller(
        .pc(inst_addr),
        .jea(inst[25:0]),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .rs_data(rs_data),
        .imm_sign_extend(imm_extend),
        .zero(zero),
        .pc_enable(pc_enable),
        .is_nop(is_nop),
        .clk(clk)
    );

endmodule
