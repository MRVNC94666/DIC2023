# DIC2023 HW1 : Max-Min Selector
###### tags: `dic2023`

## ***Goal***
&emsp;&emsp;The Max-Min selector (MMS) is a combinational circuit that can output the maximum or minimum value of a set of numbers. In this homework, you are required to design a 4-input MMS circuit, which determines the maximum or minimum value among four input numbers. The 4-input MMS circuit is then used to constitute an 8-input MMS circuit. The specifications and function of the 4-input MMS and the 8-input MMS are detailed in the following sections. 

### **The 4-input MMS**
&emsp;&emsp;The logic diagram of the 4-input MMS for this homework is shown in Fig. 1, and its specifications of I/O interface is listed in Table I. Two-staged comparison and selection operation is adopted to select the maximum or minimum value among 4 numbers. The selection of the multiplexers is based on the comparison result and the select signal. The comparison and selection operation is shown in Fig. 2, and Table II lists all the selection cases of the multiplexers.

![](https://i.imgur.com/0oHliw5.png)

![](https://i.imgur.com/wD0TUYS.png)

### **The 8-input MMS**
&emsp;&emsp;The logic diagram of the 8-input MMS for this homework is shown in Fig. 3, 
and its specifications of I/O interface is listed in Table III. In this homework, you must construct the 8-input MMS circuit with your 4-input MMS modules. Two 4-input MMS modules are used to select the maximum/minimum value among numbers 0~3 and numbers 4~7, respectively. A comparison and selection operation is adopted to determine the final result of the 8-input MMS. 

![](https://i.imgur.com/yfq8Rys.png)

## ***Thinking process***
4MMS的部分，利用`if/else`切割求max和求min的情形，而statement內就逐一比大小，max部分最終會由最大的(若相等就排序較小的)input來作為result output。
而8MMS的部分就照作業要求提供的方法，把兩個4MMS出來的值依照select的情況，再做一次比較並輸出最大或最小值。

## ***Code***

### **4-input MMS**

```verilog=
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
```
### 8-input MMS

```verilog=
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

```
