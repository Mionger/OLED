# OLED  
## Project Information
&nbsp;&nbsp;&nbsp;&nbsp;
Developer
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
: 
&nbsp;
Mion-ger
&nbsp;
Park  
&nbsp;&nbsp;&nbsp;&nbsp;
Lastest Update
&nbsp;
: 
&nbsp;
2019-2-23  
&nbsp;&nbsp;&nbsp;&nbsp;
Version
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
: 
&nbsp;
v0.1.2  
&nbsp;&nbsp;&nbsp;&nbsp;
OS
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
: 
&nbsp;
Win10  
&nbsp;&nbsp;&nbsp;&nbsp;
Language&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
: 
&nbsp;
Verilog HDL    
&nbsp;&nbsp;&nbsp;&nbsp;
Software
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
: 
&nbsp;
Vivado 2016  

>## Todo List(Update 2019-2-20)
>&nbsp;&nbsp;&nbsp;&nbsp;1.Simulate OLEDInit.v to DEBUG  
>&nbsp;&nbsp;&nbsp;&nbsp;2.Draw line by basic SSD1331 command  
>&nbsp;&nbsp;&nbsp;&nbsp;3.Draw rectangle by basic SSD1331 command     
>&nbsp;&nbsp;&nbsp;&nbsp;4.Draw other picture by display data RAM
  
## Update Log File  
<pre>
Update 2019-2-22 v0.1.2
  1.Try another way about SPI.v
  2.Still have bug between SCLK and CS/DIN when SPI send over
</pre>

<pre>
Update 2019-2-22 v0.1.2
  1.Add Project Information in README.md and Todo List
  2.Fix the bug about reset
  3.Correct spelling mistake of 'status'(previous versions spells as 'state')
</pre>

<pre>
Update 2019-2-21 v0.1.1
  1.Add file OLED.v to link OLEDInit.v with SPI.v
  2.Update Divider.v to replace passing argument into funtion called argument
</pre>

<pre>
Update 2019-2-20 v0.1.0
  1.Complete OLEDInit.v
</pre>

<pre>
Update 2019-2-19 v0.0.8
  1.Complete SPI.V
  2.Simulate SPI.v successfully
</pre>

<pre>
Update 2019-2-19 v0.0.7
  1.Delete 2 files OLED_Init.v,SPIWrite.v
  2.Add 1 file SPI.v
</pre>

<pre>
Update 2019-2-18 v0.0.6
  1.Add 1 file OLED_Init.v(Add another version of initialization)
</pre>

<pre>
Update 2019-2-17 v0.0.5
  1.Update file OLEDInit.v(Add more settings of initialization)
  2.Update file SPIWrite.v(Add form detail of input data)
</pre>

<pre>
Update 2019-2-16 v0.0.4
  1.Update file OLEDInit.v(Add Initialize of SET_PRECHARGE_SPEED)
</pre>

<pre>
Update 2019-2-15 v0.0.3
  1.Update file OLEDInit.v(Reset the weight of data)
  2.Add file SPIWrite.v
</pre>

<pre>
Update 2019-2-14 v0.0.2
  1.Update file OLEDInit.v(Add Initialize of closing display)
</pre>

<pre>
Update 2019-2-13 v0.0.1
  1.Add file OLEDInit.v
</pre>