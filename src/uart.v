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

localparam MEMORY_LENGTH = 31;
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
    mem[26] = "N";
    mem[27] = "E";
    mem[28] = "E";
    mem[29] = "D";
    mem[30] = "S";
    mem[31] = "\r";
    mem[32] = "\n";
    mem[33] = " ";
    mem[34] = " ";
    mem[35] = " ";
    mem[36] = " ";
end

localparam TX_STATE_IDLE = 0;
localparam TX_STATE_START_BIT = 1;
localparam TX_STATE_WRITE = 2;
localparam TX_STATE_STOP_BIT = 3;
localparam TX_STATE_DEBOUNCE = 4;

always @(posedge clk) begin
    if (is_sleeping == 1) begin
        mem[10] = "Z";
        mem[12] = "Z";
    end
    if (!is_sleeping && happiness > 4'd9) begin
        mem[10] = "T";
        mem[12] = "T";
        mem[33] = "P";
    end
    if (!is_sleeping && energy > 4'd9) begin
        mem[10] = "O";
        mem[12] = "O";
        mem[34] = "S";
    end
    if (!is_sleeping && hunger > 4'd9) begin
        mem[10] = "@";
        mem[12] = "@";
        mem[35] = "E";
    end
    if (!is_sleeping && hygiene > 4'd9) begin
        mem[10] = "U";
        mem[12] = "U";
        mem[36] = "D";       
    end
    if(hunger == 4'd15 || happiness == 4'd15 || hygiene == 4'd15 || energy == 4'd15) begin
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