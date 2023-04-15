# Digital IC Design Note by ***MWChang***
###### tags: `dic2023`

:pushpin: 此repo記錄本人修習國立成功大學資工所陳培殷老師的「數位IC設計」課程之作業內容以及一些基礎章節的筆記。

---
## **0. Homeworks**
- [*Homework 1: Max-Min Selector*](https://hackmd.io/@mwchangworkin/r1gVLQQgn)
- [*Homework 2: Rails*](https://hackmd.io/@mwchangworkin/HyfITQyM3)
- [*Homework 3:  Arithmetic Expression Calculator*]()

---
## **1. Introdution**
&emsp;科技的應用無非是要解決特定的問題，而若是要以演算法去解決問題，最後必定要開發出硬體來執行寫出來的program，常見的手法便包含般偏的軟體solution，使用CPU來執行寫好的program，有比較好的編程彈性；又或是直接做出專用電路(dedicated circuit)來跑這樣的演算法；介於中間的，就是現在常見的電路結合程式的solution。
#### **電路與程式的結合，較常見有兩種實現方式** :
1. **System on a board** : 在開發板上透過嵌入式的系統，結合特殊應用積體電路(ASIC)，來達成特殊case的solution。(如下[Fig-1.1])
2. **System on a chip (SoC)** : 把原本在開發板上的每個元件都包單一IC晶片上。

![Fig-1.1](https://i.imgur.com/tbRcWwg.png)
&emsp;&emsp;Fig-1.1 Sytem on board example.

如何透過IC設計將晶片的功能寫好，且壓低成本，提高效能表現，將會是最重要的課題。

### **1.1 Digital System**
&emsp;本節由小而大的來簡介一個數位系統。系統中最小的單位就是電晶體(transistor)，電晶體的角色為承載訊息的元件，通常以半導體來製作，而數個電晶體可以製作成邏輯閘 (gate)，進而根據規則來傳遞訊號，而利用數個邏輯閘可以組合成一個數位系統包含的電路 (digital circuit)，這樣的可以接受 0或1的input，根據邏輯閘的規則給予output(邏輯閘相關背景知識詳見 B1. 數位邏輯 )，如Fig-1.2中框框內的電路，而數個電路連在一起就是所謂的IC(integrated circuit)。

![](https://i.imgur.com/3zyl9LM.png)
&emsp;&emsp;Fig-1.2 IC架構

&emsp;這樣的IC可以用 HDL (Hardware Description Language, 硬體描述語言) 來編寫，進而透過tools合成 (Synthesis)電路，HDL包括Verilog和VHDL，在台灣超過九成的企業都習慣用Verilog來編寫。
&emsp;而經由IC設計，將數個IC組成不同的特殊應用積體電路 (ASIC) 來提供各式功能，由這些 ASIC 和記憶體等元件可以組成負責系統中不同角色的PCB(printed circuit board, 印刷電路板)，最後多個PCB組合而成的系統就可以實現各個case的需求(整體架構如Fig.1-3所示)。

![](https://i.imgur.com/KCCurgn.png)
&emsp;&emsp;Fig-1.3 數位系統細節架構

### **1.2 IC Industry**
&emsp;由於技術的演進，目前市面上的IC設計已經可以達到包含數萬個元件的 VLSI (超大型積體電路) 或集數百萬個元件於一身的 SoC (單晶片系統) 規模。

#### **IC分類與發展年代如下 :**

- 1970s~ SSI (Small-Scaled Integrated Circuits) : 小型積體電路→含數十個元件
- 1970s~ MSI (Medium-Scaled IC) : 中型積體電路→含數百個元件
- 1980s~ LSI (Large-Scaled IC) : 大型積體電路→含數千個元件
- 1990s~ VLSI (Very Large Scaled IC) : 超大型積體電路→含數萬個元件
- 2000s~ SoC (System on a Chip) : 單晶片系統→含數百萬個元件

&emsp;而台灣的IC產業鏈如Fig-1.4所示，先由聯發科(MediaTek)、聯詠(Novatek)、瑞昱 (Realtek)等IC設計公司設計好晶片後交由台積電(TSMC)、聯電(UMC) 等半導體代工廠進行生產，代工廠依據設計好的電路和邏輯閘來客光罩，刻好之後便將原料加工製造成ASIC晶片，最終進行封裝、測試。

![](https://i.imgur.com/FeiKnwP.png)
&emsp;&emsp;Fig-1.4 台灣IC產業鏈

---

## **2. Semi Custom Design Flow**

#### **IC design flow 大約分為兩種類型 :**
1. **Full Custom Design 全客戶設計** : 大部分的步驟都由工程師自己做，設計時間成本高，但可以做到較活耀的客製化要求，類比電路以及小的數位電路可用此法。(ASIC)
2. **Semi Custom Design 半客戶設計** : 用來設計較大的數位電路，又稱作「cell-based design」，引入代工廠的cell，透過tool來做設計。
&emsp;- **Standard Cells** : TSMC, UMC -cells (ASIC)
&emsp;- **FPGA/PLD** : Xilinx, Altera -cells (PLD)

&emsp;本章節重點在描述各種Semi Custom Design的流程，下Fig-2.1展示了IC設計的流程分層圖，從最上層的系統概念開始往下走，由概念設計出演算法；再由演算法把架構畫出來；然後就到了RTL Coding的環節，也就是要利用Verilog來寫出IC架構；接著，利用tool將寫好的code轉成邏輯閘；最後再透過tool轉成電晶體。

![](https://i.imgur.com/i620OQu.png)
&emsp;&emsp;Fig-2.1 IC設計分層

&emsp;整體來說，越往上層的設計越偏向行為摘要的敘述，而越往下層就越細節，更接近真實電路。

### **2.1 Design Flow**
##### A. Product specification 制定規格
##### B. Modeling with HDL 透過硬體描述語言建模 
##### C. Synthesis with standard cells 利用套件合成電路
##### D. Simulation and verification 模擬及驗證
##### E. Physical placement and layout 物理佈局(透過Fab，即半導體製造廠)
##### F. Tape-out (real chip) 生產、製造、封裝及下線
##### G. Testing 測試
##### `註` C、D、E 、G 可以透過 tool 實現，F 則可交由 Fab 實現。
##### `註` C、D、E、F 階段又可以分為兩種 solutions :
###### &emsp;1. Standard Cell : Real **ASIC** chip → TSMC, UMC … 
###### &emsp;2. PLD : **FPGA/CPLD** → Xilinx, Altera …

### **2.2 Synthesis Flow**

![](https://i.imgur.com/EIXTbF8.png)
&emsp;&emsp;Fig-2.2 ASIC 設計流程

&emsp;IC設計的階段性合成如上Fig-2.2，在考慮成本(Area)和效率(Speed)之間的取捨下，每個階段都將進行合成，也就是透過各種tool把code或邏輯進行Translation、Optimization、以及Mapping。
&emsp;而每個接段的合成都必須經過嚴謹的驗證及分析，從開始設計功能時提出的行為就必須先進行模擬和驗證，確認沒問題後才可以開始透過RTL的撰寫來設計IC，使其能表達出這樣的行為；接著進入邏輯的合成，也需要透過tool做邏輯的驗證和模擬測試才能將邏輯閘做連接；再往下走，透過一些 cells 合成電路，也是要模擬並分析電路後才能將這些電晶體連接起來形成電路；最後，經過設計規格的檢查和電路萃取，就能往下進行光罩的製作。

### **2.3 ASIC Design**
#### 重頭打造並生產 ASIC 晶片

#### Pros :
- 完全依照客戶要求的邏輯閘數量去刻cell
- 光罩成形後製作的晶片成本低
- 適合大量生產
#### Cons : 
- 光罩成本高，不適合少量生產
- 無法重複燒製，燒錯了要重刻光罩
- 設計時間較長
- tool昂貴

![](https://i.imgur.com/PDgsxol.png)
&emsp;&emsp;Fig-2.3 ASIC 設計流程

&emsp;Fig-2.3描述了ASIC設計從產品spec拿到後開始的兩個大流程，以及各個階段可能用到的tool。
&emsp;首先，根據behavior設計去寫Verilog，接著合成邏輯和電路的設計，然後進行前半段Pre-Layout的模擬，這段的職位一般公司稱為Pre-sim工程師(frontend)；而如果職位工作範圍包含Post-sim工程師(backend)的話，就得包含Layout設計，最後才能tape out。

### 2.4 FPGA/CPLD Design 
#### 根據需求製作 FPGA/CPLD 晶片

#### Pros :
- cell 都已經刻好(規格化)，可以重複燒製電路邏輯，方便擴充或修改
- 設計時間較短
- 適合有彈性的設計需求
- tool 便宜、甚至免費
- 可用較新的製程(因為規格化生產)
#### Cons :
- 每顆價格相同，平均成本高，不適合大量製作
- 邏輯閘數量規格已定死，必須在限制數量下設計
- 速度較ASIC差

#### ++ModelSim Design Flow++

![](https://i.imgur.com/jeAeF5w.jpg)
&emsp;&emsp;Fig-2.4 ModelSim設計流程

&emsp;FPGA和CPLD的差別在於架構的不同，而兩者都是蜂巢式的晶片設計，已經事先刻好cell，只要把電路設計好燒上去即可；兩者在設計流程的精神上大同小異，這邊以本課程要用的FPGA tool : ModelSim為例子說明。
&emsp;見Fig-2.4，從一開始的設計概念開始走，一樣寫成RTL code並進行模擬；接著合成HDL邏輯閘，並進行functional sim，去驗證電路行為是否正確(看輸入輸出波型等等)；接著P&R階段就將設計好的電路實現在FPGA上(還沒燒)，而後進行timing sim，包含一些時序測試(驗證速度、延遲)；最後都確認無誤才燒到晶片上。

#### ++IC design consideration++
- Design feasibility ?
- Design spec. ?
- Cost ?
- FPGA or Standard-cell ASIC ?
- FPGA vendor ?
- FPGA device family ?
- Development time ?

---

## **3. Verilog Basic**
&emsp;RTL 層的 Coding 必須以 HDL 來描述電路的行為與邏輯，而在IC設計上常用的 HDL 包括 Verilog 和 VHDL。
&emsp;在台灣，九成以上的IC設計公司用Verilog去寫RTL code，這樣的情景還能持續撐幾年沒有人知道。其實從一、二十年前，以C或matlab等高階語言去設計IC的想法就已經出現，也不乏出現可以將高階語言轉成HDL的工具，但其設計出來的晶片在成本、效能、與功耗上仍然無法與直接用HDL寫出來的晶片匹敵。但由於coding技術演進快速，尤其今年chatGPT的崛起，往後聘用工程師撰寫HDL的商業模式也有可能改變。
&emsp;在講coding之前，先提一下在VLSI設計上的五大需要優化的issue :
- 成本Area : 更少的矽晶圓、面積使用。
- 表現Speed : 效率上會有一些門檻須要去達成。
- 功耗Power dissipation : 冷卻、電池消耗上的優化。
- 測試性Testability : 盡量縮減測試的耗時。
- 設計週期Design time : 設計CAD tools以降低整體設計流程的時間成本。

&emsp;另外，在大型電路設計流程上，又可分為Top-Down及Bottom-Up兩種流程，如Fig-3.1和Fig-3.2。
![Fig-3.1](https://i.imgur.com/8qlq87B.png)
&emsp;&emsp;Fig-3.1
![Fig-3.2](https://i.imgur.com/NRlIORW.png)
&emsp;&emsp;Fig-3.2

&emsp;Top-Down是由上而下從設計圖去切成各個子區域在分成多個不同功能的元件(邏輯閘組合)，由多個team分工去寫，早期的IC設計大部分都是這種形式；而Bottom-Up則是現今許多功能較不會被汰換，在不同的晶片設計上會用到一樣的功能，甚止有些功能可以去向他廠外包、購買，最後在組成想要得電路結構，如此一來在設計上效率會提升許多。

### **3.1 Code Architucture**
#### ++**Module**++
&emsp;以`module`型別建立，中間描述，結尾`endmodule`。
```verilog=
module module_name(port_name);
// (1) port declaration
// (2) data type declaration
// (3) module functionality or structure
endmodule
```
#### ***EXAMPLE-3.1***
```verilog=
module Add_half(sum, c_out, a, b);

input        a, b; // 輸入輸出各兩條
output sum, c_out; // 沒定義的話預設就是一個bit (a, b, sum, c_out 都是)

wire c_out_bar;
// 要邏輯閘，並描述輸入輸出
xor         (xum, a, b); // 輸入a, b 輸出xum
nand  (c_out_bar, a, b); // 輸入a, b  輸出c_out_bar
not  (c_out, c_out_bar); // 輸入c_out_bar 輸出c_out

endmodule
```
#### ++**Identifiers**++
- 代表各個物件的名稱 (`modules`、`ports`、`instances`的名稱)
- 第一個字元必須為字母，其餘可用字母、數字和底線。
#### ++**Description**++
&emsp;Verilog在編寫上有三種方式，以Fig-3.3的電路為例 : 
![Fig-3.3](https://i.imgur.com/GmTgfG1.png)
&emsp;&emsp;Fig-3.3 An example of digital circuit
***Approach 1 : Structural description***
&emsp;土法煉鋼，不推薦，除非cell-based要指定cell。(Ex : 台積電cell library 的or閘 : orf203)
```verilog=
module OR_AND_STRUCTURSL(IN, OUT);

input [3:0] IN; //描述input, output
output      OUT;
wire  [1:0] TEMP;

or u1(TEMP[0], IN[0], IN[1]); // 建立or閘 // or -> orf203 : TSMC or gate no.f203, 
or u2(TEMP[1], IN[2], IN[3]); // 建立or閘 // need TSMC cell lib.   
and (OUT, TEMP[0], TEMP[1]);  // 建立and閘

endmodule
```
***Approach 2 : Data flow description***
&emsp;描述如下，與C不同的是，assign那行在C程式只被執行一次，而在Verilog寫出電路後就會一直執行同樣的行為(無須包loop)。
```verilog=
module OR_AND_DATA_FLOW(IN, OUT);

input [3:0] IN;
output      OUT;

assign OUT = (IN[0] | IN[1]) & (IN[2] | IN[3]);

endmodule 
```
***Approach 3 : Behavior description***
&emsp;&emsp;行為描述，好用，IC設計大多數情況都採用行為描述。
```verilog=
module OR_AND_BEHAVIORAL(IN, OUT);

input [3:0] IN; //  IN[0]~IN[3] inputs
output      OUT;
reg         OUT;

always @(IN) // once input INs' value change, then begin the behavior
begin
	OUT = (IN[0]|IN[1]) & (IN[2]|IN[3]); // behavior between different inputs
end
endmodule
```
&emsp;除了以上寫法外，behavior也可以直接用真值表來描述(較繁瑣如下)，一般來說交給tool做就行。

![](https://i.imgur.com/Jx4o0mK.png)

```verilog=
module or_and(IN, OUT);
input [3:0] IN; output OUT; reg OUT;

always @(IN)
	begin
	case(IN)
		4'b0000: OUT = 0; 4'b0001: OUT = 0;
		4'b0010: OUT = 0; 4'b0011: OUT = 0;
		4'b0100: OUT = 0; 4'b0101: OUT = 1;
		4'b0110: OUT = 1; 4'b0111: OUT = 1;
		4'b1000: OUT = 0; 4'b1001: OUT = 1;
		4'b1010: OUT = 1; 4'b1011: OUT = 1;
		4'b1100: OUT = 0; 4'b1101: OUT = 1;
		4'b1110: OUT = 1; default: OUT = 1;
	endcase 
	end
endmodule
```
### **3.2 Gate Delay**
![](https://i.imgur.com/K8UHRLp.png)
&emsp;Fig-3.5

&emsp;如Fig-3.5，雖然各軸的延遲精確數字可能outdated或因為製程、廠商不同而有所不同，但相互之間的優劣關係通常不會改變，NAND、NOR閘明顯在成本及延遲上會優於AND、OR閘，因此實作上通常只會用NAND、NOR，不過現在大部分用tool生成的電路，考量到成本和延遲大多會自動以NAND、NOR為主去生成。
#### ***EXAMPLE-3.2***

![](https://i.imgur.com/qTe6CT5.png)

![](https://i.imgur.com/DoQn2Uo.png)

&emsp;上面兩種作法都可以做出一個全加器(full-adder)，延遲和電晶體成本都是下方的電路較為優異。

&emsp;&emsp;***閘多不代表電晶體用得多，閘少不代表電晶體用得少!多用reg型別(registers, 1 bit)，少用int(interger, 32bits)型別，錙銖bit較!!Clock rate = 1 / period of critical path (工作頻率 = 1 / 工作週期延遲)***
#### ++**Different between C & Verilog**++
- 8-bit input wire, ?-bit adder, 2’s complement → the number of bits (pins) → 錙銖bit較
- critical path : Fig-3.8中右電路的設計critical path又更短(延遲更短)。
![](https://i.imgur.com/gGBrwor.png)
&emsp;&emsp;Fig-3.6

### **3.3 Data Types**
#### ++**Net**++
Physical connection between devices.
\<nettype\>\<range\>?\<delay_spec\>?\<\<net_name\>\<,net_name\>*\>
![](https://i.imgur.com/Ua8yAin.png)
![](https://i.imgur.com/2grhy6v.png)

#### ++**Registers**++
Abstract storage devices.
\<register_type\> \<range\>? \<\<register_name\> \<,register_name>*\>
![](https://i.imgur.com/SkXnSG0.png)

#### ++**Numbers**++
\<size\>’\<base format\>\<number\>
![](https://i.imgur.com/mJElBEo.png)

#### ++**Parameters**++
Run-time constants.
parameter\<range\>?\<list_of_assignments\>
任何地方都可以用parameter
***EXAMPLE-3.3***
```verilog=
module mod(ina, inb, out);
	...
	parameter m1 = 8;
	...
	wire [m1:0] w1;
	...
endmodule
```
**w1 can be set as a (n+1)-bit wire if we change m1 to n.
(i.e., m1=10, w1 becomes a 11-bit wire; m1=4, w1 becomes a 5-bit wire.)
也可以直接定義一組參數來使用如下:**
***EXAMPL-3.4***
```verilog=
module PARAM_1(A,B,C,D);
input [4 : 0] A;
input [3 : 0] B;
input [3 : 0] C;
output [5 : 0] D;

test_2 #(5,4,4) u1(A, B, C, D);

module test_2(A , B , C , D);
parameter width = 8;
parameter height = 8;
parameter length = 8;

input [width - 1 : 0] A;
input [height - 1 : 0] B;
input [length- 1 : 0] C;
output [width : 0] D;

	assign D = A + B + C;
endmodule
```

### **3.4 Port Mapping**
Mapping in order or mapping by names.
By name的方式通常比較好，pin腳多的時候in order容易出錯。
![](https://i.imgur.com/CU6zVEd.png)
&emsp;&emsp;Fig-3.7 Prot mapping in order

![](https://i.imgur.com/H54Si1D.png)
&emsp;&emsp;Fig-3.8 Port mapping by name

```verilog=
/* In order */
module parent_mod;
	wire [3:0] g;
	child_mod G1(g[3], g[1], g[0], g[2]);
endmodule

module child_mod(sig_a, sig_b, sig_c, sig_d);
	input sig_c, sig_d; 
	output sig_a, sig_b;
	/* module description */
endmodule

/* By name */
module parent_mod;
	wire [3:0] g;
	child_mod G1(.sig_c(g[3]), .sig_d(g[2]), .sig_b(g[0]), .sig_a(g[1]));
endmodule

module child_mod(sig_a, sig_b, sig_c, sig_d);
	input sig_c, sig_d; 
	output sig_a, sig_b;
	/* module description */
endmodule
```

### **3.5 Operands (操作數)**

***Review***
```
以 W <= X + Y - Z 關係式來說 : 
X + Y -Z 為表達式(expression)
X, Y, Z 為操作數(operands)
+, - 為運算子(operators)
```
![](https://i.imgur.com/LmxoSMT.png)

++**Identifiers**++
- consists of letters, digits, underscores (_) and dollar sign ($).
- Verilog is case sensitive, so upper and lower case identifier names are treated as different identifiers.
***EXAMPLE-3.6***
```verilog=
module LITERALS(A1, A2, B1, B2, Y1, Y2);
		input A1, A2, B1, B2;
		output [7:0] Y1; output [5:0] Y2; /* Y1:8bit,Y2:6bits */
		parameter CST = 4'b 1010, TF = 25;
		reg [7:0] Y1; reg [5:0] Y2;
	always @(A1 or A2 or B1 or B2)
	begin
		if(A1 == 1)
			Y1 = {CST, 4’b 0000}; /* 4'b 0000 : bit string literals */
		else if (A2 == 1)
			Y1 = {CST, 4’b 0101};
		else
			Y1 = {CST, 4’b 1111};

		if (B1 == 0)
			Y2 = 10;
		else if (B2 == 1)
			Y2 = 15;
		else 
			Y2 = TF +10 +15; /* TF:Identifier */
	end                  /* 10,15:Numeric interger literals */
endmodule
```
![](https://i.imgur.com/29rPZlY.png)
&emsp;&emsp;Fig-3.9 Generated circuit of EXAMPLE

![](https://i.imgur.com/NQ1eTOk.png)
***EXAMPLE-3.7***
```verilog=
module FUNCTION_CALLS (A1, A2, A3, A4, B1, B2, B3, B4, Y1, Y2);
	input A1, A2, A3, A4, B1, B2, B3,B4; output [2:0] Y1, Y2;
	reg [2:0] Y1, Y2;
function [2:0] Fn1; /* Fn1 will take 3 inputs */
	input F1, F2, F3;
	begin
		Fn1 = F1+F2+F3; /* function behavior */
	end
endfunction
	always @(A1 or A2 or A3 or A4 or B1 or B2 or B3 or B4)
	begin                    /* call Fn1 function */
	Y1 = Fn1(A1, A2, A3)+A4; /* Y1 = A1 + A2 + A3 + A4 */
	Y2 = Fn1(B1, B2, B3)-B4; /* Y2 = B1 + B2 + B3 - B4 */
	end 
endmodule

```
***Review***
```
數位邏輯中，減法即為加上其二進位補數(complement)。
[ Ex ]
Q : 10110 - 01010 = ? 
A :                                       /* 先算01010的2補數 */
→ 11111 - 01010 = 10101 /* 該位元數下的最大值-該數 /
→ 10101 + 1 = 10110        /* 再+1 */
→ 所以 10110 - 01010 = 10110 + 10110 = 101100 #
```
***EXAMPLE-3.8***
![](https://i.imgur.com/WhwRtXj.png)
&emsp;Fig-3.10 Fn1 = F1 + F2 + F3 + F4;

![](https://i.imgur.com/tikceUw.png)
&emsp;Fig-3.11 Fn2 = (F1 + F2) + (F3 + F4);

&emsp;同樣的成本下，Fn2的設計又比Fn1還好，因為Fn1的F3、F4要等前面的加法先處理好才能接收到前面的結果，所以Fn1要等一段延遲後function才會有意義。


### **3.6 Operators**

![](https://i.imgur.com/DQ2Wdfm.png)
![](https://i.imgur.com/cXtHUsu.png)
![](https://i.imgur.com/0YGji9F.png)

***EXAMPLE-3.9***
```verilog=
module INDEX_SLICE_NAME (A, B, Y);
    input [5:0] A, B;
    output [11:0]Y;
    parameter C = 3’b111;
    reg [11:0] Y;
always @(A or B)
begin
    Y[2:0] = A[2:0]; 
    Y[3] = A[3] | B[3]; 
    Y[5:4] = {A[5] | B[5], A[4] & B[4]};
    Y[8:6] = B[2:0];
    Y[11:9] = C;
end
endmodule
```
![](https://i.imgur.com/ImCc3D8.png)

***乘法(*)、除法(/)、求餘(%)由於成本太高不建議使用原廠生成，應使用額外設計的function來達成效果。(看公司有設計自有的function)***

### **3.7 Verification**
![](https://i.imgur.com/6qnhP74.png)

&emsp;&emsp;簡而言之，電路寫出來之後，必須餵一些輸入給它，看他的輸出對不對(看Waveform)。

![](https://i.imgur.com/c4C8Sfy.png)

&emsp;&emsp;看每個時間點的輸入去對應輸出，檢查是否正確。

![](https://i.imgur.com/v08AhFB.png)

&emsp;&emsp;如果要檢查功能是否正確和timing模擬，就要注意電路中元件的延遲是否影響功能。

![](https://i.imgur.com/rjeXfBm.png)

***EXAMPLE-3.10***
```verilog=
/* test bench (non-synthesizable) */
module or_and_tb;
    reg in1, in2, in3, in4;
    wire out;
    or_and ok(.in1(in1), .in2(in2), .in3(In3), .in4(in4), .out(out));
    initial
    begin
    #0 in1=0; in2=0; in3=0; in4=0;
    #10 in1=0; in2=0; in3=0; in4=1;
    #10 in1=0; in2=0; in3=1; in4=0;
    #10 in1=0; in2=0; in3=1; in4=1;
    #10 in1=0; in2=1; in3=0; in4=0;
    #10 in1=0; in2=1; in3=0; in4=1;
    #10 in1=0; in2=1; in3=1; in4=0;
    #10 in1=0; in2=1; in3=1; in4=1;
    #10 in1 = 1; in2 = 0; in3 = 0; in4 = 0;
    #10 in1 = 1; in2 = 0; in3 = 0; in4 = 1;
    #10 in1 = 1; in2 = 0; in3 = 1; in4 = 0;
    end
endmodule
/* the actual module to synthesize */
module or_and (in, out);
    input[3:0] in;
    output out;
    assign out = (in[0] | in[1]) & (in[2] | in[3]);
endmodule
```
### **3.8 Statements & Blocks**
#### ***++Blocks++***
&emsp;&emsp;Verilog可以用block包住所需要的執行之statements，block內所創建之參數或變數皆非global，亦不可以在block內以assign宣告電路行為，範例如下:
```verilog=
module LOCAL_GOL(IN_1 , IN_2 , OUT_1 , OUT_2);
input [3 : 0]IN_1;
input [3 : 0]IN_2;
output [4 : 0]OUT_1;
output [4 : 0]OUT_2;
reg [4 : 0]OUT_1;
reg [4 : 0]OUT_2;
always @(IN_1)
begin: Local_Value_1
    parameter X = 7;
    OUT_1 = IN_1 + X;
end
```
- Exhaustive test : 所有可能的排列組合都測試。
- Partial test : 只測部分(大部分都是這種情況)。

#### ***++Always blocks++***
&emsp;always blocks的觸發條件為裡面寫到的輸入輸出之值變動的時候，便會開始執行staements；此外亦可以指定某些電路碰到上升(posedge)或下降(negedge)事件時執行statements。(範例如下)
```verilog=
always@ (a or b or c)
begin
x = a | b | c;
end

always @ ( [posedge or negedge] event)
begin
. . . statements . . .
end (sequential circuit)
```

#### ***++If/else++***
&emsp;而if/else的statement，在verilog裡，只要有if最好就一定要有else，沒寫的話tool會幫你自動生成latches，範例如下:
![](https://i.imgur.com/RM8Sats.png)
**No latch inference**
```verilog=
Module Latch(In, Enable, Out);
input Enable;
Input [3:0] In;
output [3:0] Out;
always @(In or Enable)
begin
if(Enable)
Out=In;
else
Out=0;
end
endmodule
```
(生成電路如下)

![](https://i.imgur.com/nniTCq4.png)

**With unintentional Latches**
```verilog=
Module Latch(In, Enable, Out);
input Enable;
input [3:0] In;
output [3:0] Out;
always @(In or Enable)
begin
if(Enable)
Out=In;
end
endmodule
//If Enable ==1
//Out (new) = In
//If Enable==0
//Out (new) = Out (old)
```
- ***除非公司特殊需要，不然盡量不要有latches***
- 寫得時候注意input的所有情況，例如`input [1:0] IN`由於為2bit輸入，所以其實有四種input`[00(0), 01(1), 10(2), 11(3)]`。
(生成電路如下)

![](https://i.imgur.com/3WuNpT1.png)

- ***另外也要注意if/else的piority，例如 :***
```verilog=
always @(sel or a or b or c or d)
if (sel[2] == 1’b1)
out = a; //sel=1XX
else if (sel[1] == 1’b1)
out = b; //sel=01X
else if (sel[0] == 1’b1)
out = c; //sel=001
else
out = d; //sel=000
```
&emsp;如果`sel`的第三位已經是`1`了那麼其嘎兩位無論是啥都只會執行`out = a`，其餘情況亦有先後優先權之分。

***EXAMPL-3.11***
```verilog=
// Bad Style
case (STATE)
IDLE:
if (LATE == 1’b1)
ADDR_BUS <= ADDR_MAIN;
else
ADDR_BUS <= ADDR_CNTL;
INTERRUPT:
if (LATE == 1’b1)
ADDR_BUS <= ADDR_MAIN;
else
ADDR_BUS <= ADDR_INT;
...
```

![](https://i.imgur.com/EOAStNI.png)

```verilog=  
// Good Style
if (LATE == 1’b1)
ADDR_BUS <= ADDR_MAIN;
else
case (STATE)
IDLE:
ADDR_BUS <= ADDR_CNTL;
INTERRUPT:
ADDR_BUS <= ADDR_INT;
...
```

![](https://i.imgur.com/MpMVTsF.png)

***EXAMPL-3.12***
```verilog=
// Bad Style
module style_bad(In_Data, State, Out_Data, En);
input En;
input [1:0] State;
input [2:0] In_Data;
output [3:0] Out_Data;
reg [3:0] Out_Data;
parameter A1=0, A2=1, A3=2, A4=3;

always @(In_Data or State or En)
begin
    case(State)
        A1:
        begin
            if(En)
            Out_Data = In_Data;
            else
            Out_Data = In_Data - 1;
        end
        A2:
        begin
            if(En)
            Out_Data = In_Data;
            else
            Out_Data = In_Data + 1;
        end
        A3:
        begin
            if(En)
            Out_Data = In_Data;
            else
            Out_Data = In_Data - 2;
        end
        A4:
        begin
            if(En)
            Out_Data = In_Data;
            else
            Out_Data = In_Data + 2;
        end 
    endcase 
end 
    
endmodule
```

![](https://i.imgur.com/TZTMLIs.png)

```verilog=
// Good Style
module style_good(In_Data, State, Out_Data, En);
input En;
input [1:0] State;
input [2:0] In_Data;
output [3:0] Out_Data;
reg [3:0] Out_Data;
parameter A1=0, A2=1, A3=2, A4=3;
    
always @(In_Data or State or En)
begin
    if(En)
    Out_Data = In_Data;
    else
    begin
        case(State)
            A1: Out_Data = In_Data - 1;
            A2: Out_Data = In_Data + 1;
            A3: Out_Data = In_Data - 2;
            A4: Out_Data = In_Data + 2;
        endcase
    end
end
    
endmodule
```

![](https://i.imgur.com/yaDaViq.png)

#### ***++Combinational & Sequential Circuit++***
&emsp;&emsp;組合電路即電路本身只把當前input做邏輯判斷並輸出output其中不包含任何記憶單元；而在應用上大多數的電路大多為循序電路，即電路中除了組合電路外，還有記憶單元(如registers)，因此當下的input會與先前的input做邏輯比較再進行output(如下圖)。

![](https://i.imgur.com/p0frPI5.png)

- ***乾淨的組合電路與記憶單元盡量分開寫!!***

#### ***++Resource Sharing++***
&emsp;可以看到下面例子中，用`()?():()`運算的方式做出來的選擇器會比用`if/else`寫出來的多一個加法器，因此資源共享也是想降低成本時的重要考量之一。
```verilog=
/* without resource sharing */
assign z = sel_a ? a+t : b+t;
/* resource sharing */
if (sel_a)
    z = a + t;
else
    z = b + t;
```
without resource sharing : 

![](https://i.imgur.com/m2GJdDM.png)


resource sharing : 

![](https://i.imgur.com/JF9Ldw3.png)

#### ***++Case++***
&emsp;利用case statement時，如同if/else，必須列出所有case的statements，若沒有將所有的case定義玩其statement(not full-case)，tool將會自動生成latches來記先前的output作為輸出。
```verilog=
module FULL_CASE(IN , OUT);
input [1 : 0]IN;output [3 : 0] OUT;
reg [3 : 0]OUT;
always @(IN)
begin
case(IN)
    2'b00: OUT = 4'b0001;
    2'b01: OUT = 4'b0010;
    2'b10: OUT = 4'b0100;
    default: OUT = 4'b1000;
endcase
end
endmodule
```
&emsp;&emsp;上述例子的case中，`defualt`類似`esle`的效果，即為前述沒提到的所有cases。

#### ***++Case/Casex/Casez++***
(參考 [Verilog語言中case、casex、casez的用法和區別](https://www.twblogs.net/a/5db3b3b1bd9eee310ee6a888))
&emsp;casez與casex語句是case語句的兩種變體, 在寫testbench時會用到，其真值表如下 :
![](https://i.imgur.com/rHnoTuj.png)
- 在case語句中，敏感表達式中與各項值之間的比較是一種全等比較，每一位都相同才認爲匹配。
- 在casez語句中，如果分支表達式某些位的值爲高阻z，那麼對這些位的比較就會忽略，不予考慮，而只關注其他位的比較結果。
- 在casex語句中，則把這種處理方式進一步擴展到對x的處理，即如果比較雙方有一方的某些位的值是z或x，那麼這些位的比較就不予考慮。

***EXAMPLE-3.12***
***<Case>***
```verilog=
case (sel) 
    2'b00:      y = a; 
    2'b01:      y = b; 
    2'bx0:      y = c; 
    2'b1x:      y = d; 
    2'bz0:      y = e; 
    2'b1?:      y = f; 
    default :   y = g; 
endcase
```
|sel|y|case item|
|---|-|---------|
|00 |a|00       |
|11	|g|default  |
|xx	|g|default  |
|x0	|c|x0       |
|1z	|f|1?       |
|z1	|g|default  |

***<Casez>***
&emsp;case的描述，匹配都是從上到下進行的，如果使用了casez，看上面的casez的列表，只要輸入有z/?的話，就能和任意匹配。
```verilog=
casex (sel) 
    2'b00   :   y = a; 
    2'b01   :   y = b; 
    2'bx0   :   y = c; 
    2'b1x   :   y = d; 
    2'bz0   :   y = e; 
    2'b1?   :   y = f; 
    default :   y = g; 
endcas
```
|sel|y|case item|
|---|-|---------|
|00 |a|00       |
|11	|f|1?       |
|xx	|g|default  |
|x0	|c|x0/1x    |
|1z	|d|1x/1?/z0 |
|z1	|b|10/1?    |


***<Casex>***
&emsp;casex也是從上到下匹配，當出現x/z/?的輸入的時候，都不會care。
```verilog=
case (sel) 
    2'b00:      y = a; 
    2'b01:      y = b; 
    2'bx0:      y = c; 
    2'b1x:      y = d; 
    2'bz0:      y = e; 
    2'b1?:      y = f; 
    default :   y = g; 
endcase
```
|sel|y|case item|
|---|-|---------|
|00 |a|00       |
|11	|d|1x/1?    |
|xx	|a|00/x0/1x/z0/1?|
|x0	|a|x0/1x/z0/1?|
|1z	|c|x0/1x/z0/1?|
|z1	|b|01/1x/1? |

#### ***++For++***
&emsp;基本上在verilog裡，不太推薦使用for迴圈，原因為tool會幫把所有的情況下的電路都產生出來，每一圈都會產生一組新電路。
&emsp;以bubble sorting來說(由小到排序)，若是以C語言寫法(雙層for迴圈)來做，那耗費的資源會很可怕，4 input的bubble sorting:
***EXAMPL-3.13***
```verilog=
module for_loop(a,b,c,d,out);
input  [3:0] a,b,c,d;
output [3:0] out;
reg    [3:0] temp [3:0];
reg    [3:0] buffer,out;
integer i,j;

always@(a or b or c or d)
begin
temp[0]=a;
temp[1]=b;
temp[2]=c;
temp[3]=d;
for(i=2;i>=0;i=i-1)
    for(j=0;j<=i;j=j+1)
        if(temp[j]>temp[j+1])
        begin
            buffer=temp[j+1];
            temp[j+1]=temp[j];
            temp[j]=buffer;
        end
        out=temp[3];
end
endmodule
```
![](https://i.imgur.com/lwYuq85.png)

&emsp;如此一來組共需要產生6個比較器，且後面比較器的output要等到前面的比完才會有意義，所以根本沒必要產生那麼多的比較器。
&emsp;&emsp;因此，大多數情況，bubble sorting會以一個比較器和FSM(有限狀態機)的形式來完成。

#### ***++Function++***
&emsp;與C語言相同，Verilog中亦可以善用Fuction來編寫，如下列範例的加法器，就有不同的方法來達成，注意若是指派的output位元術語fuction回傳的不一樣，會將前面幾個bits捨去或補再回傳。

***EXAMPLE-3.14***
```verilog=
module FUN_STATE(A , B , C1 , C2 , C3 , C4 , C5);
input  [3 : 0]A;
input  [3 : 0]B;
output [6 : 0]C1; //func
output [2 : 0]C2; //func
output [4 : 0]C3; //always
output [4 : 0]C4; //assign
reg [6 : 0]C1;
reg [2 : 0]C2;
reg [4 : 0]C3; 
reg [4 : 0]C4;

function [4 : 0]Fn1;
input [3 : 0]A;
input [3 : 0]B;
Fn1 = A + B; // like C
endfunction
    
always @(A or B)
begin
C1 = Fn1(A , B); // insert “0” in the first two bits
end

always @(A or B)
begin
C2 = Fn1(A , B); // discard the first two bits
end

always @(A or B)
begin
C3 = A + B;
end

assign C4 = A + B;

endmodule
```
---

## **4. Combinational Circuit**
**NOTE :** 在寫組合電路時，盡量把每個可能的case寫滿。
### **4.1 Alarm**
&emsp;Assume that four persons might come. Alarm is activated when
1. more than three persons come.
2. the fourth person come together with other persons.

```verilog=
module four(A , B , C , D , Out);
input A , B , C , D;
output Out;
reg Out , temp;
always @(A or B or C or D)
begin
    case({A , B , C , D})
    4’b0000: Out = 0;
    4’b0001: Out = 0;
    4’b0010: Out = 0;
    4’b0011: Out = 1;
    4’b0100: Out = 0;
    4’b0101: Out = 1;
    4’b0110: Out = 0;
    4’b0111: Out = 1;
    4’b1000: Out = 0;
    4’b1001: Out = 1;
    4’b1010: Out = 0;
    4’b1011: Out = 1;
    4’b1100: Out = 0;
    4’b1101: Out = 1;
    4’b1110: Out = 1;
    default: Out = 1;
    endcase
end
endmodule
```
|A|B|C|D|out|
|-|-|-|-|---|
|0|0|0|0|0|
|0|0|0|1|0|
|0|0|1|0|0|
|0|0|1|1|1|
|0|1|0|0|0|
|0|1|0|1|1|
|0|1|1|0|0|
|0|1|1|1|1|
|1|0|0|0|0|
|1|0|0|1|1|
|1|0|1|0|0|
|1|0|1|1|1|
|1|1|0|0|0|
|1|1|0|1|1|
|1|1|1|0|1|
|1|1|1|1|1|

### **4.2 Seven Segment Display**
&emsp;A BCD (Binary-Coded Decimal)-to-seven-segment decoderr is a combinational circuit that accepts a decimal digit in BCD and generates the appropriate output for selection of segments in a display indicator used for displaying the decimal digit.
**INPUT**&emsp;&emsp;**A, B, C;**
**OUTPUT**&emsp;**a, b, c, d, e, f, g;**

![](https://i.imgur.com/o5JvBPr.png)


|#|A B C D|a b c d e f g|
|-|-------|-------------|
|0|0 0 0 0|0 1 1 1 1 1 0|
|1|0 0 0 1|0 1 1 0 0 0 0|
|2|0 0 1 0|1 1 0 1 1 0 1|
|3|0 0 1 1|1 1 0 0 0 0 1|
|4|0 1 0 0|0 1 1 0 0 1 1|
|5|0 1 0 1|1 0 1 1 0 1 1|
|6|0 1 1 0|1 0 1 1 1 1 1|
|7|0 1 1 1|1 1 1 0 0 0 0|
|8|1 0 0 0|1 1 1 1 1 1 1|
|9|1 0 0 1|1 1 1 1 0 1 1|

### **4.3 Multiplexer(Mux)**

#### ++***2to1 Mux***++
**Single-bit :**
```verilog=
// Method 1
always @(a or b or Select)
begin
    if (Select)
    Out = a;
    else
    Out = b;
end
// Method 2
always @(a or b or Select)
begin
    Out=b;
    if (Select)
    Out = a;
end
// Method 3
assign Out = Select ? a : b;
```

**Multiple-bit :**

![](https://i.imgur.com/7FvEVCS.png)

```verilog=
module multibit2(a, b, Select, Out);
parameter width=8;
input     [width-1:0] a, b;
input     Select;
output    [width-1:0] Out;
wire      [width-1:0] Out;

assign Out = Select ? a : b;
endmodule
```

#### ++***4to1 Mux***++

![](https://i.imgur.com/65843Fy.png)

```verilog=
always @(A or B or C or D or S1 or S0)
begin
    case ({S1, S0})
    2'b00: Out = A;
    2'b01: Out = B;
    2'b10: Out = C;
    default: Out = D;
    endcase
end
```

### **4.4 Encoder & Decoder**
#### ++***Encoder (4 to 2)***++
![](https://i.imgur.com/IGiddu2.png)
```verilog=
module encoder(A,Y);
parameter size=4;
input [size-1:0] A;
output [1:0] Y;
reg [1:0] Y;
    
always@(A)
begin
    case(A)
    4'b 0001 : Y=0;
    4'b 0010 : Y=1;
    4'b 0100 : Y=2;
    4'b 1000 : Y=3;
    default: Y=2'b00;
    endcase
end
    
endmodule
```

#### ++***Priority Encoder (4 to 2)***++
![](https://i.imgur.com/lr81OyU.png)
```verilog=
module encoder (A,Valid,Y);
input [3:0] A;
output Valid;
output [1:0] Y;
reg Valid;
reg [1:0] Y;
    
always@(A)
begin
Valid=1;
    casex(A)
    4'b 1xxx : Y=3;
    4'b 01xx : Y=2;
    4'b 001x : Y=1;
    4'b 0001 : Y=0;
    default:
    begin Valid=0; Y=2'b00; end
    endcase
end
    
endmodule
```

#### ++***Decoder (2 to 4)***++
![](https://i.imgur.com/sbF7Hxn.png)
```verilog=
module decoder(A,Y);
parameter size=4;
input [1:0] A;
output [size-1:0] Y;
reg [size-1:0] Y;

always@(A)
begin
    case(A)
    0:Y = 4'b0001;
    1:Y = 4'b0010;
    2:Y = 4'b0100;
    default:Y = 4'b1000;
    endcase
end

endmodule 
```

#### ++***Decoder (3 to 6)***++
![](https://i.imgur.com/evcwZ4z.png)
```verilog=
module decoder3_6_case1(A,En,Y);
input En; input [2:0] A;
output [5:0] Y; reg [5:0] Y;

always@(En or A)
begin
    if(!En)
    Y = 6'b0;
    else
        case(A)
        0:Y = 6'b000001;
        1:Y = 6'b000010;
        2:Y = 6'b000100;
        3:Y = 6'b001000;
        4:Y = 6'b010000;
        5:Y = 6'b100000;
        default:Y = 6'b0;
        endcase
end
    
endmodule
```
### **4.5 Comparator**
#### ++***Combinational comparator***++
![](https://i.imgur.com/VE8pkaM.png)
```verilog=
module comparator(A, B, CLK, AGTB, AEQB, ALTB);
input [7:0] A, B;
output AGTB, AEQB, ALTB;
reg AGTB, AEQB, ALTB;

always @(A or B)
begin
AGTB = (A > B);
AEQB = (A == B);
ALTB = (A < B);
end
    
endmodule
```
![](https://i.imgur.com/RSQhRvl.png)

#### ++***Sequential comparator***++
![](https://i.imgur.com/XYGIPcN.png)
```verilog=
module comparator(A, B, CLK, AGTB,
AEQB, ALTB);
parameter size = 8;
input [size-1:0] A, B;
input CLK;
output AGTB, AEQB, ALTB;
reg AGTB, AEQB, ALTB;
    
always @(posedge CLK)
begin
AGTB = (A > B);
AEQB = (A == B);
ALTB = (A < B);
end
    
endmodule
```
![](https://i.imgur.com/c8TBFP6.png)

#### ++***Maximum select***++
![](https://i.imgur.com/sfmq30U.png)
```verilog=
// Method 1
always @(A or B or C or D)
begin
if(A >= B)
    Out1=A;
else
    Out1=B;   
if(Out1 >= C)
    Out2=Out1;
else
    Out2=C;   
if(Out2 >= D)
    Out=Out2;
else
    Out=D; 
end
// Method 2(hierarchical tree structure)
always @(A or B or C or D)
begin
if(A >= B)
    Out1=A;
else
    Out1=B;
if(C >= D)
    Out2=C;
else
    Out2=D;
if(Out1 >= Out2)
    Out=Out1;
else
    Out=Out2;
end
```
![](https://i.imgur.com/GxjAueD.png)
![](https://i.imgur.com/Cn8KRj0.png)

![](https://i.imgur.com/SYUXTGP.png)

---

## **5. Sequential Circuit**

&emsp;循序電路根據輸入信號的順序來產生輸出信號，也就是電路的輸出取決於先前的輸入，因此通常會有記憶單元。
&emsp;其中，循序電路又可以分為同步循序電路和非同步循序電路。同步循序電路使用時鐘信號(clock)來同步操作；而非同步循序電路則不需要時鐘信號，它們的操作是基於輸入信號的變化。

###  **5.1 Flip-Flop**

![](https://i.imgur.com/u6UEta8.png)

&emsp;Flip-flops屬於edge-trigger的記憶方式，意即當clk訊號有上升或下降時再進行記憶。

![](https://i.imgur.com/bC3TTsr.png)

&emsp;其中，如以上的例子，利用flip-flop的電路元件大多為六個閘的設計(D flip-flop)，比起兩個latch成本更低；而伴隨flip-flop而來的會是setup time和hold-time (通常tool會幫你算): 

- The setup time
    - D input must be maintained at a constant value prior to the application of the positive Clk pulse
    - setup time = the propagation delay through gates 4 and 1
    - data to the internal latches
- The hold time
    - D input must not changes after the application of the positive Clk pulse
    - hold time = the propagation delay of gate 3 
    - clock to the internal latch

![](https://i.imgur.com/yEupLO0.png)

&emsp;Flip-flop元件標示以及記憶訊號如下(Q為被記憶之值) :

![](https://i.imgur.com/kY2f9QY.png)

![](https://i.imgur.com/xSNjvHX.png)

#### ++**基本Flip-flow寫法**++

|D|Q(t+1)|
|-|-|
|0|0|
|1|1|
```verilog=
/* D flip-flop */
// At every positive edge of Clk, Q is set as D
module D_FF(Clk, D, Q);
input Clk, D;
output Q;
Reg Q;
    always @(posedge Clk) // or negedge Clk for negative_D_FF
begin
Q=D;
end
endmodule

/* Toggle Flip-flop */
module Toggle (Clk, Q);
input Clk;
output Q;
Reg Q;
always @(posedge Clk)
begin
Q=~Q;
end
endmodule
```
![](https://i.imgur.com/olB0huP.png)

![](https://i.imgur.com/dZP8t7d.png)

![](https://i.imgur.com/hMIoeRp.png)

![](https://i.imgur.com/vkGeWPW.png)


###  **5.2 Register**
![](https://i.imgur.com/o47Pg5Q.png)
