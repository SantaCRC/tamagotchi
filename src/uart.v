`default_nettype none

module uart
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input  clk,
    input  uart_rx,
    input  [7:0] status,
    output uart_tx,
    output reg [5:0] led,
    input btn1,
    input wire [7:0] ran_in,
    input wire [4:0] hunger,
    input wire [4:0] happiness,
    input wire [4:0] health,
    input wire [4:0] hygiene,
    input wire [4:0] energy,
    output reg [7:0] dataIn_R,
    input wire is_sleeping
);

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

reg [3:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;
reg [7:0] dataIn = 0;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 5;

always @(posedge clk) begin
    case (rxState)
        RX_STATE_IDLE: begin
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
            end
        end 
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end else 
                rxCounter <= rxCounter + 1;
        end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            rxCounter <= 1;
            dataIn <= {uart_rx, dataIn[7:1]};
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                byteReady <= 1;
            end
        end
    endcase
end


reg [3:0] txState = 0;
reg [24:0] txCounter = 0;
reg [7:0] dataOut = 0;
reg txPinRegister = 1;
reg [2:0] txBitNumber = 0;
reg [7:0] txByteCounter = 0;

assign uart_tx = txPinRegister;

localparam MEMORY_LENGTH = 80;
reg [7:0] mem [MEMORY_LENGTH-1:0];

// (\__/)
// (>'.'<)
// (")_(")

initial begin
    mem[0] = "(";
    mem[1] = "\\";
    mem[2] = "_";
    mem[3] = "_";
    mem[4] = "/";
    mem[5] = ")";
    mem[6] = "\r";  
    mem[7] = "\n";
    mem[8] = "(";
    mem[9] = ">";
    mem[10] = "'";
    mem[11] = ".";
    mem[12] = "'";
    mem[13] = "<";
    mem[14] = ")";
    mem[15] = "\r";
    mem[16] = "\n";
    mem[17] = "(";
    mem[18] = "\"";
    mem[19] = ")";
    mem[20] = "_";
    mem[21] = "(";
    mem[22] = "\"";
    mem[23] = ")";
    mem[24] = "\r";
    mem[25] = "\n";
    mem[26] = "S";
    mem[27] = "T";
    mem[28] = "A";
    mem[29] = "T";
    mem[30] = "S";
    mem[31] = "\r";
    mem[32] = "\n";
    mem[33] = "H";
    mem[34] = "U";
    mem[35] = ":";
    mem[36] = " ";
    mem[37] = "0";
    mem[38] = "0";
    mem[39] = "\r";
    mem[40] = "\n";
    mem[41] = "H";
    mem[42] = "A";
    mem[43] = ":";
    mem[44] = " ";
    mem[45] = "0";
    mem[46] = "0";
    mem[47] = "\r";
    mem[48] = "\n";
    mem[49] = "H";
    mem[50] = "E";
    mem[51] = ":";
    mem[52] = " ";
    mem[53] = "0";
    mem[54] = "0";
    mem[55] = "\r";
    mem[56] = "\n";
    mem[57] = "H";
    mem[58] = "Y";
    mem[59] = ":";
    mem[60] = " ";
    mem[61] = "0";
    mem[62] = "0";
    mem[63] = "\r";
    mem[64] = "\n";
    mem[65] = "E";
    mem[66] = ":";
    mem[67] = " ";
    mem[68] = "0";
    mem[69] = "0";
    mem[70] = "\r";
    mem[71] = "\n";
    mem[72] = "S";
    mem[73] = "O";
    mem[74] = ":";
    mem[75] = " ";
    mem[76] = "0";
    mem[77] = "0";
    mem[78] = "\r";
    mem[79] = "\n";
    // clear screen
    mem[80] = "C";


end

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;

always @(posedge clk) begin
    // case hunger
    case (hunger)
        4'd0: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "0";
        end
        4'd1: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "1";
        end
        4'd2: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "2";
        end
        4'd3: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "3";
        end
        4'd4: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "4";
        end
        4'd5: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "5";
        end
        4'd6: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "6";
        end
        4'd7: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "7";
        end
        4'd8: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "8";
        end
        4'd9: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "0";
            mem[38] = "9";
        end
        4'd10: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "1";
            mem[38] = "0";
        end
        4'd11: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "1";
            mem[38] = "1";
        end
        4'd12: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "1";
            mem[38] = "2";
        end
        4'd13: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "1";
            mem[38] = "3";
        end
        4'd14: begin
            mem[10] = "'";
            mem[12] = "'";
            mem[37] = "1";
            mem[38] = "4";
        end
        4'd15: begin
            mem[37] = "1";
            mem[38] = "5";
            
            
        end
        default: begin
            mem[37] = "0";
            mem[38] = "0";
        end
    endcase

    // case happiness
    case (15-happiness)
    4'd0: begin
        mem[45] = "0";
        mem[46] = "0";
    end
    4'd1: begin
        mem[45] = "0";
        mem[46] = "1";
    end
    4'd2: begin
        mem[45] = "0";
        mem[46] = "2";
    end
    4'd3: begin
        mem[45] = "0";
        mem[46] = "3";
    end
    4'd4: begin
        mem[45] = "0";
        mem[46] = "4";
    end
    4'd5: begin
        mem[45] = "0";
        mem[46] = "5";
    end
    4'd6: begin
        mem[45] = "0";
        mem[46] = "6";
    end
    4'd7: begin
        mem[45] = "0";
        mem[46] = "7";
    end
    4'd8: begin
        mem[45] = "0";
        mem[46] = "8";
    end
    4'd9: begin
        mem[45] = "0";
        mem[46] = "9";
    end
    4'd10: begin
        mem[45] = "1";
        mem[46] = "0";
    end
    4'd11: begin
        mem[45] = "1";
        mem[46] = "1";
    end
    4'd12: begin
        mem[45] = "1";
        mem[46] = "2";
    end
    4'd13: begin
        mem[45] = "1";
        mem[46] = "3";
    end
    4'd14: begin
        mem[45] = "1";
        mem[46] = "4";
    end
    4'd15: begin
        mem[45] = "1";
        mem[46] = "5";
        
        
    end
    default: begin
        mem[45] = "0";
        mem[46] = "0";
    end
endcase

    // case health
    case (15-health)
    4'd0: begin
        mem[53] = "0";
        mem[54] = "0";
    end
    4'd1: begin
        mem[53] = "0";
        mem[54] = "1";
    end
    4'd2: begin
        mem[53] = "0";
        mem[54] = "2";
    end
    4'd3: begin
        mem[53] = "0";
        mem[54] = "3";
    end
    4'd4: begin
        mem[53] = "0";
        mem[54] = "4";
    end
    4'd5: begin
        mem[53] = "0";
        mem[54] = "5";
    end
    4'd6: begin
        mem[53] = "0";
        mem[54] = "6";
    end
    4'd7: begin
        mem[53] = "0";
        mem[54] = "7";
    end
    4'd8: begin
        mem[53] = "0";
        mem[54] = "8";
    end
    4'd9: begin
        mem[53] = "0";
        mem[54] = "9";
    end
    4'd10: begin
        mem[53] = "1";
        mem[54] = "0";
    end
    4'd11: begin
        mem[53] = "1";
        mem[54] = "1";
    end
    4'd12: begin
        mem[53] = "1";
        mem[54] = "2";
    end
    4'd13: begin
        mem[53] = "1";
        mem[54] = "3";
    end
    4'd14: begin
        mem[53] = "1";
        mem[54] = "4";
    end
    4'd15: begin
        mem[53] = "1";
        mem[54] = "5";
        
        
    end
    default: begin
        mem[53] = "0";
        mem[54] = "0";
    end

    endcase

    // case hygiene
    case (15-hygiene)
    4'd0: begin
        mem[61] = "0";
        mem[62] = "0";
    end
    4'd1: begin
        mem[61] = "0";
        mem[62] = "1";
    end
    4'd2: begin
        mem[61] = "0";
        mem[62] = "2";
    end
    4'd3: begin
        mem[61] = "0";
        mem[62] = "3";
    end
    4'd4: begin
        mem[61] = "0";
        mem[62] = "4";
    end
    4'd5: begin
        mem[61] = "0";
        mem[62] = "5";
    end
    4'd6: begin
        mem[61] = "0";
        mem[62] = "6";
    end
    4'd7: begin
        mem[61] = "0";
        mem[62] = "7";
    end
    4'd8: begin
        mem[61] = "0";
        mem[62] = "8";
    end
    4'd9: begin
        mem[61] = "0";
        mem[62] = "9";
    end
    4'd10: begin
        mem[61] = "1";
        mem[62] = "0";
    end
    4'd11: begin
        mem[61] = "1";
        mem[62] = "1";
    end
    4'd12: begin
        mem[61] = "1";
        mem[62] = "2";
    end
    4'd13: begin
        mem[61] = "1";
        mem[62] = "3";
    end
    4'd14: begin
        mem[61] = "1";
        mem[62] = "4";
    end
    4'd15: begin
        mem[61] = "1";
        mem[62] = "5";
        
        
    end
    default: begin
        mem[61] = "0";
        mem[62] = "0";
    end
    endcase

    // case energy
    case (15-energy)
    4'd0: begin
        mem[68] = "0";
        mem[69] = "0";
    end
    4'd1: begin
        mem[68] = "0";
        mem[69] = "1";
    end
    4'd2: begin
        mem[68] = "0";
        mem[69] = "2";
    end
    4'd3: begin
        mem[68] = "0";
        mem[69] = "3";
    end
    4'd4: begin
        mem[68] = "0";
        mem[69] = "4";
    end
    4'd5: begin
        mem[68] = "0";
        mem[69] = "5";
    end
    4'd6: begin
        mem[68] = "0";
        mem[69] = "6";
    end
    4'd7: begin
        mem[68] = "0";
        mem[69] = "7";
    end
    4'd8: begin
        mem[68] = "0";
        mem[69] = "8";
    end
    4'd9: begin
        mem[68] = "0";
        mem[69] = "9";
    end
    4'd10: begin
        mem[68] = "1";
        mem[69] = "0";
    end
    4'd11: begin
        mem[68] = "1";
        mem[69] = "1";
    end
    4'd12: begin
        mem[68] = "1";
        mem[69] = "2";
    end
    4'd13: begin
        mem[68] = "1";
        mem[69] = "3";
    end
    4'd14: begin
        mem[68] = "1";
        mem[69] = "4";
    end
    4'd15: begin
        mem[68] = "1";
        mem[69] = "5";
        
        
    end
    default: begin
        mem[68] = "0";
        mem[69] = "0";
    end
    endcase

    if (is_sleeping == 1) begin
        mem[10] = "Z";
        mem[12] = "Z";
    end
    if (!is_sleeping && happiness > 4'd9) begin
        mem[10] = "T";
        mem[12] = "T";
    end
    if (!is_sleeping && hygiene > 4'd9) begin
        mem[10] = "%";
        mem[12] = "%";
    end
    if (!is_sleeping && energy > 4'd9) begin
        mem[10] = "O";
        mem[12] = "O";
    end
    if (!is_sleeping && health > 4'd9) begin
        mem[10] = "~";
        mem[12] = "~";
    end 
    if (!is_sleeping && hunger > 4'd9) begin
        mem[10] = "@";
        mem[12] = "@";
    end
    if(hunger == 4'd15 || happiness == 4'd15 || health == 4'd15 || hygiene == 4'd15 || energy == 4'd15) begin
        mem[10] = "X";
        mem[12] = "X";
    end


    case (txState)
        TX_STATE_IDLE: begin
            if (btn1 == 0) begin
                txState <= TX_STATE_START_BIT;
                txCounter <= 0;
                txByteCounter <= 0;
            end
            else begin
                txPinRegister <= 1;
            end
        end 
        TX_STATE_START_BIT: begin
            txPinRegister <= 0;
            if ((txCounter + 1) == DELAY_FRAMES) begin
                txState <= TX_STATE_WRITE;
                dataOut <= mem[txByteCounter];
                txBitNumber <= 0;
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_WRITE: begin
            txPinRegister <= dataOut[txBitNumber];
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txBitNumber == 3'b111) begin
                    txState <= TX_STATE_STOP_BIT;
                end else begin
                    txState <= TX_STATE_WRITE;
                    txBitNumber <= txBitNumber + 1;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_STOP_BIT: begin
            txPinRegister <= 1;
            if ((txCounter + 1) == DELAY_FRAMES) begin
                if (txByteCounter == MEMORY_LENGTH - 1) begin
                    txState <= TX_STATE_DEBOUNCE;
                end else begin
                    txByteCounter <= txByteCounter + 1;
                    txState <= TX_STATE_START_BIT;
                end
                txCounter <= 0;
            end else 
                txCounter <= txCounter + 1;
        end
        TX_STATE_DEBOUNCE: begin
            if (txCounter == 23'b111111111111111111) begin
                if (btn1 == 1) 
                    txState <= TX_STATE_IDLE;
            end else
                txCounter <= txCounter + 1;
        end
    endcase      
end

always @(posedge clk) begin
    if (byteReady) begin
        dataIn_R <= dataIn;
    end
    else begin
        dataIn_R <= 8'h00;
    end
end

endmodule