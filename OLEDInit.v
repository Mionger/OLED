module OLED_Init
(
    CLK,
    RST_N,
    START,          //initial start
    DONE,           //initial done
    WRITE_START,    //spi write start
    WRITE_DONE,     //spi write done
    DATA,           //spi data
    RST_OLED        //hard interface reset
);

    input CLK;
    input RST_N;
    input START;
    input WRITE_DONE;

    output DONE;
    output WRITE_START;
    output [7:0]DATA;
    output RST_OLED;

    reg RST_OLED;

    //reset
    parameter SECOND = 20'd1000000;
    reg [19:0]count;
    reg rst_done;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            count<=20'd0;
            RST_OLED<=1'b0;
            rst_done<=1'b0;
        end
        else if (count == SECOND) begin
            count<=20'd0;
            RST_OLED<=1'b1;
            rst_done<=1'b1;
        end
        else begin
            count<=count + 1;
            RST_OLED<=1'b0;
            rst_done<=1'b0;
        end
    end

    //initialize
    parameter DISPLAY_OFF = 8'd0;
    reg [7:0]state;
    reg [7:0]data;
    reg start;
    reg done;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            i <= 8'd0;
			start <= 1'b0;
			done  <= 1'b0;
			data  <= 8'h00;
        end
        else if (START & rst_done) begin
            case (state)
                DISPLAY_OFF:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= 8'hAE;
                        start <= 1'b1;
                    end
                end 
                default: 
            endcase
        end
    end

    assign  DATA = data;
    assign  WRITE_START = start;
    assign  DONE = done;
endmodule

// /*--------------------------------------------------------------*\
// 	Filename	:	initial_control.v
// 	Author		:	Cwang
// 	Description	:	
// 	Revision History	:	2017-10-16
// 							Revision 1.0
// 	Email		:	wangcp@hitrobotgroup.com
// 	Company		:	Micro nano institute
// 	Copyright(c) 2017,Micro nano institute,All right resered
// \*---------------------------------------------------------------*/
// module initial_control(
// 	clk_1m,
// 	rst_n,
	
// 	initial_start,
// 	spi_write_done,
	
// 	spi_write_start,
// 	spi_data,
// 	initial_done,
// 	res_oled		//OLED的RES脚用来复位，低电平复位
// );
 
// 	input clk_1m;
// 	input rst_n;
// 	input initial_start;
// 	input spi_write_done;
	
// 	output spi_write_start;
// 	output [9:0] spi_data;
// 	output initial_done;
// 	output reg res_oled;
// 	//--------------------------------------
// 	//复位OLED
	
// 	parameter RES100MS = 20'd100000;
// 	reg [19:0] count;
// 	reg res_done;
// 	always @(posedge clk_1m or negedge rst_n)
// 	begin
// 		if(!rst_n)
// 		begin
// 			count <= 20'd0;
// 			res_oled <= 1'b0;
// 			res_done <= 1'b0;
// 		end
// 		else
// 			if(count == RES100MS)
// 			begin
// 				res_oled <= 1'b1;
// 				res_done <= 1'b1;
// 				count <= RES100MS;
// 			end
// 			else
// 			begin
// 				count <= count + 1'b1;
// 				res_oled <= 1'b0;
// 				res_done <= 1'b0;
// 			end
// 	end
	
// 	//--------------------------------------
// 	reg [7:0] i;
// 	reg start;
// 	reg [9:0] data;
// 	reg isdone;
// 	//--------------------------------------------------------
	
// 	always@(posedge clk_1m or negedge rst_n)
// 	begin
// 		if(!rst_n)
// 		begin
// 			i <= 8'd0;
// 			start <= 1'b0;
// 			isdone <= 1'b0;
// 			data <= {2'b11,8'd0};
// 		end
// 		else	
// 		begin
// 			if(initial_start && res_done)
// 			begin
// 				case(i)
// 			//-------------------------------------------------------------------------------------	
// 					8'd0:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hae}; start <= 1'b1;end
// 					8'd1:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h00}; start <= 1'b1;end	
// 					8'd2:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h10}; start <= 1'b1;end
// 					8'd3:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h40}; start <= 1'b1;end
// 					8'd4:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h81}; start <= 1'b1;end
// 					8'd5:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hCF}; start <= 1'b1;end
// 					8'd6:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hA1}; start <= 1'b1;end
// 					8'd7:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hC8}; start <= 1'b1;end
// 					8'd8:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hA6}; start <= 1'b1;end
// 					8'd9:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hA8}; start <= 1'b1;end
// 					8'd10:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h3F}; start <= 1'b1;end
// 					8'd11:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hD3}; start <= 1'b1;end
// 					8'd12:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h00}; start <= 1'b1;end
// 					8'd13:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hD5}; start <= 1'b1;end
// 					8'd14:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h80}; start <= 1'b1;end
// 					8'd15:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hD9}; start <= 1'b1;end
// 					8'd16:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hF1}; start <= 1'b1;end
// 					8'd17:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hDA}; start <= 1'b1;end
// 					8'd18:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h12}; start <= 1'b1;end
// 					8'd19:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hDB}; start <= 1'b1;end
// 					8'd20:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h40}; start <= 1'b1;end
// 					8'd21:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h20}; start <= 1'b1;end
// 					8'd22:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h02}; start <= 1'b1;end
// 					8'd23:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h8D}; start <= 1'b1;end
// 					8'd24:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'h14}; start <= 1'b1;end
// 					8'd25:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hA4}; start <= 1'b1;end
// 					8'd26:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hA6}; start <= 1'b1;end
// 					8'd27:
// 						if(spi_write_done) begin start <= 1'b0; i <= i + 1'b1;end
// 						else 			   begin data  <= {2'b00,8'hAF}; start <= 1'b1;end
// 			//--------------------------------------------------------------------------------			
// 					8'd28:
// 						begin
// 							data <= {2'b11,8'd0}; isdone <= 1'b1; i <= i + 1'b1;
// 						end
// 					8'd29:
// 						begin
// 							isdone <= 1'b0; i <= 8'd0;
// 						end
					
// 				endcase
// 			end
// 		end
// 	end
	
	
// 	assign spi_data = data;
// 	assign spi_write_start = start;
// 	assign initial_done = isdone;
// endmodule
	
	
	
	
	
