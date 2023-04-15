# DIC2023 HW1 : Max-Min Selector
###### tags: `dic2023`

## ***Problem***
### **Introduction**
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
&emsp;以cmp0~2來紀錄3個小於比較器的結果，並以三條wire來記錄三個比較器的輸出。而這三個比較器輸出以case的方式來寫，`{select, cmp}`將的四種結果對應到比較器輸出要輸出哪一個number訊號，前兩個將輸出以`mux0`和`mux1`輸出給第三個比較器，第三個比較器的輸出就會是直接改變`result`那條wire。

++**心得**++
&emsp;一開始對verilog編寫還不熟，只要接wire就非常容易出錯，後來有利用if/else的方式達成作業tb的模擬，但考慮到這樣並不是比較合適的電路設計，就還是以作業要求寫了一次並成功完成模擬。其實我花了很多時間在嘗試利用dataflow的方式來達成，但我發現，要以更接近structure描述的方式來設計電路的話對RTL coding的熟悉度要求更高一些。
&emsp;這次花了很多時間在解決無法讀取檔案的error，後來是上網查別人的作法是把所有要用的檔案放在與modelsim.exe同一個目錄下(C:\intelFPGA\20.1\modelsim_ase\win32aloem)，才能成功開始模擬，並知道我的code有沒有寫對。
&emsp;還有我利用`include “MMS_4num.v”`的方式加入4-MMS的module也沒有成功，後來是直接把MMS_4num.v的code複製到MMS_8num.v內才成功all pass。
&emsp;後來經過重新創建project，才能順利在自己創的作業資料夾內完成模擬。
&emsp;經過這次作業，儘管對Verilog還是很陌生，過程也跌跌撞撞，但模擬完all pass還是蠻開心的，希望以後能從數位IC設計菜雞變成至少略知一二的正常人。

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

reg [7:0] mux0;
reg [7:0] mux1;

wire cmp0 = number0 < number1;
wire cmp1 = number2 < number3;
wire cmp2 = mux0 < mux1;


always @(*) 
begin
    case({select, cmp0})
		2'b00: mux0 = number0;
		2'b01: mux0 = number1;
		2'b10: mux0 = number1;
		2'b11: mux0 = number0;
	endcase    
end

always @(*)
begin
	case({select, cmp1})
		2'b00: mux1 = number2;
		2'b01: mux1 = number3;
		2'b10: mux1 = number3;
		2'b11: mux1 = number2;
	endcase
end

always @(*)
begin
	case({select, cmp2})
		2'b00: result = mux0;
		2'b01: result = mux1;
		2'b10: result = mux1;
		2'b11: result = mux0;
	endcase
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
```