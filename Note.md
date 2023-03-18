# Digital IC Design Note

Last Updated : **2023/3/18**, ***MWChang***.

:pushpin: 這個課程筆記主要參考成功大學的資工所「數位IC設計」課程(2023)PPT與授課老師陳培殷的講課內容，並從一些網路資源彙整一些關於數位IC設計的背景知識。


## **1. Introdution**
&emsp;&emsp;科技的應用無非是要解決特定的問題，而若是要以演算法去解決問題，最後必定要開發出硬體來執行寫出來的program，常見的手法便包含般偏的軟體solution，使用CPU來執行寫好的program，有比較好的編程彈性；又或是直接做出專用電路(dedicated circuit)來跑這樣的演算法；介於中間的，就是現在常見的電路結合程式的solution。
#### **電路與程式的結合，較常見有兩種實現方式** :
1. **System on a board** : 在開發板上透過嵌入式的系統，結合特殊應用積體電路(ASIC)，來達成特殊case的solution。(如下[Fig-1.1])
2. **System on a chip (SoC)** : 把原本在開發板上的每個元件都包單一IC晶片上。

![Fig-1.1](https://i.imgur.com/tbRcWwg.png)
&emsp;&emsp;Fig-1.1 Sytem on board example.

如何透過IC設計將晶片的功能寫好，且壓低成本，提高效能表現，將會是最重要的課題。

### **1.1 Digital System**
&emsp;&emsp;本節由小而大的來簡介一個數位系統。系統中最小的單位就是電晶體(transistor)，電晶體的角色為承載訊息的元件，通常以半導體來製作，而數個電晶體可以製作成邏輯閘 (gate)，進而根據規則來傳遞訊號，而利用數個邏輯閘可以組合成一個數位系統包含的電路 (digital circuit)，這樣的可以接受 0或1的input，根據邏輯閘的規則給予output(邏輯閘相關背景知識詳見 B1. 數位邏輯 )，如Fig-1.2中框框內的電路，而數個電路連在一起就是所謂的IC(integrated circuit)。

![](https://i.imgur.com/3zyl9LM.png)
&emsp;&emsp;Fig-1.2 IC架構

&emsp;&emsp;這樣的IC可以用 HDL (Hardware Description Language, 硬體描述語言) 來編寫，進而透過tools合成 (Synthesis)電路，HDL包括Verilog和VHDL，在台灣超過九成的企業都習慣用Verilog來編寫。
&emsp;&emsp;而經由IC設計，將數個IC組成不同的特殊應用積體電路 (ASIC) 來提供各式功能，由這些 ASIC 和記憶體等元件可以組成負責系統中不同角色的PCB(printed circuit board, 印刷電路板)，最後多個PCB組合而成的系統就可以實現各個case的需求(整體架構如Fig.1-3所示)。

![](https://i.imgur.com/KCCurgn.png)
&emsp;&emsp;Fig-1.3 數位系統細節架構

### **1.2 IC Industry**
&emsp;&emsp;由於技術的演進，目前市面上的IC設計已經可以達到包含數萬個元件的 VLSI (超大型積體電路) 或集數百萬個元件於一身的 SoC (單晶片系統) 規模。

#### **IC分類與發展年代如下 :**

- 1970s~ SSI (Small-Scaled Integrated Circuits) : 小型積體電路→含數十個元件
- 1970s~ MSI (Medium-Scaled IC) : 中型積體電路→含數百個元件
- 1980s~ LSI (Large-Scaled IC) : 大型積體電路→含數千個元件
- 1990s~ VLSI (Very Large Scaled IC) : 超大型積體電路→含數萬個元件
- 2000s~ SoC (System on a Chip) : 單晶片系統→含數百萬個元件

&emsp;&emsp;而台灣的IC產業鏈如Fig-1.4所示，先由聯發科(MediaTek)、聯詠(Novatek)、瑞昱 (Realtek)等IC設計公司設計好晶片後交由台積電(TSMC)、聯電(UMC) 等半導體代工廠進行生產，代工廠依據設計好的電路和邏輯閘來客光罩，刻好之後便將原料加工製造成ASIC晶片，最終進行封裝、測試。

![](https://i.imgur.com/FeiKnwP.png)
&emsp;&emsp;Fig-1.4 台灣IC產業鏈

## **2. Semi Custom Design Flow**

#### **IC design flow 大約分為兩種類型 :**
1. **Full Custom Design 全客戶設計** : 大部分的步驟都由工程師自己做，設計時間成本高，但可以做到較活耀的客製化要求，類比電路以及小的數位電路可用此法。(ASIC)
2. **Semi Custom Design 半客戶設計** : 用來設計較大的數位電路，又稱作「cell-based design」，引入代工廠的cell，透過tool來做設計。
&emsp;- **Standard Cells** : TSMC, UMC -cells (ASIC)
&emsp;- **FPGA/PLD** : Xilinx, Altera -cells (PLD)

&emsp;&emsp;本章節重點在描述各種Semi Custom Design的流程，下Fig-2.1展示了IC設計的流程分層圖，從最上層的系統概念開始往下走，由概念設計出演算法；再由演算法把架構畫出來；然後就到了RTL Coding的環節，也就是要利用Verilog來寫出IC架構；接著，利用tool將寫好的code轉成邏輯閘；最後再透過tool轉成電晶體。

![](https://i.imgur.com/i620OQu.png)
&emsp;&emsp;Fig-2.1 IC設計分層

&emsp;&emsp;整體來說，越往上層的設計越偏向行為摘要的敘述，而越往下層就越細節，更接近真實電路。

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

&emsp;&emsp;IC設計的階段性合成如上Fig-2.2，在考慮成本(Area)和效率(Speed)之間的取捨下，每個階段都將進行合成，也就是透過各種tool把code或邏輯進行Translation、Optimization、以及Mapping。
&emsp;&emsp;而每個接段的合成都必須經過嚴謹的驗證及分析，從開始設計功能時提出的行為就必須先進行模擬和驗證，確認沒問題後才可以開始透過RTL的撰寫來設計IC，使其能表達出這樣的行為；接著進入邏輯的合成，也需要透過tool做邏輯的驗證和模擬測試才能將邏輯閘做連接；再往下走，透過一些 cells 合成電路，也是要模擬並分析電路後才能將這些電晶體連接起來形成電路；最後，經過設計規格的檢查和電路萃取，就能往下進行光罩的製作。

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

&emsp;&emsp;Fig-2.3描述了ASIC設計從產品spec拿到後開始的兩個大流程，以及各個階段可能用到的tool。
&emsp;&emsp;首先，根據behavior設計去寫Verilog，接著合成邏輯和電路的設計，然後進行前半段Pre-Layout的模擬，這段的職位一般公司稱為Pre-sim工程師(frontend)；而如果職位工作範圍包含Post-sim工程師(backend)的話，就得包含Layout設計，最後才能tape out。

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

&emsp;&emsp;FPGA和CPLD的差別在於架構的不同，而兩者都是蜂巢式的晶片設計，已經事先刻好cell，只要把電路設計好燒上去即可；兩者在設計流程的精神上大同小異，這邊以本課程要用的FPGA tool : ModelSim為例子說明。
&emsp;&emsp;見Fig-2.4，從一開始的設計概念開始走，一樣寫成RTL code並進行模擬；接著合成HDL邏輯閘，並進行functional sim，去驗證電路行為是否正確(看輸入輸出波型等等)；接著P&R階段就將設計好的電路實現在FPGA上(還沒燒)，而後進行timing sim，包含一些時序測試(驗證速度、延遲)；最後都確認無誤才燒到晶片上。

#### ++IC design consideration++
- Design feasibility ?
- Design spec. ?
- Cost ?
- FPGA or Standard-cell ASIC ?
- FPGA vendor ?
- FPGA device family ?
- Development time ?

## **3. Verilog Basic**

### **3.1 Code Architucture**

### **3.2 Gate Delay**

### **3.3 Data Types**

### **3.4 Port Mapping**

### **3.5 Operands 操作數**

### **3.6 Operators**

### **3.7 Verification**
