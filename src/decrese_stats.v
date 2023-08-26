module decrease_stats (
    input wire clk,   // Clock input
    input wire reset, // Reset input
    input wire [7:0] inputs,
    inout reg [3:0] hunger,
    inout reg [3:0] happiness,
    inout reg [3:0] health,
    inout reg [3:0] hygiene,
    inout reg [3:0] energy,
    inout reg [3:0] social
);

    reg [26:0] count = 0;
    wire [7:0] random_number;

    // generate random number
    random random (
        .clk(clk),
        .rst(reset),
        .rand_out(random_number)
    );

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
            // Increase stats randomly if no button is pressed
            if (count == 27'd1000 && !inputs) begin
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
            end
        end
    end

endmodule
