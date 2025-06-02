`default_nettype none

module tt_um_FSM_Axot611 (
    input  logic clk,
    input  logic rst_n,
    input  logic ena,
    input  logic [7:0] ui_in,
    output logic [7:0] uo_out,
    input  logic [7:0] uio_in,
    output logic [7:0] uio_out,
    output logic [7:0] uio_oe
);
    logic rst;
    assign rst = ~rst_n;

    logic S, L1, L2, L3;
    assign {L3, L2, L1, S} = ui_in[3:0];

    logic X1, X0;
    assign uo_out = {6'b000000, X1, X0};

    logic GROUND, L1_out, L2_out, L3_out;
    logic VERDE_GROUND, ROJO_GROUND;
    logic VERDE_L1, ROJO_L1;
    logic VERDE_L2, ROJO_L2;
    logic VERDE_L3, ROJO_L3;

    assign uio_out = {
        VERDE_L3, ROJO_L3,
        VERDE_L2, ROJO_L2,
        VERDE_L1, ROJO_L1,
        VERDE_GROUND, ROJO_GROUND
    };

    assign uio_oe = 8'b11111111;

    main_module dut (
        .clk(clk),
        .rst(rst),
        .S(S), .L1(L1), .L2(L2), .L3(L3),
        .X1(X1), .X0(X0),
        .GROUND(GROUND), .L1_out(L1_out), .L2_out(L2_out), .L3_out(L3_out),
        .VERDE_GROUND(VERDE_GROUND), .ROJO_GROUND(ROJO_GROUND),
        .VERDE_L1(VERDE_L1), .ROJO_L1(ROJO_L1),
        .VERDE_L2(VERDE_L2), .ROJO_L2(ROJO_L2),
        .VERDE_L3(VERDE_L3), .ROJO_L3(ROJO_L3)
    );
endmodule
