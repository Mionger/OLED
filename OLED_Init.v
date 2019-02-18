`timescale 1ns / 1ps

module Display_OLED
( 
input [63:0]reac0,
input [63:0]reac1,
input [63:0]reac2,
input [63:0]reac3,
input [3:0]size,

input clk_in,  //clk_in = 25mhz
input rst_n_in,  //rst_n_in, active low

output reg run_flag,
output reg oled_rst_n_out,
output reg oled_cs_n_out,
output reg oled_dc_out,
output oled_clk_out,
output reg oled_data_out
);
 
`include "commands.vh"

reg [63:0] cmd_r [18:0];
initial
	begin
	   //command for initial
		cmd_r [0]= {DISPLAY_OFF,SET_CONTRAST_A,8'hFF,SET_CONTRAST_B, 8'hFF,SET_CONTRAST_C,8'hFF,8'hE3};
		cmd_r [1]= {MASTER_CURRENT_CONTROL,8'h06,SET_PRECHARGE_SPEED_A,8'h64,SET_PRECHARGE_SPEED_B,8'h78,SET_PRECHARGE_SPEED_C,8'h64};
		cmd_r [2]= {SET_REMAP,8'h72,SET_DISPLAY_START_LINE, 8'h00,SET_DISPLAY_OFFSET, 8'h00,NORMAL_DISPLAY,8'hE3};
		//
        cmd_r [3]= {SET_MULTIPLEX_RATIO, 8'h3F,SET_MASTER_CONFIGURATION,8'h8E,POWER_SAVE_MODE,8'h00,PHASE_PERIOD_ADJUSTMENT,8'h31};
        cmd_r [4]= {SET_PRECHARGE_VOLTAGE,8'h3A, 8'h3E,SET_V_VOLTAGE,8'h3E,DISPLAY_CLOCK_DIV,8'hF0,NORMAL_BRIGHTNESS_DISPLAY_ON};
        
        cmd_r [5]= {CLEAR_WINDOW,8'h00,8'h00,8'h5F,8'h3F,FILL_WINDOW,8'h37,8'hE3};
        //draw a line
        cmd_r [6]={8'h21,8'h00,8'h00,8'h5F,8'h3F,8'h0E,8'h11,8'hE3};
        
        cmd_r [7]={8'h22,8'h00,8'h00,8'h5F,8'h3F,8'hFB,8'hFF,8'hFB};
        cmd_r [8]={8'hFB,8'hFF,8'hFB,8'hE3,8'hE3,8'hE3,8'hE3,8'hE3};
        //command for setting data drawing area
        cmd_r [9]={8'hE3,8'hE3,SET_COLUMN_ADDRESS,8'h00,8'h5F,SET_ROW_ADDRESS,8'h00,8'h3F};
        
        cmd_r [11]={8'h00,8'h00,8'h00,8'hE3,8'hE3,8'hE3,8'hE3,8'hE3};
        cmd_r [13]={8'h00,8'h00,8'h00,8'hE3,8'hE3,8'hE3,8'hE3,8'hE3};
        cmd_r [15]={8'h00,8'h00,8'h00,8'hE3,8'hE3,8'hE3,8'hE3,8'hE3};
        cmd_r [17]={8'h00,8'h00,8'h00,8'hE3,8'hE3,8'hE3,8'hE3,8'hE3}; 
	end

//initial for memory register
reg [63:0] mem [21:0];
reg [63:0] temp;
initial
	begin
		mem[0]={8'h0E,8'h11,8'h13,8'h15,8'h19,8'h11,8'h0E,8'h00};
        mem[1]={8'h04,8'h0C,8'h04,8'h04,8'h04,8'h04,8'h0E,8'h00};
        mem[2]={8'h0E,8'h11,8'h01,8'h02,8'h04,8'h08,8'h1F,8'h00};
        mem[3]={8'h0E,8'h11,8'h01,8'h0E,8'h01,8'h11,8'h0E,8'h00};
        mem[4]={8'h02,8'h06,8'h0A,8'h12,8'h1F,8'h02,8'h02,8'h00};
        mem[6]={8'hFF,8'h00,8'hFF};
	end
//	   reg [63:0]test_test;

always @ (*)
begin
    cmd_r[10]=reac0;
    cmd_r[12]=reac1;
    cmd_r[14]=reac2;
    cmd_r[16]=reac3;
end

reg clk_div; 
reg[15:0] clk_cnt=0;
always@(posedge clk_in or negedge rst_n_in)
begin
	if(!rst_n_in) clk_cnt<=0;
	else begin
		clk_cnt<=clk_cnt+1;  
		if(clk_cnt==(CLK_DIV_PERIOD-1)) clk_cnt<=0;
		if(clk_cnt<(CLK_DIV_PERIOD/2)) clk_div<=0;
		else clk_div<=1;
	end
end

//divide clk_div 4 state, RISING and FALLING state is keeped one cycle of clk_in, like a pulse.
reg[1:0] clk_div_state=CLK_L;
always@(posedge clk_in or negedge rst_n_in)
begin
	if(!rst_n_in) clk_div_state<=CLK_L;
    else 
		case(clk_div_state)
			CLK_L: begin
					if (clk_div) clk_div_state<=CLK_RISING_DEGE;  
					else clk_div_state<=CLK_L;
				end
			CLK_RISING_DEGE :clk_div_state<=CLK_H;  
			CLK_H:begin                 
					if (!clk_div) clk_div_state<=CLK_FALLING_DEGE;
					else clk_div_state<=CLK_H;
				end 
			CLK_FALLING_DEGE:clk_div_state<=CLK_L;  
			default;
		endcase
end

reg shift_flag = 0;
reg[7:0] char_reg;
reg[8:0] temp_cnt;
reg[7:0] data_reg; 
reg[2:0] data_state=IDLE; 
reg[2:0] data_state_back; 
reg[7:0] data_state_cnt=0;  
reg[3:0] shift_cnt=0; 
reg[25:0] delay_cnt=0;  

reg [3:0]last_size=4'h0;
reg [27:0]data=32'h0;
//Finite State Machine, 
always@(posedge clk_in or negedge rst_n_in)      
begin
	if(!rst_n_in)
		begin 
			data_state<=IDLE;
			run_flag <= 1;
			data_state_cnt<=0;
			shift_flag <= 0;
			oled_cs_n_out<=HIGH;
		end
    else begin
		case (data_state)
			IDLE: begin
					oled_cs_n_out<=HIGH;
					data_state_cnt<=data_state_cnt+1;
					case(data_state_cnt)
						0: oled_rst_n_out <= 0;
						1: data_state<=DELAY;
						2: oled_rst_n_out <= 1;
						3: data_state<=DELAY;
						//display initial
						4: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=0; end
						5: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=1; end
						6: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=2; end
						7: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=3; end
						8: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=4; end
						//clear window
						9:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=5;end
						//draw line
						10: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=6; end
						//draw black
						11: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=7; end
						12: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=8; end
						//13: begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg<=9; end
						//14:begin data_state=CLEAR;end
						13:;
						14:;
						
						
						15:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=10;end
						16:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=11;end
						17:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=12;end
						18:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=13;end
						19:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=14;end
						20:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=15;end
						21:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=16;end
						22:begin data_state<=DISPLAY;data_state_back<=DISPLAY;oled_dc_out<=CMD;char_reg=17;end
						
						default: 
						begin
						      run_flag <= ~run_flag;
						     if(last_size!=size)
                             begin
                                  data_state_cnt<=10;
                                  last_size<=size;
                             end
                             else data_state_cnt<=22;
						end
					endcase
				end
				
			SHIFT: begin
					if(!shift_flag)
						begin
							if (clk_div_state==CLK_FALLING_DEGE)  
								begin
									if (shift_cnt==8)  
										begin
											shift_cnt<=0;
											data_state<=data_state_back;
										end
									else begin
											oled_cs_n_out<=LOW;
											oled_data_out<=data_reg[7];   
											shift_flag <= 1;
										end
								end
						end
					else
						begin
							if (clk_div_state==CLK_RISING_DEGE)   
								begin  
									data_reg<={data_reg[6:0], data_reg[7]};  
									shift_cnt<=shift_cnt+1;
									shift_flag <= 0;
								end
						end
				end
			DISPLAY: begin
						temp_cnt<=temp_cnt+1;
						oled_cs_n_out<=HIGH;
						if (temp_cnt==8) 
							begin
								data_state<=IDLE;
								temp_cnt<=0; 
							end
						else 
							begin
								temp = (oled_dc_out==CMD)? cmd_r[char_reg]:mem[char_reg];
								case (temp_cnt)
								    0 :  data_reg<=temp[63:56];
								    1 :  data_reg<=temp[55:48];
									2 :  data_reg<=temp[47:40];
									3 :  data_reg<=temp[39:32];
									4 :  data_reg<=temp[31:24];
									5 :  data_reg<=temp[23:16];
									6 :  data_reg<=temp[15:8];
									7 :  data_reg<=temp[7:0];
									default;
								endcase
								data_state<=SHIFT;
							end
					end
			
			CLEAR: begin            
					data_reg<=8'h00;
					temp_cnt<=temp_cnt+1;
					oled_cs_n_out<=HIGH;
					oled_dc_out<=DATA;
					if (temp_cnt>=12288) 
						begin
							temp_cnt<=0;
							data_state<=IDLE;
						end
					else data_state<=SHIFT;
				end
			
			DELAY: begin
					if(delay_cnt==DELAY_PERIOD)
						begin
							data_state<=IDLE; 
							delay_cnt<=0;
						end
					else delay_cnt<=delay_cnt+1;
				end
					   
			default;
		endcase
	end
end
assign oled_clk_out = oled_cs_n_out?0:clk_div;
endmodule

