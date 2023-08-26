module stats(
    input wire clk,               // Clock de sistema
    input wire reset,            // Señal de reset
    input wire [7:0] inputs,     // Señal de entrada de botones
    input wire [7:0] random,     // Valor aleatorio de 8 bits
    output reg [3:0] hunger,     // Estadística de hambre
    output reg [3:0] happiness,  // Estadística de felicidad
    output reg [3:0] health,     // Estadística de salud
    output reg [3:0] hygiene,    // Estadística de higiene
    output reg [3:0] energy,     // Estadística de energía
    output reg [3:0] social      // Estadística social
);

    reg [17:0] count = 0; // Contador de tiempo

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reiniciar estadísticas en caso de reset
            {hunger, happiness, health, hygiene, energy, social} <= 6'b0;
        end else begin
            // Incrementar estadísticas aleatoriamente si no se presiona ninguna entrada
            if (!inputs && count == 18'd1000) begin
                count <= 0;
                case (random[1:0])
                    2'b00: hunger <= (hunger < 4'd15) ? hunger + 1 : hunger;
                    2'b01: happiness <= (happiness < 4'd15) ? happiness + 1 : happiness;
                    2'b10: health <= (health < 4'd15) ? health + 1 : health;
                    2'b11: hygiene <= (hygiene < 4'd15) ? hygiene + 1 : hygiene;
                endcase
            end else begin
                count <= count + 1;
            end
        end
    end

    always @(posedge clk) begin
        // Decrementar estadísticas si se presiona alguna entrada
        if (inputs[0]) hunger <= (hunger > 4'd0) ? hunger - 1 : hunger;
        if (inputs[1]) happiness <= (happiness > 4'd0) ? happiness - 1 : happiness;
        if (inputs[2]) health <= (health > 4'd0) ? health - 1 : health;
        if (inputs[3]) hygiene <= (hygiene > 4'd0) ? hygiene - 1 : hygiene;
        if (inputs[4]) energy <= (energy > 4'd0) ? energy - 5 : energy;
        if (inputs[5]) social <= (social > 4'd0) ? social - 1 : social;
    end

endmodule
