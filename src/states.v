// module to generate tamagotchi's states
module states (
    input wire clk,
    input wire reset,
    input wire [3:0] hunger,
    input wire [4:0] happiness,
    input wire [3:0] health,
    input wire [3:0] hygiene,
    input wire [3:0] energy,
    input wire [3:0] social,
    output reg [7:0] status    
);

// check if tamagotchi is dead or it have any needs
always @(posedge clk) begin
    if (hunger == 4'd15) begin
        status <= 8'b11111111;
    end
    // check if tamagotchi is hungry
    else if (hunger >= 4'd12) begin
        status[0] <= 1'b1;
    end
    // check if tamagotchi is unhappy
    else if (happiness >= 5'd12) begin
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
        status <= 8'b00000000;
    end
end

    
endmodule