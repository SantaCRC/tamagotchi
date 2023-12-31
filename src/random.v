module random(
    input wire clk,           // Clock input
    input wire rst,           // Reset input
    output wire [7:0] rand_out // 8-bit pseudo-random number output
);

reg [7:0] lfsr_reg;          // 8-bit register to hold the LFSR state

always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr_reg <= 8'b1111_1111; // Initialize LFSR with all ones
    end else begin
        // XOR feedback taps for an 8-bit LFSR: 8, 6, 5, 4
        lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[4] ^ lfsr_reg[5] ^ lfsr_reg[3]};
    end
end

assign rand_out = lfsr_reg;

endmodule
