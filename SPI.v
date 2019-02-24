module SPI
(
    CLK,            // master`s clock(FPGA)  25km
    RST_N,          // reset pin of hardware
    WRITE_EN,       // write enable signal(start)
    READ_EN,        // read enable signal(start)
    SPI_MISO,       // data that master input(1 bit weight)
    DATA_IN,        // data that slave input(8bits data)
    SPI_SCLK,       // slave`s clock(OLED)
    SPI_CS,         // chip select
    SPI_MOSI,       // data that master output(1 bit weight)
    DATA_OUT,       // data that slave output(8bits data) 
    WRITE_DONE,     // write finish
    READ_DONE       // read finish
);
    input CLK;
    input RST_N;
    input WRITE_EN;
    input READ_EN;
    input SPI_MISO;
    input [7:0]DATA_IN;

    output SPI_SCLK;
    output SPI_CS;
    output SPI_MOSI;
    output [7:0]DATA_OUT;
    output WRITE_DONE;
    output READ_DONE;

    reg SPI_SCLK;
    reg SPI_CS;
    reg SPI_MOSI;
    reg [7:0]DATA_OUT;
    reg WRITE_DONE;
    reg READ_DONE;

    reg [3:0]write_status;
    reg [3:0]read_status;

    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin // initialize
            write_status  <=  4'd0;
            read_status   <=  4'd0;
            SPI_CS        <=  1'b1;
            SPI_SCLK      <=  1'b0;
            SPI_MOSI      <=  1'b0;
            WRITE_DONE    <=  1'b0;
            READ_DONE     <=  1'b0;
            DATA_OUT      <=  8'd0;
        end 
        else if(WRITE_EN) begin  // write start
            SPI_CS  <=  1'b0; // set cs low
            case(write_status)
                4'd1, 4'd3 , 4'd5 , 4'd7  , 
                4'd9, 4'd11, 4'd13, 4'd15 : begin// shift
                    SPI_SCLK      <=  1'b1;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end
                4'd0:begin// send the MSB
                    SPI_MOSI      <=  DATA_IN[7];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end
                4'd2:begin
                    SPI_MOSI      <=  DATA_IN[6];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end
                4'd4:begin
                    SPI_MOSI      <=  DATA_IN[5];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end 
                4'd6:begin
                    SPI_MOSI      <=  DATA_IN[4];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end 
                4'd8:begin
                    SPI_MOSI      <=  DATA_IN[3];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end                            
                4'd10:begin
                    SPI_MOSI      <=  DATA_IN[2];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end 
                4'd12:begin
                    SPI_MOSI      <=  DATA_IN[1];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b0;
                end 
                4'd14:begin// send the LSB
                    SPI_MOSI      <=  DATA_IN[0];
                    SPI_SCLK      <=  1'b0;
                    write_status  <=  write_status + 1'b1;
                    WRITE_DONE    <=  1'b1;
                end
                default:write_status  <=  4'd0;   
            endcase 
        end
        else if(READ_EN) begin// read start
            SPI_CS <= 1'b0; // set cs low
            case(read_status)
                4'd0, 4'd2 , 4'd4 , 4'd6  , 
                4'd8, 4'd10, 4'd12, 4'd14 : begin// read
                    SPI_SCLK       <=  1'b0;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                end
                4'd1:begin // store MSB                       
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[7]    <=  SPI_MISO;   
                end
                4'd3:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[6]    <=  SPI_MISO; 
                end
                4'd5:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[5]    <=  SPI_MISO; 
                end 
                4'd7:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[4]    <=  SPI_MISO; 
                end 
                4'd9:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[3]    <=  SPI_MISO; 
                end                            
                4'd11:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[2]    <=  SPI_MISO; 
                end 
                4'd13:begin
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b0;
                    DATA_OUT[1]    <=  SPI_MISO; 
                end 
                4'd15:begin // store LSB
                    SPI_SCLK       <=  1'b1;
                    read_status    <=  read_status + 1'b1;
                    READ_DONE      <=  1'b1;
                    DATA_OUT[0]    <=  SPI_MISO; 
                end
                default:read_status  <=  4'd0;   
            endcase 
        end    
        else begin
            write_status  <=  4'd0;
            read_status   <=  4'd0;
            WRITE_DONE    <=  1'b0;
            READ_DONE     <=  1'b0;
            SPI_CS        <=  1'b1;
            SPI_SCLK      <=  1'b0;
            SPI_MOSI      <=  1'b0;
            DATA_OUT      <=  8'd0;
        end      
end

endmodule
