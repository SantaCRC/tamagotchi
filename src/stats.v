module stats(
    input wire clk,       // Clock de sistema
    input wire reset,     // Señal de reset
    input wire [7:0] inputs, // Señal de entrada de botones
    input wire [7:0] random, // Valor aleatorio de 8 bits
    output reg second,    // Segundo de la animación
    output reg [3:0] hunger,     // Estadística de hambre
    output reg [4:0] happiness,  // Estadística de felicidad
    output reg [3:0] health,     // Estadística de salud
    output reg [3:0] hygiene,    // Estadística de higiene
    output reg [3:0] energy,     // Estadística de energía
    output reg [3:0] social      // Estadística social
);

    reg [27:0] count = 0; // Contador de tiempo
    reg only_one = 0; // Bandera para evitar que se incrementen las estadísticas más de una vez por segundo

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reiniciar estadísticas en caso de reset
            hunger <= 0;
            happiness <= 0;
            health <= 0;
            hygiene <= 0;
            energy <= 0;
            social <= 0;
            count <= 0; // Reiniciar el contador cuando se presiona el botón de reset
        end else begin
            if (count == 28'd27000000) begin
                count <= 0;
                second = ~second; // Cambiar el segundo de la animación
                // Incrementar estadísticas aleatoriamente si no se presiona ninguna entrada
                case (random[2:0])
                    3'b001: hunger <= (hunger < 4'd15) ? hunger + 1 : hunger;
                    3'b000: happiness <= (happiness < 5'd15) ? happiness + 1 : happiness;
                    3'b010: health <= (health < 4'd15) ? health + 1 : health;
                    3'b011: hygiene <= (hygiene < 4'd15) ? hygiene + 1 : hygiene;
                    3'b110: energy <= (energy < 4'd15) ? energy + 1 : energy;
                    3'b101: social <= (social < 4'd15) ? social + 1 : social;
                endcase
            end
            if (!only_one) begin
            case (inputs)
            8'h65: begin // 'e' command (e.g., eat)
                hunger <= (hunger > 0) ? hunger - 1 : hunger;
                only_one = 1;
            end
            8'h73: begin // 's' command (e.g., sleep)
                happiness <= (happiness > 0) ? happiness - 1 : happiness;
                only_one = 1;
            end
            8'h68: begin // 'd' command (e.g., drink)
                health <= (health > 0) ? health - 1 : health;
                only_one = 1;
            end
            8'h68: begin // 'd' command (e.g., drink)
                hygiene <= (hygiene > 0) ? hygiene - 1 : hygiene;
                only_one = 1;
            end
            8'h6c: begin // 'l' command (e.g., love)
                energy <= (energy > 0) ? energy - 1 : energy;
                only_one = 1;
            end
            8'h6c: begin // 'l' command (e.g., love)
                social <= (social > 0) ? social - 1 : social;
                only_one = 1;
            end
            
            // Add more cases for other UART commands
            endcase
        end
        if (inputs == 8'h00) begin
            only_one = 0; // Reiniciar la bandera para permitir que se incrementen las estadísticas
        end
            count <= count + 1;
        end
    end

endmodule
