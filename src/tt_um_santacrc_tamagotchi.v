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

    // stats registers
    reg [3:0] hunger;
    reg [3:0] happiness;
    reg [3:0] health;
    reg [3:0] hygiene;
    reg [3:0] energy;
    reg [3:0] social;


    // status register
    reg [6:0] status;

    // output status to leds
    assign uo_out = status;
    assign uio_out = status;
    
    // random number
    wire [7:0] random_number;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;


    // call stats module
    stats stats(
        .clk(clk),
        .random(random_number),
        .reset(reset),
        .hunger(hunger),
        .happiness(happiness),
        .health(health),
        .hygiene(hygiene),
        .energy(energy),
        .social(social),
        .inputs(ui_in)
    );

    // call states module
    states states(
        .clk(clk),
        .hunger(hunger),
        .happiness(happiness),
        .health(health),
        .hygiene(hygiene),
        .energy(energy),
        .social(social),
        .status(status)
    );

    // call random module
    random random(
        .clk(clk),
        .rst(reset),
        .rand_out(random_number)
    );
    
    // call uart module
    // uart uart(
    //     .clk(clk),
    //     .uart_rx(ui_in[0]),
    //     .uart_tx(uo_out[0]),
    //     .led(uo_out[6:1]),
    //     .btn1(ui_in[1])
    // );

endmodule
