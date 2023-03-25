module MMS_8num(result, select, number0, number1, number2, number3, number4, number5, number6, number7);

input        select;
input  [7:0] number0;
input  [7:0] number1;
input  [7:0] number2;
input  [7:0] number3;
input  [7:0] number4;
input  [7:0] number5;
input  [7:0] number6;
input  [7:0] number7;
output reg [7:0] result;

wire [7:0] MMS4_res1;
wire [7:0] MMS4_res2;

MMS_4num MMS4_1 (MMS4_res1, select, number0, number1, number2, number3); 
MMS_4num MMS4_2 (MMS4_res2, select, number4, number5, number6, number7);  

always @(*) begin 
	if (select == 1) begin
        // Find the minimum
		result = (MMS4_res1 < MMS4_res2)? MMS4_res1 : MMS4_res2;
    end else begin
        // Find the maximum
		result = (MMS4_res1 > MMS4_res2)? MMS4_res1 : MMS4_res2;
    end
end

endmodule

module MMS_4num(result, select, number0, number1, number2, number3);

	input        select;
	input  [7:0] number0;
	input  [7:0] number1;
	input  [7:0] number2;
	input  [7:0] number3;
	output reg [7:0] result; 

always @(*) begin
    if (select == 1) begin
        // Find the minimum
		result = (number0 < number1)? number0 : number1;
		result = (result < number2)? result : number2;
		result = (result < number3)? result : number3;
    end else begin
        // Find the maximum
		result = (number0 > number1)? number0 : number1;
		result = (result > number2)? result : number2;
		result = (result > number3)? result : number3;
    end
end

endmodule
