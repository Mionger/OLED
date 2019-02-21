module SPI
(
    CLK,        // master`s clock(FPGA)  25km
    SCLK,       // slave`s clock(OLED)
    RST_N,      // reset pin of hardware
    DATA,       // CS / DC / 8bit data
    START,
    DONE,
    CS,         // chip select
    DC,         // data or command
    DIN         // data input(1 bit weight)
);
    input CLK;
    input RST_N;
    input [9:0]DATA;
    input START;

    output DONE;
    output SCLK;
    output CS;
    output DC;
    output DIN;

    reg DONE;
    reg CS;
    reg DC;
    reg DIN;

    // divider
    Divider#(2) divider(CLK,SCLK);  // Only for test , the function argument should be 80 

    // sclk fam
    parameter SCLK_L = 2'b00;
    parameter SCLK_H = 2'b11;
    parameter SCLK_POSEDGE = 2'b01;
    parameter SCLK_NEGEDGE = 2'b10;
    reg [1:0]sclk_status = SCLK_L;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            sclk_status <= SCLK_L;
        end
        else begin
            case (sclk_status)
                SCLK_L:begin
                    if(SCLK) begin
                        sclk_status <= SCLK_POSEDGE;
                    end
                    else begin
                        sclk_status <=SCLK_L;
                    end
                end
                SCLK_H:
                    if(!SCLK) begin
                        sclk_status <= SCLK_NEGEDGE;
                    end
                    else begin
                        sclk_status <=SCLK_H;
                    end
                SCLK_POSEDGE: begin
                    sclk_status <=SCLK_H;
                end
                default: 
                begin
                    sclk_status <=SCLK_L;
                end
            endcase
        end
    end

    // spi write fam
    parameter SPI_IDLE  = 3'd0;
    parameter SPI_SEND  = 3'd1;
    parameter SPI_OVER  = 3'd2;
    reg [2:0]spi_status  = SPI_IDLE;
    reg [3:0]spi_cnt    = 4'b0;
    reg spi_flag        = 1'b0;
    reg [9:0]spi_data;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            spi_status <= SPI_IDLE;
            CS        <= 1'b1;
            DONE      <= 1'b0;
            spi_flag  <= 1'b0;
            spi_cnt   <= 4'b0;
        end
        else begin
            case (spi_status)
                SPI_IDLE:begin
                    CS        <= 1'b1;
                    DONE      <= 1'b0;
                    if(START)begin
                        spi_status <= SPI_SEND;
                        spi_data  <= DATA;
                    end
                end
                SPI_SEND:begin
                    if(!spi_flag)begin
                        if(sclk_status == SCLK_NEGEDGE)begin
                            if(spi_cnt == 4'b1000)begin
                                spi_cnt   <= 4'b0;
                                spi_status <= SPI_OVER;
                            end 
                            else begin
                                CS       <= spi_data[9];
                                DC       <= spi_data[8];
                                DIN      <= spi_data[7];
                                spi_flag <= 1'b1;
                            end
                        end
                    end
                    else begin
                        if(sclk_status == SCLK_POSEDGE)begin
                            CS       <= 1'b1;
                            spi_data <= {spi_data[9],spi_data[8],spi_data[6:0],spi_data[7]};
                            spi_cnt  <= spi_cnt + 4'b0001;
                            spi_flag <= 1'b0;
                        end
                    end
                end
                default: begin
                    DONE      <= 1'b1;
                    CS        <= 1'b1;
                    spi_status <= SPI_IDLE;
                end
            endcase
        end
    end
endmodule