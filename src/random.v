module random(
    input   in_clk,
    input   in_n_rst,
    input   [7:0] taps,
    input   [7:0] reset_value,
    output  reg [7:0] computed_value);

    
    always @ (posedge in_clk, negedge in_n_rst)
    begin
        if (!in_n_rst)
        begin
            computed_value <= reset_value;
        end
        else
        begin
            computed_value <= computed_value >> 1;
            computed_value[7] <= computed_value[0] ^
                                 ((taps[6]) ? computed_value[1] : 0) ^
                                 ((taps[5]) ? computed_value[2] : 0) ^
                                 ((taps[4]) ? computed_value[3] : 0) ^
                                 ((taps[3]) ? computed_value[4] : 0) ^
                                 ((taps[2]) ? computed_value[5] : 0) ^
                                 ((taps[1]) ? computed_value[6] : 0) ^
                                 ((taps[0]) ? computed_value[7] : 0);
        end
    end
endmodule 