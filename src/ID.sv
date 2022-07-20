module ID(
    mem_write_en,
    halted,
    pc4_out,
    pc4_in,
    inst_addr,
    mem_addr,
    inst,
    register_write,
    rt_data,
    jump,
    clk,
    rst_b
);

    input   [31:0] inst;
    input   [31:0] pc4_in;
    input          clk;
    input          rst_b;
    input          register_write;
    input   [31:0] rt_data; // write data

    output      [31:0] inst_addr;
    output reg  [31:0] mem_addr;
    output      [31:0] pc4_out;
    output         mem_write_en;
    output reg     halted;
    output reg     jump;

    assign pc4_out = pc4_in;
    // halted
    always @(inst)
    begin
        if(inst == 32'h000c)
            halted = 1;
        else
            halted = 0;
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

    // Create imm extender
    reg [31:0] imm_extend;

    Extender sign_extender(
        .num(inst[15:0]),
        .extended(imm_extend),
        .is_unsign_extend(is_unsigned)
    );


    endmodule
