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
    input wire [4:0] social,
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
reg [7:0] testMemory [MEMORY_LENGTH-1:0];

// (\__/)
// (>'.'<)
// (")_(")

initial begin
    testMemory[0] = "(";
    testMemory[1] = "\\";
    testMemory[2] = "_";
    testMemory[3] = "_";
    testMemory[4] = "/";
    testMemory[5] = ")";
    testMemory[6] = "\r";  
    testMemory[7] = "\n";
    testMemory[8] = "(";
    testMemory[9] = ">";
    testMemory[10] = "'";
    testMemory[11] = ".";
    testMemory[12] = "'";
    testMemory[13] = "<";
    testMemory[14] = ")";
    testMemory[15] = "\r";
    testMemory[16] = "\n";
    testMemory[17] = "(";
    testMemory[18] = "\"";
    testMemory[19] = ")";
    testMemory[20] = "_";
    testMemory[21] = "(";
    testMemory[22] = "\"";
    testMemory[23] = ")";
    testMemory[24] = "\r";
    testMemory[25] = "\n";
    testMemory[26] = "S";
    testMemory[27] = "T";
    testMemory[28] = "A";
    testMemory[29] = "T";
    testMemory[30] = "S";
    testMemory[31] = "\r";
    testMemory[32] = "\n";
    testMemory[33] = "H";
    testMemory[34] = "U";
    testMemory[35] = ":";
    testMemory[36] = " ";
    testMemory[37] = "0";
    testMemory[38] = "0";
    testMemory[39] = "\r";
    testMemory[40] = "\n";
    testMemory[41] = "H";
    testMemory[42] = "A";
    testMemory[43] = ":";
    testMemory[44] = " ";
    testMemory[45] = "0";
    testMemory[46] = "0";
    testMemory[47] = "\r";
    testMemory[48] = "\n";
    testMemory[49] = "H";
    testMemory[50] = "E";
    testMemory[51] = ":";
    testMemory[52] = " ";
    testMemory[53] = "0";
    testMemory[54] = "0";
    testMemory[55] = "\r";
    testMemory[56] = "\n";
    testMemory[57] = "H";
    testMemory[58] = "Y";
    testMemory[59] = ":";
    testMemory[60] = " ";
    testMemory[61] = "0";
    testMemory[62] = "0";
    testMemory[63] = "\r";
    testMemory[64] = "\n";
    testMemory[65] = "E";
    testMemory[66] = ":";
    testMemory[67] = " ";
    testMemory[68] = "0";
    testMemory[69] = "0";
    testMemory[70] = "\r";
    testMemory[71] = "\n";
    testMemory[72] = "S";
    testMemory[73] = "O";
    testMemory[74] = ":";
    testMemory[75] = " ";
    testMemory[76] = "0";
    testMemory[77] = "0";
    testMemory[78] = "\r";
    testMemory[79] = "\n";
    // clear screen
    testMemory[80] = "C";


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
            
            
            testMemory[37] = "0";
            testMemory[38] = "0";
        end
        4'd1: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "1";
        end
        4'd2: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "2";
        end
        4'd3: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "3";
        end
        4'd4: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "4";
        end
        4'd5: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "5";
        end
        4'd6: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "6";
        end
        4'd7: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "7";
        end
        4'd8: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "8";
        end
        4'd9: begin
            
            
            testMemory[37] = "0";
            testMemory[38] = "9";
        end
        4'd10: begin
            
            
            testMemory[37] = "1";
            testMemory[38] = "0";
        end
        4'd11: begin
            
            
            testMemory[37] = "1";
            testMemory[38] = "1";
        end
        4'd12: begin
            
            
            testMemory[37] = "1";
            testMemory[38] = "2";
        end
        4'd13: begin
            
            
            testMemory[37] = "1";
            testMemory[38] = "3";
        end
        4'd14: begin
            
            
            testMemory[37] = "1";
            testMemory[38] = "4";
        end
        4'd15: begin
            testMemory[37] = "1";
            testMemory[38] = "5";
            
            
        end
        default: begin
            testMemory[37] = "0";
            testMemory[38] = "0";
        end
    endcase

    // case happiness
    case (15-happiness)
    4'd0: begin
        testMemory[45] = "0";
        testMemory[46] = "0";
    end
    4'd1: begin
        testMemory[45] = "0";
        testMemory[46] = "1";
    end
    4'd2: begin
        testMemory[45] = "0";
        testMemory[46] = "2";
    end
    4'd3: begin
        testMemory[45] = "0";
        testMemory[46] = "3";
    end
    4'd4: begin
        testMemory[45] = "0";
        testMemory[46] = "4";
    end
    4'd5: begin
        testMemory[45] = "0";
        testMemory[46] = "5";
    end
    4'd6: begin
        testMemory[45] = "0";
        testMemory[46] = "6";
    end
    4'd7: begin
        testMemory[45] = "0";
        testMemory[46] = "7";
    end
    4'd8: begin
        testMemory[45] = "0";
        testMemory[46] = "8";
    end
    4'd9: begin
        testMemory[45] = "0";
        testMemory[46] = "9";
    end
    4'd10: begin
        testMemory[45] = "1";
        testMemory[46] = "0";
    end
    4'd11: begin
        testMemory[45] = "1";
        testMemory[46] = "1";
    end
    4'd12: begin
        testMemory[45] = "1";
        testMemory[46] = "2";
    end
    4'd13: begin
        testMemory[45] = "1";
        testMemory[46] = "3";
    end
    4'd14: begin
        testMemory[45] = "1";
        testMemory[46] = "4";
    end
    4'd15: begin
        testMemory[45] = "1";
        testMemory[46] = "5";
        
        
    end
    default: begin
        testMemory[45] = "0";
        testMemory[46] = "0";
    end
endcase

    // case health
    case (15-health)
    4'd0: begin
        testMemory[53] = "0";
        testMemory[54] = "0";
    end
    4'd1: begin
        testMemory[53] = "0";
        testMemory[54] = "1";
    end
    4'd2: begin
        testMemory[53] = "0";
        testMemory[54] = "2";
    end
    4'd3: begin
        testMemory[53] = "0";
        testMemory[54] = "3";
    end
    4'd4: begin
        testMemory[53] = "0";
        testMemory[54] = "4";
    end
    4'd5: begin
        testMemory[53] = "0";
        testMemory[54] = "5";
    end
    4'd6: begin
        testMemory[53] = "0";
        testMemory[54] = "6";
    end
    4'd7: begin
        testMemory[53] = "0";
        testMemory[54] = "7";
    end
    4'd8: begin
        testMemory[53] = "0";
        testMemory[54] = "8";
    end
    4'd9: begin
        testMemory[53] = "0";
        testMemory[54] = "9";
    end
    4'd10: begin
        testMemory[53] = "1";
        testMemory[54] = "0";
    end
    4'd11: begin
        testMemory[53] = "1";
        testMemory[54] = "1";
    end
    4'd12: begin
        testMemory[53] = "1";
        testMemory[54] = "2";
    end
    4'd13: begin
        testMemory[53] = "1";
        testMemory[54] = "3";
    end
    4'd14: begin
        testMemory[53] = "1";
        testMemory[54] = "4";
    end
    4'd15: begin
        testMemory[53] = "1";
        testMemory[54] = "5";
        
        
    end
    default: begin
        testMemory[53] = "0";
        testMemory[54] = "0";
    end

    endcase

    // case hygiene
    case (15-hygiene)
    4'd0: begin
        testMemory[61] = "0";
        testMemory[62] = "0";
    end
    4'd1: begin
        testMemory[61] = "0";
        testMemory[62] = "1";
    end
    4'd2: begin
        testMemory[61] = "0";
        testMemory[62] = "2";
    end
    4'd3: begin
        testMemory[61] = "0";
        testMemory[62] = "3";
    end
    4'd4: begin
        testMemory[61] = "0";
        testMemory[62] = "4";
    end
    4'd5: begin
        testMemory[61] = "0";
        testMemory[62] = "5";
    end
    4'd6: begin
        testMemory[61] = "0";
        testMemory[62] = "6";
    end
    4'd7: begin
        testMemory[61] = "0";
        testMemory[62] = "7";
    end
    4'd8: begin
        testMemory[61] = "0";
        testMemory[62] = "8";
    end
    4'd9: begin
        testMemory[61] = "0";
        testMemory[62] = "9";
    end
    4'd10: begin
        testMemory[61] = "1";
        testMemory[62] = "0";
    end
    4'd11: begin
        testMemory[61] = "1";
        testMemory[62] = "1";
    end
    4'd12: begin
        testMemory[61] = "1";
        testMemory[62] = "2";
    end
    4'd13: begin
        testMemory[61] = "1";
        testMemory[62] = "3";
    end
    4'd14: begin
        testMemory[61] = "1";
        testMemory[62] = "4";
    end
    4'd15: begin
        testMemory[61] = "1";
        testMemory[62] = "5";
        
        
    end
    default: begin
        testMemory[61] = "0";
        testMemory[62] = "0";
    end
    endcase

    // case energy
    case (15-energy)
    4'd0: begin
        testMemory[68] = "0";
        testMemory[69] = "0";
    end
    4'd1: begin
        testMemory[68] = "0";
        testMemory[69] = "1";
    end
    4'd2: begin
        testMemory[68] = "0";
        testMemory[69] = "2";
    end
    4'd3: begin
        testMemory[68] = "0";
        testMemory[69] = "3";
    end
    4'd4: begin
        testMemory[68] = "0";
        testMemory[69] = "4";
    end
    4'd5: begin
        testMemory[68] = "0";
        testMemory[69] = "5";
    end
    4'd6: begin
        testMemory[68] = "0";
        testMemory[69] = "6";
    end
    4'd7: begin
        testMemory[68] = "0";
        testMemory[69] = "7";
    end
    4'd8: begin
        testMemory[68] = "0";
        testMemory[69] = "8";
    end
    4'd9: begin
        testMemory[68] = "0";
        testMemory[69] = "9";
    end
    4'd10: begin
        testMemory[68] = "1";
        testMemory[69] = "0";
    end
    4'd11: begin
        testMemory[68] = "1";
        testMemory[69] = "1";
    end
    4'd12: begin
        testMemory[68] = "1";
        testMemory[69] = "2";
    end
    4'd13: begin
        testMemory[68] = "1";
        testMemory[69] = "3";
    end
    4'd14: begin
        testMemory[68] = "1";
        testMemory[69] = "4";
    end
    4'd15: begin
        testMemory[68] = "1";
        testMemory[69] = "5";
        
        
    end
    default: begin
        testMemory[68] = "0";
        testMemory[69] = "0";
    end
    endcase
    // case social
    case (15-social)
    4'd0: begin
        testMemory[76] = "0";
        testMemory[77] = "0";
    end
    4'd1: begin
        testMemory[76] = "0";
        testMemory[77] = "1";
    end
    4'd2: begin
        testMemory[76] = "0";
        testMemory[77] = "2";
    end
    4'd3: begin
        testMemory[76] = "0";
        testMemory[77] = "3";
    end
    4'd4: begin
        testMemory[76] = "0";
        testMemory[77] = "4";
    end
    4'd5: begin
        testMemory[76] = "0";
        testMemory[77] = "5";
    end
    4'd6: begin
        testMemory[76] = "0";
        testMemory[77] = "6";
    end
    4'd7: begin
        testMemory[76] = "0";
        testMemory[77] = "7";
    end
    4'd8: begin
        testMemory[76] = "0";
        testMemory[77] = "8";
    end
    4'd9: begin
        testMemory[76] = "0";
        testMemory[77] = "9";
    end
    4'd10: begin
        testMemory[76] = "1";
        testMemory[77] = "0";
    end
    4'd11: begin
        testMemory[76] = "1";
        testMemory[77] = "1";
    end
    4'd12: begin
        testMemory[76] = "1";
        testMemory[77] = "2";
    end
    4'd13: begin
        testMemory[76] = "1";
        testMemory[77] = "3";
    end
    4'd14: begin
        testMemory[76] = "1";
        testMemory[77] = "4";
    end
    4'd15: begin
        testMemory[76] = "1";
        testMemory[77] = "5";     
    end
    default: begin
        testMemory[76] = "0";
        testMemory[77] = "0";
    end
    endcase

    if (is_sleeping == 1) begin
        testMemory[10] = "Z";
        testMemory[12] = "Z";
    end
    if (!is_sleeping && social > 4'd9) begin
        testMemory[10] = "-";
        testMemory[12] = "-";
    end
    if (!is_sleeping && happiness > 4'd9) begin
        testMemory[10] = "T";
        testMemory[12] = "T";
    end
    // if (!is_sleeping && hygiene > 4'd9) begin
    //     testMemory[10] = "%";
    //     testMemory[12] = "%";
    // end
    if (!is_sleeping && energy > 4'd9) begin
        testMemory[10] = "O";
        testMemory[12] = "O";
    end
    if (!is_sleeping && health > 4'd9) begin
        testMemory[10] = "~";
        testMemory[12] = "~";
    end 
    if (!is_sleeping && hunger > 4'd9) begin
        testMemory[10] = "@";
        testMemory[12] = "@";
    end
    if(hunger == 4'd15 || happiness == 4'd15 || health == 4'd15 || hygiene == 4'd15 || energy == 4'd15 || social == 4'd15) begin
        testMemory[10] = "X";
        testMemory[12] = "X";
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
                dataOut <= testMemory[txByteCounter];
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