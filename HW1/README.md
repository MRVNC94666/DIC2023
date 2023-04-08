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
&emsp;我的設計是比較直觀的，4-MMS一開始先以if else的方式判斷select，確認要找最大值還是最小值後，就以簡單的 ( ) ? ( ) : ( ) 運算來逐一比大小，8-MMS的部分則是利用4-MMS的實體來計算兩個結果(前四與後四個輸入)，接著就一樣以if/else來區分select，然後以condition運算來比較。
&emsp;其實我花了很多時間在嘗試利用case的方式或利用dataflow的方式來達成，但我發現只要需接wire就非常容易出錯，要以更接近structure描述的方式來設計電路的話對RTL coding的熟悉度要求更高一些，所以我最終沒能在時間內設計出更好的電路，只能用比較接近在寫C語言的方式來達成目的，這點希望以後能夠進步，不然我想這次設計的IC對於Min Max Selection來說成本應該有點浪費。
/* 心得 */
&emsp;這次花了很多時間在解決無法讀取檔案的error，後來是上網查別人的作法是把所有要用的檔案放在與modelsim.exe同一個目錄下(C:\intelFPGA\20.1\modelsim_ase\win32aloem)，才能成功開始模擬，並知道我的code有沒有寫對。
&emsp;還有我利用`include “MMS_4num.v”`的方式加入4-MMS的module也沒有成功，後來是直接把MMS_4num.v的code複製到MMS_8num.v內才成功all pass。
&emsp;經過這次作業，儘管對Verilog還是很陌生，過程也跌 跌撞撞，但模擬完all pass還是蠻開心的，希望以後能從數位IC設計菜雞變成至少略知一二的正常人。

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
