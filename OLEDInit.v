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
            state <= 8'd0;
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

	
	
	
	
