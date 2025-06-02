module main_module (
    input  logic clk,
    input  logic rst,
    input  logic S, L1, L2, L3,
    output logic X1, X0,
    output logic GROUND, L1_out, L2_out, L3_out,
    output logic VERDE_GROUND, ROJO_GROUND,
    output logic VERDE_L1, ROJO_L1,
    output logic VERDE_L2, ROJO_L2,
    output logic VERDE_L3, ROJO_L3
);
    logic [2:0] state, next;

    // Máquina de estados
    fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .next_state(next),
        .state(state)
    );

    // Lógica de transición
    next_state ns_inst (
        .state(state),
        .S(S), .L1(L1), .L2(L2), .L3(L3),
        .next(next)
    );

    // Lógica de salida
    output_logic out_inst (
        .state(state),
        .X1(X1), .X0(X0),
        .GROUND(GROUND), .L1_out(L1_out), .L2_out(L2_out), .L3_out(L3_out),
        .VERDE_GROUND(VERDE_GROUND), .ROJO_GROUND(ROJO_GROUND),
        .VERDE_L1(VERDE_L1), .ROJO_L1(ROJO_L1),
        .VERDE_L2(VERDE_L2), .ROJO_L2(ROJO_L2),
        .VERDE_L3(VERDE_L3), .ROJO_L3(ROJO_L3)
    );
endmodule
