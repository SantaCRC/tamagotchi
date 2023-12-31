`default_nettype none

module tt_um_santacrc_tamagotchi #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    wire reset = ! rst_n;
    wire [6:0] led_out;
    reg [5:0] led_out_reg;
    wire second;
    wire [7:0] dataIn;
    wire rx = ui_in[0];
    wire tx = uo_out[0];	
    assign uo_out[7:1] = 7'b0000000;
    wire is_sleeping;

    // stats registers
    reg [4:0] hunger;
    reg [4:0] happiness;
    reg [4:0] hygiene;
    reg [4:0] energy;
    reg [4:0] social;

    reg [5:0] inputs_s = 6'b000000;

    // inputs

    
    // random number
    wire [7:0] random_number;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // output status to leds
    assign uio_out = 8'b00000000;


    // tamagotchi's animation

   // call stats module
    stats stats(
        .clk(clk),
        .random(random_number),
        .second(second),
        .hunger(hunger),
        .happiness(happiness),
        .hygiene(hygiene),
        .energy(energy),
        .social(social),
        .inputs(dataIn),
        .reset(reset),
        .is_sleeping(is_sleeping)
    );

    // call random module
    random random(
        .clk(clk),
        .rst(reset),
        .rand_out(random_number)
    );
    
    // call uart module
    uart uart(
        .clk(clk),
        .uart_rx(rx),
        .uart_tx(tx),
        .dataIn_R(dataIn),
        .led(led_out_reg),
        .btn1(second),
        .ran_in(random_number),
        .hunger(hunger),
        .happiness(happiness),
        .hygiene(hygiene),
        .energy(energy),
        .social(social),
        .is_sleeping(is_sleeping)
    );

endmodule
