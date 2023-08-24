// module to manage tamagotchi's stats for the game, exaple: hunger, happiness, etc.
module stats(
    input wire clk, // 27 MHz clock
    output reg [3:0] hunger,
    output reg [3:0] happiness,
    output reg [3:0] health,
    output reg [3:0] hygiene,
    output reg [3:0] energy,
    output reg [3:0] social,
    input wire [7:0] inputs,
);

// update randomly one of the stats every 1 second
reg [26:0] count = 0;

always @(posedge clk) begin
    if (count == 27'd10_000_000) begin
        count <= 0;
        // generate random number between 0 and 5
        reg [2:0] random = $random % 6;
        case (random)
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

// logic to decrease stats
always @(posedge clk) begin
    if (inputs[0] == 1'b1) begin
        if (hunger > 4'd0) begin
            hunger <= hunger - 1;
        end
    end
    if (inputs[1] == 1'b1) begin
        if (happiness > 4'd0) begin
            happiness <= happiness - 1;
        end
    end
    if (inputs[2] == 1'b1) begin
        if (health > 4'd0) begin
            health <= health - 1;
        end
    end
    if (inputs[3] == 1'b1) begin
        if (hygiene > 4'd0) begin
            hygiene <= hygiene - 1;
        end
    end
    if (inputs[4] == 1'b1) begin
        if (energy > 4'd0) begin
            energy <= energy - 1;
        end
    end
    if (inputs[5] == 1'b1) begin
        if (social > 4'd0) begin
            social <= social - 1;
        end
    end
end




endmodule