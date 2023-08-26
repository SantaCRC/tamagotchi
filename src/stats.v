module stats(
    input wire clk,               // Clock de sistema
    input wire reset,
    input wire [7:0] inputs,            // Señal de reset
    input wire [7:0] random,      // Valor aleatorio de 8 bits
    output reg [3:0] hunger,     // Estadística de hambre
    output reg [3:0] happiness,  // Estadística de felicidad
    output reg [3:0] health,     // Estadística de salud
    output reg [3:0] hygiene,    // Estadística de higiene
    output reg [3:0] energy,     // Estadística de energía
    output reg [3:0] social      // Estadística social
);
    // time counter
    reg [17:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reiniciar estadísticas en caso de reset
            hunger <= 4'd0;
            happiness <= 4'd0;
            health <= 4'd0;
            hygiene <= 4'd0;
            energy <= 4'd0;
            social <= 4'd0;
        end else if (!inputs && count == 18'd1000) begin
            count <= 0;
            // Incrementar estadísticas aleatoriamente si no se presiona ninguna entrada
            case (random[3:0])
                0: hunger <= (hunger < 4'd15) ? hunger + 1 : hunger;
                1: happiness <= (happiness < 4'd15) ? happiness + 1 : happiness;
                2: health <= (health < 4'd15) ? health + 1 : health;
                3: hygiene <= (hygiene < 4'd15) ? hygiene + 1 : hygiene;
                4: energy <= (energy < 4'd15) ? energy + 1 : energy;
                5: social <= (social < 4'd15) ? social + 1 : social;
            endcase
        end else begin
            count <= count + 1;
        end
    end

    always @(posedge clk) begin
        // Decrementar estadísticas si se presiona alguna entrada
        case (inputs)
            8'b00000001: hunger <= (hunger > 4'd0) ? hunger - 1 : hunger;
            8'b00000010: happiness <= (happiness > 4'd0) ? happiness - 1 : happiness;
            8'b00000100: health <= (health > 4'd0) ? health - 1 : health;
            8'b00001000: hygiene <= (hygiene > 4'd0) ? hygiene - 1 : hygiene;
            8'd16: energy <= (energy > 4'd0) ? energy - 5 : energy;
            8'b00100000: social <= (social > 4'd0) ? social - 1 : social;
        endcase
    end

endmodule
