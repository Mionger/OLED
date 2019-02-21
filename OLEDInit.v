module OLED_Init
(
    CLK,
    RST_N,
    START,          //initial start
    DONE,           //initial done
    SPI_START,      //spi write start
    SPI_DONE,       //spi write done
    DATA,           //spi data
    RST_OLED        //hard interface reset
);

    input CLK;
    input RST_N;
    input START;
    input SPI_DONE;

    output DONE;
    output SPI_START;
    output [9:0]DATA;
    output RST_OLED;

    reg RST_OLED;

    //reset
    // parameter SECOND = 20'd1000000;
    parameter SECOND = 20'd2;       //Only for debug test, the parameter should be 1000000
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
    parameter DISPLAY_OFF                        = 8'd0;
    parameter SET_CONTRAST_A                     = 8'd1;//blue
    parameter SET_CONTRAST_A_ARGUMENT            = 8'd2;
    parameter SET_CONTRAST_B                     = 8'd3;//green
    parameter SET_CONTRAST_B_ARGUMENT            = 8'd4;
    parameter SET_CONTRAST_C                     = 8'd5;//red
    parameter SET_CONTRAST_C_ARGUMENT            = 8'd6;
    parameter MASTER_CURRENT_CONTROL             = 8'd7;
    parameter MASTER_CURRENT_CONTROL_ARGUMENT    = 8'd8;
    parameter SET_PRECHARGE_SPEED_A              = 8'd9;
    parameter SET_PRECHARGE_SPEED_A_ARGUMENT     = 8'd10;
    parameter SET_PRECHARGE_SPEED_B              = 8'd11;
    parameter SET_PRECHARGE_SPEED_B_ARGUMENT     = 8'd12;
    parameter SET_PRECHARGE_SPEED_C              = 8'd13;
    parameter SET_PRECHARGE_SPEED_C_ARGUMENT     = 8'd14;
    parameter SET_REMAP                          = 8'd15;
    parameter SET_REMAP_ARGUMENT                 = 8'd16;
    parameter SET_DISPLAY_START_LINE             = 8'd17;
    parameter SET_DISPLAY_START_LINE_ARGUMENT    = 8'd18;
    parameter SET_DISPLAY_OFFSET                 = 8'd19;
    parameter SET_DISPLAY_OFFSET_ARGUMENT        = 8'd20;
    parameter NORMAL_DISPLAY                     = 8'd21;
    parameter SET_MULTIPLEX_RATIO                = 8'd22;
    parameter SET_MULTIPLEX_RATIO_ARGUMENT       = 8'd23;
    parameter SET_MASTER_CONFIGURATION           = 8'd24;
    parameter SET_MASTER_CONFIGURATION_ARGUMENT  = 8'd25;
    parameter POWER_SAVE_MODE                    = 8'd26;
    parameter POWER_SAVE_MODE_ARGUMENT           = 8'd27;
    parameter PHASE_PERIOD_ADJUSTMENT            = 8'd28;
    parameter PHASE_PERIOD_ADJUSTMENT_ARGUMENT   = 8'd29;
    parameter DISPLAY_CLOCK_DIV                  = 8'd30;
    parameter DISPLAY_CLOCK_DIV_ARGUMENT         = 8'd31;
    parameter SET_PRECHARGE_VOLTAGE              = 8'd32;
    parameter SET_PRECHARGE_VOLTAGE_ARGUMENT     = 8'd33;
    parameter SET_V_VOLTAGE                      = 8'd34;
    parameter SET_V_VOLTAGE_ARGUMENT             = 8'd35;
    parameter DISPLAY_ON                         = 8'd36;
    
    reg [7:0]status = DISPLAY_OFF;
    reg [9:0]data;
    reg start;
    reg done;
    always @(posedge CLK or negedge RST_N) begin
        if(!RST_N) begin
            status <= 8'd0;
            start <= 1'b0;
            done  <= 1'b0;
            data  <= {2'b11,8'h00};
        end
        else if (START & rst_done) begin
            case (status)
                DISPLAY_OFF:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hAE};// commmand code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_A:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h81};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_A_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//command argument
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_B:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h82};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_B_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//command argument
                        start <= 1'b1;
                    end
                end  
                SET_CONTRAST_C:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h83};//command code
                        start <= 1'b1;
                    end
                end
                SET_CONTRAST_C_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hFF};//command argument
                        start <= 1'b1;
                    end
                end
                MASTER_CURRENT_CONTROL:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h87};//command code
                        start <= 1'b1;
                    end
                end
                MASTER_CURRENT_CONTROL_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h06};//command argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_A:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8A};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_A_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h64};//command argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_B:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8B};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_B_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h78};//command argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_C:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8C};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_SPEED_C_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h64};//command argument
                        start <= 1'b1;
                    end
                end
                SET_REMAP:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hA0};//command code
                        start <= 1'b1;
                    end
                end
                SET_REMAP_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h72};//command argument
                        start <= 1'b1;
                    end
                end
                SET_DISPLAY_START_LINE:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hA1};//command code
                        start <= 1'b1;
                    end
                end
                SET_DISPLAY_START_LINE_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h00};//command argument
                        start <= 1'b1;
                    end
                end
                SET_DISPLAY_OFFSET:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hA2};//command code
                        start <= 1'b1;
                    end
                end
                SET_DISPLAY_OFFSET_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h00};//command argument
                        start <= 1'b1;
                    end
                end
                NORMAL_DISPLAY:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hA4};//command code
                        start <= 1'b1;
                    end
                end
                SET_MULTIPLEX_RATIO:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hA8};//command code
                        start <= 1'b1;
                    end
                end
                SET_MULTIPLEX_RATIO_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h3F};//command argument
                        start <= 1'b1;
                    end
                end
                SET_MASTER_CONFIGURATION:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hAD};//command code
                        start <= 1'b1;
                    end
                end
                SET_MASTER_CONFIGURATION_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h8E};//command argument
                        start <= 1'b1;
                    end
                end
                POWER_SAVE_MODE:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hB0};//command code
                        start <= 1'b1;
                    end
                end
                POWER_SAVE_MODE_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h00};//command argument
                        start <= 1'b1;
                    end
                end
                PHASE_PERIOD_ADJUSTMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hB1};//command code
                        start <= 1'b1;
                    end
                end
                PHASE_PERIOD_ADJUSTMENT_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h31};//command argument
                        start <= 1'b1;
                    end
                end
                DISPLAY_CLOCK_DIV:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hB3};//command code
                        start <= 1'b1;
                    end
                end
                DISPLAY_CLOCK_DIV_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hF0};//command argument
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_VOLTAGE:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hBB};//command code
                        start <= 1'b1;
                    end
                end
                SET_PRECHARGE_VOLTAGE_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h3A};//command argument
                        start <= 1'b1;
                    end
                end
                SET_V_VOLTAGE:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'hBE};//command code
                        start <= 1'b1;
                    end
                end
                SET_V_VOLTAGE_ARGUMENT:begin
                    if(SPI_DONE) begin
                        status <= status + 1'b1;
                        start <= 1'b0;
                    end
                    else begin
                        data  <= {2'b00,8'h3E};//command argument
                        start <= 1'b1;
                    end
                end
                default:begin
                    if(SPI_DONE) begin
                        start <= 1'b0;
                        done  <= 1'b1;
                    end
                    else begin
                        data  <= {2'b00,8'hAF};//command argument
                        start <= 1'b1;
                    end
                end
            endcase
        end
    end

    assign  DATA = data;
    assign  SPI_START = start;
    assign  DONE = done;
endmodule

	
	
	
	
