module output_logic (
    input  logic [2:0] state,
    output logic X1, X0,
    output logic GROUND, L1_out, L2_out, L3_out,
    output logic VERDE_GROUND, ROJO_GROUND,
    output logic VERDE_L1, ROJO_L1,
    output logic VERDE_L2, ROJO_L2,
    output logic VERDE_L3, ROJO_L3
);
    always_comb begin
        // Valores por defecto
        {GROUND, L1_out, L2_out, L3_out} = 4'b0000;
        {VERDE_GROUND, ROJO_GROUND,
         VERDE_L1, ROJO_L1,
         VERDE_L2, ROJO_L2,
         VERDE_L3, ROJO_L3} = 8'b00000000;
        {X1, X0} = state[2:0];

        case (state)
            3'b000: begin
                GROUND = 1;
                VERDE_GROUND = 1;
                ROJO_GROUND = 0;
            end
            3'b001: begin
                L1_out = 1;
                VERDE_L1 = 1;
                ROJO_L1 = 0;
            end
            3'b010: begin
                L2_out = 1;
                VERDE_L2 = 1;
                ROJO_L2 = 0;
            end
            3'b011: begin
                L3_out = 1;
                VERDE_L3 = 1;
                ROJO_L3 = 0;
            end
            3'b100: begin
                // Final, puede encender todo en rojo
                VERDE_L1 = 0; ROJO_L1 = 1;
                VERDE_L2 = 0; ROJO_L2 = 1;
                VERDE_L3 = 0; ROJO_L3 = 1;
                VERDE_GROUND = 0; ROJO_GROUND = 1;
            end
        endcase
    end
endmodule
