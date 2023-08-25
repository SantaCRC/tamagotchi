module stats(
    input wire clk, // 27 MHz clock
    input wire reset, // reset
    input wire [7:0] inputs,
    input wire [3:0] random,
    output reg [3:0] hunger,
    output reg [3:0] happiness,
    output reg [3:0] health,
    output reg [3:0] hygiene,
    output reg [3:0] energy,
    output reg [3:0] social
);

reg [26:0] count = 0;
reg [2:0] state = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize all stats including social to 0 on reset
        hunger <= 4'd0;
        happiness <= 4'd0;
        health <= 4'd0;
        hygiene <= 4'd0;
        energy <= 4'd0;
        social <= 4'd0;
    end else begin
        if (count == 27'd10_000_000) begin
            count <= 0;
            state <= state + 1;
            case (state)
                0: begin
                    if (hunger < 4'd15) begin
                        hunger <= hunger + 1;
                    end
                end
                1: begin
                    if (happiness < 4'd15) begin
                        happiness <= happiness + 1;
                    end
                end
                2: begin
                    if (health < 4'd15) begin
                        health <= health + 1;
                    end
                end
                3: begin
                    if (hygiene < 4'd15) begin
                        hygiene <= hygiene + 1;
                    end
                end
                4: begin
                    if (energy < 4'd15) begin
                        energy <= energy + 1;
                    end
                end
                5: begin
                    if (social < 4'd15) begin
                        social <= social + 1;
                    end
                end
            endcase
        end
        else begin
            count <= count + 1;
        end
    end
end

endmodule
