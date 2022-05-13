module fulladder(
    sum,
    carry_out,
    number_1,
    number_2,
    carry_in
  );

    input [31:0] number_1;
    input [31:0] number_2;
    input carry_in; 

    output [31:0] sum;
    output carry_out;

    wire [31:0] sum;
    wire [31:0] carry;
    wire [31:0] number;

    assign number = (carry_in == 1'b0) ? number_2 : ~number_2;

    genvar i;
    generate
    
    for(i=0; i<=31; i=i+1)
    begin
        if(i==0) 
        begin
            assign sum[i] = (number_1 ^ number_2) ^ carry_in;
            assign carry[i] = (number_1 & carry_in) | (number_1 & number_2) | (number_2 & carry_in);  
        end  
        else
        begin
            assign sum[i] = (number_1 ^ number_2) ^ carry[i-1];
            assign carry[i] = (number_1 & carry[i-1]) | (number_1 & number_2) | (number_2 & carry[i-1]); 
        end 
    end

    endgenerate

    assign carry_out = carry[31];
  
  endmodule