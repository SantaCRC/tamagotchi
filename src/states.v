// module to generate tamagotchi's states
module states (
    input wire clk,
    input wire [3:0] hunger,
    input wire [3:0] happiness,
    input wire [3:0] health,
    input wire [3:0] hygiene,
    input wire [3:0] energy,
    // input wire [3:0] social,
    output reg [6:0] status    
);

// check if tamagotchi is dead or it have any needs
always @(posedge clk) begin
    if (hunger == 4'd15 || happiness == 4'd15 || health == 4'd15 || hygiene == 4'd15 || energy == 4'd15) begin
        status <= 7'b1111111;
    end
    // check if tamagotchi is hungry
    else if (hunger >= 4'd12) begin
        status[0] <= 1'b1;
    end
    // check if tamagotchi is unhappy
    else if (happiness >= 4'd12) begin
        status[1] <= 1'b1;
    end
    // check if tamagotchi is sick
    else if (health >= 4'd12) begin
        status[2] <= 1'b1;
    end
    // check if tamagotchi is dirty
    else if (hygiene >= 4'd12) begin
        status[3] <= 1'b1;
    end
    // check if tamagotchi is tired
    else if (energy >= 4'd12) begin
        status[4] <= 1'b1;
    end
    // check if tamagotchi is lonely
    else if (social >= 4'd12) begin
        status[5] <= 1'b1;
    end
    // check if tamagotchi is ok
    else begin
        status <= 7'b0000000;
    end
end

    
endmodule