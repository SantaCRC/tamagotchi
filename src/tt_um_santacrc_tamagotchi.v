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
    reg [3:0] hunger = 4'd0;
    reg [3:0] happiness = 4'd0;
    reg [3:0] health = 4'd0;
    reg [3:0] hygiene = 4'd0;
    reg [3:0] energy = 4'd0;
    reg [3:0] social = 4'd0;

    // status register
    reg [6:0] status = 7'b0000000;

    // output status to leds
    assign led_out = status;
    

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;

    // random number register
    reg [31:0] random = 32'h00000000;

    // seed register
    reg [31:0] seed = 32'h00001000;

    // taps register
    reg [7:0] taps = 8'hE1;

    // call random module
    random random(
        .in_clk(clk),
        .in_n_rst(reset),
        .taps(taps),
        .reset_value(seed),
        .computed_value(random)
    );

    // call stats module
    stats stats(
        .clk(clk),
        .hunger(hunger),
        .happiness(happiness),
        .health(health),
        .hygiene(hygiene),
        .energy(energy),
        .social(social),
        .inputs(ui_in),
        .random(random)
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



endmodule
