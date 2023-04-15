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

wire [7:0] MMS4_0_res;
wire [7:0] MMS4_1_res;
wire cmp = MMS4_0_res < MMS4_1_res;

MMS_4num MMS4_0 (MMS4_0_res, select, number0, number1, number2, number3); 
MMS_4num MMS4_1 (MMS4_1_res, select, number4, number5, number6, number7); 

always @(*) 
begin
	case({select, cmp})
		2'b00: result = MMS4_0_res;
		2'b01: result = MMS4_1_res;
		2'b10: result = MMS4_1_res;
		2'b11: result = MMS4_0_res;
	endcase
end

endmodule
