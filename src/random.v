module random(
    input wire clk,      // Clock input
    input wire rst,      // Reset input
    output wire [3:0] rand_out // 4-bit pseudo-random number output
);

reg [3:0] lfsr_reg;     // 4-bit register to hold the LFSR state

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr_reg <= 4'b1111; // Initialize LFSR with all ones
    end else begin
        // XOR feedback taps for a 4-bit LFSR: 4, 3
        lfsr_reg <= {lfsr_reg[2:0], lfsr_reg[3] ^ lfsr_reg[0]};
    end
end

assign rand_out = lfsr_reg;

endmodule