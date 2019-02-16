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
    output [9:0]DATA;
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
    parameter DISPLAY_OFF                     = 8'd0;
    parameter SET_CONTRAST_A                  = 8'd1;//blue
    parameter SET_CONTRAST_A_ARGUMENT         = 8'd2;
    parameter SET_CONTRAST_B                  = 8'd3;//green
    parameter SET_CONTRAST_B_ARGUMENT         = 8'd4;
    parameter SET_CONTRAST_C                  = 8'd5;//red
    parameter SET_CONTRAST_C_ARGUMENT         = 8'd6;
    parameter MASTER_CURRENT_CONTROL          = 8'd7;
    parameter MASTER_CURRENT_CONTROL_ARGUMENT = 8'd8;
    parameter SET_PRECHARGE_SPEED_A           = 8'd9;
    parameter SET_PRECHARGE_SPEED_A_ARGUMENT  = 8'd10;
    parameter SET_PRECHARGE_SPEED_B           = 8'd11;
    parameter SET_PRECHARGE_SPEED_B_ARGUMENT  = 8'd12;
    parameter SET_PRECHARGE_SPEED_C           = 8'd13;
    parameter SET_PRECHARGE_SPEED_C_ARGUMENT  = 8'd14;
    reg [7:0]state;
    reg [9:0]data;
    reg start;
    reg done;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            		state <= 8'd0;
			start <= 1'b0;
			done  <= 1'b0;
			data  <= {2'b11,8'h00};
        end
        else if (START & rst_done) begin
            case (state)
                DISPLAY_OFF:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hAE};// commmand code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_A:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h81};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_A_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//argument
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_B:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h82};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_B_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//argument
                        start <= 1'b1;
                    end
                end  
                SET_CONTRAST_C:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h83};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_C_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//argument
                        start <= 1'b1;
                    end
                end
                MASTER_CURRENT_CONTROL:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h87};//command code
                        start <= 1'b1;
                    end
                end
                MASTER_CURRENT_CONTROL_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h06};//argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_A:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8A};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_A_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h64};//argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_B:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8B};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_B_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h78};//argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_C:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8C};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_C_ARGUMENT:begin
                    if(WRITE_DONE) begin
                        state <= state + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h64};//argument
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

	
	
	
	
