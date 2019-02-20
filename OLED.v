module OLED
(
    CLK,
    RST_N,
    START,
    OLED_SCLK,
    OLED_RST,        //hard interface reset
    OLED_CS,         //
    OLED_DC,
    OLED_DIN
);
    
    input CLK;
    input RST_N;
    input START;

    output OLED_SCLK;
    output OLED_RST;
    output OLED_CS;
    output OLED_DC;
    output OLED_DIN;

    wire spi_start;
    wire spi_done;
    wire [9:0]spi_data;
    SPI spi(CLK,OLED_SCLK,RST_N,spi_data,spi_start,spi_done,OLED_CS,OLED_DC,OLED_DIN);

    reg init_start=1'b0;
    wire init_done;
    OLED_Init init(CLK,RST_N,init_start,init_done,spi_start,spi_done,spi_data,OLED_RST);

endmodule

