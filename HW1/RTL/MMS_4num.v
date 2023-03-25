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