module stats(
    input wire clk,       // Clock de sistema
    input wire reset,     // Señal de reset
    input wire [7:0] inputs, // Señal de entrada de botones
    input wire [7:0] random, // Valor aleatorio de 8 bits
    output reg second,    // Segundo de la animación
    output reg [4:0] hunger,     // Estadística de hambre
    output reg [4:0] happiness,  // Estadística de felicidad
    output reg [4:0] health,     // Estadística de salud
    output reg [4:0] hygiene,    // Estadística de higiene
    output reg [4:0] energy,     // Estadística de energía
    output reg is_sleeping      // Estadística social
);

    reg [27:0] count = 0; // Contador de tiempo
    reg only_one = 0; // Bandera para evitar que se incrementen las estadísticas más de una vez por segundo
    reg not_dead = 1; // Bandera para indicar que el Tamagotchi no ha muerto

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reiniciar estadísticas en caso de reset
            {hunger, happiness, health, hygiene, energy} <= 5'd0;
            count <= 0; // Reiniciar el contador cuando se presiona el botón de reset
        end else begin
            if (count == 28'd27000000) begin
                count <= 0;
                second <= ~second; // Cambiar el segundo de la animación
                // Incrementar estadísticas aleatoriamente si no se presiona ninguna entrada
                if (is_sleeping && second && energy > 0) begin
                    energy <= energy - 1;
                end
                case (random[2:0])
                    3'b001: hunger <= (hunger < 5'd15) ? hunger + 1 : hunger;
                    3'b000: happiness <= (happiness < 5'd15) ? happiness + 1 : happiness;
                    3'b010: health <= (health < 5'd15) ? health + 1 : health;
                    3'b011: hygiene <= (hygiene < 5'd15) ? hygiene + 1 : hygiene;
                    3'b110: energy <= (energy < 5'd15) ? energy + 1 : energy;
                endcase
            end
            if (!only_one && !is_sleeping && not_dead) begin
                case (inputs)
                    8'h65: hunger <= (hunger > 0) ? hunger - 1 : hunger;
                    8'h70: happiness <= (happiness > 0) ? happiness - 1 : happiness;
                    8'h64: health <= (health > 0) ? health - 1 : health;
                    8'h62: hygiene <= (hygiene > 0) ? hygiene - 1 : hygiene;
                    8'h73: is_sleeping <= 1; // Activar la bandera para indicar que el Tamagotchi está durmiendo
                endcase
                only_one <= 1;
            end
        end
        if (inputs == 8'h00) begin
            only_one <= 0; // Reiniciar la bandera para permitir que se incrementen las estadísticas
        end
        // Verificar si el Tamagotchi ha muerto
        if (hunger == 4'd15 || happiness == 4'd15 || health == 4'd15 || hygiene == 4'd15 || energy == 4'd15) begin
            not_dead = 0; // Desactivar la bandera para indicar que el Tamagotchi ha muerto
        end

        if (inputs == 8'h77 || !not_dead) begin
            is_sleeping <= 0; // Desactivar la bandera para indicar que el Tamagotchi está durmiendo
        end

        count <= count + 1;
    end

endmodule