module SPIWrite
(
	CLK,
	RST_N,
	START,
	DATA,	
	DONE,
	OUT//	OUT[3]=CS	out[2]=DC	OUT[1]=SCL(D0)	OUT[0]=SDA(D1)	
);
	
	input CLK;
	input RST_N;
	input START;
	input [9:0] DATA;//command{2'b00,8'hXX}  data{2'b01,8'hXX}
	
	output DONE;
	output [3:0]OUT;
	
    reg [3:0] count;
	parameter TIME5US = 4'd9;
	always @(posedge CLK or negedge RST_N) begin
		if(!RST_N) count <= 4'd0;
		else begin
			if(count == TIME5US) count <= 4'd0;
			else begin
				if(START) count <= count + 1'b1;
				else      count <= 4'd0;
            end
        end
	end
	
	reg [4:0] state;
	reg scl;//spi_clk
	reg sda;//spi_data(1bit)
	reg done;
	always @(posedge CLK or negedge RST_N) begin
		if(!RST_N) begin
			state    <= 5'd0;
			scl  <= 1'b1;
			sda  <= 1'b0;
			done <= 1'b0;
		end
		else begin
			if(START) begin
				case(state)
					5'd0,5'd2,5'd4,5'd6,5'd8,5'd10,5'd12,5'd14: begin //negdge set
						if(count == TIME5US) begin
							scl <= 1'b0;			
							sda <= DATA[7 - (state>>1) ];
							state <= state + 1'b1;
						end
					end
					5'd1,5'd3,5'd5,5'd7,5'd9,5'd11,5'd13,5'd15: begin //posedge send
						if(count == TIME5US) begin
							scl <= 1'b1;			
							state <= state + 1'b1;
						end
					end
					5'd16:
					begin
						done <= 1'b1;
						state <= state + 1'b1;
					end
					5'd17:
					begin
						done <= 1'b0;
						state <= 5'd0;
					end
				endcase
            end
		end
	end
	
	assign DONE = done;
	assign OUT = {DATA[9],DATA[8],scl,sda};
	
	endmodule
	
