module ALUcontroller(
    control,
    func,
    aluOP,
);

    input wire [1:0] aluOp;
    input wire [5:0] func;

    output reg [3:0] control;

    parameter XOR_case = 6'b100110;
    parameter SLL_case = 6'b000000;
    parameter SLLV_case = 6'b000100;
    parameter SRL_case = 6'b000010;
    parameter SUB_case = 6'b100010;
    parameter SRLV_case = 6'b000110;
    parameter SLT_case = 6'b101010;
    parameter SYSCALL_case = 6'b101010;
    parameter SUBU_case = 6'b100011;
    parameter OR_case = 6'b100101;
    parameter NOR_case = 6'b100111;
    parameter ADDU_case = 6'b100001;
    parameter MULT_case = 6'b011000;
    parameter DIV_case = 6'b011010;
    parameter AND_case = 6'b100100;
    parameter ADD_case = 6'b100000;
    parameter JR_case = 6'b001000;
    parameter SRA_case = 6'b000011;

    reg [3:0] temp;

    always @ (func)
    begin
        case(func)
            XOR_case: temp = 4'b0000;
            SLL_case: temp = 4'b0001;
            SLLV_case: temp = 4'b0001;
            SRL_case: temp = 4'b0010;
            SRLV_case: temp = 4'b0010;
            SRA_case: temp = 4'b0011;
            ADD_case: temp= 4'b0100;
            ADDU_case: temp= 4'b0100;
            SUB_case: temp = 4'b0101;
            SUBU_case: temp = 4'b0101;
            MULT_case: temp = 4'b0110;
            DIV_case: temp = 4'b0111;
            OR_case: temp = 4'b1000;
            NOR_case: temp = 4'b1001;
            AND_case: temp = 4'b1010;
            SLT_case: temp = 4'b1011;
            JR_case: temp = 4'b1100;
            default: temp = 4'b0100;
        endcase
    end


    always @ (aluOP)
    begin
        case(aluOP)
            2'b00: control = 4'b0100; //SW and LW 
            2'b01: control = 4'b1101; //BEQ
            2'b10: control = 4'b1110; //BNE
            2'b11: control = temp;  //R tupe
            default: control = 4'b0100;
        endcase
    end

endmodule
    
   
    
    
    