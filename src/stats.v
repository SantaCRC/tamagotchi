module stats(
    input wire clk, // 27 MHz clock
    input wire reset, // reset
    input wire [7:0] inputs,
    output reg [3:0] hunger,
    output reg [3:0] happiness,
    output reg [3:0] health,
    output reg [3:0] hygiene,
    output reg [3:0] energy,
    output reg [3:0] social
);

reg [26:0] count = 0;

wire [3:0] random_number;
reg clk_1hz = 0;

// generate random number
random random(
    .clk(clk_1hz),
    .rst(reset),
    .rand_out(random_number)
);


// logic to increment stats

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
        if (count == 27'd1000) begin
            clk_1hz <= 1;
            count <= 0;
            case (random_number)
                6: begin
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
            clk_1hz <= 0;
        end
    end
end

// logic to decrement stats
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
end

endmodule
