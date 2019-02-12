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
    always @(CLK or RST_N) begin
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
endmodule