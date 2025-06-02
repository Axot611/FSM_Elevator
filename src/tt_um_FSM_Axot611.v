/*
 * Copyright (c) 2024 Axot611
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_fsm_axot611 (
    input  wire [7:0] ui_in,    // Entradas: [3]=L3, [2]=L2, [1]=L1, [0]=S
    output wire [7:0] uo_out,   // Salidas: [0]=X0, [1]=X1, [2]=GROUND, [3]=L1_out, [4]=L2_out, [5]=L3_out, [6]=VERDE_GROUND, [7]=ROJO_GROUND
    input  wire [7:0] uio_in,   // IOs no usados
    output wire [7:0] uio_out,  // IOs no usados
    output wire [7:0] uio_oe,   // IOs no usados
    input  wire       ena,      // enable
    input  wire       clk,      // clock
    input  wire       rst_n     // reset activo en bajo
);

    // --- Señales internas
    wire rst = ~rst_n;
    wire S  = ui_in[0];
    wire L1 = ui_in[1];
    wire L2 = ui_in[2];
    wire L3 = ui_in[3];

    wire [1:0] current_state;
    wire [1:0] next_state_w;

    wire GROUND, L1_out, L2_out, L3_out;
    wire VERDE_GROUND, ROJO_GROUND;
    wire VERDE_L1, ROJO_L1;
    wire VERDE_L2, ROJO_L2;
    wire VERDE_L3, ROJO_L3;

    wire slow_clk;

    // --- Divisor de reloj
    clock_divider clk_div (
        .clk(clk),
        .rst(rst),
        .slow_clk(slow_clk)
    );

    // --- Lógica de próximo estado
    next_state ns_inst (
        .S1(current_state[1]),
        .S0(current_state[0]),
        .S(S),
        .L1(L1), .L2(L2), .L3(L3),
        .x(next_state_w)
    );

    // --- Flip-Flops
    d_flipflop dff_inst (
        .clk(clk),
        .rst(rst),
        .enable(slow_clk & ena),
        .D1(next_state_w[1]),
        .D0(next_state_w[0]),
        .X1(current_state[1]),
        .X0(current_state[0])
    );

    // --- Salidas lógicas
    output_logic out_logic_inst (
        .S0(current_state),
        .GROUND(GROUND),
        .L1(L1_out),
        .L2(L2_out),
        .L3(L3_out)
    );

    LED_indicador led_ground (.S0(GROUND), .VERDE(VERDE_GROUND), .ROJO(ROJO_GROUND));
    LED_indicador led_l1 (.S0(L1_out), .VERDE(VERDE_L1), .ROJO(ROJO_L1));
    LED_indicador led_l2 (.S0(L2_out), .VERDE(VERDE_L2), .ROJO(ROJO_L2));
    LED_indicador led_l3 (.S0(L3_out), .VERDE(VERDE_L3), .ROJO(ROJO_L3));

    // --- Mapeo de salidas a pines de TinyTapeout
    assign uo_out[0] = current_state[0];  // X0
    assign uo_out[1] = current_state[1];  // X1
    assign uo_out[2] = GROUND;
    assign uo_out[3] = L1_out;
    assign uo_out[4] = L2_out;
    assign uo_out[5] = L3_out;
    assign uo_out[6] = VERDE_GROUND;
    assign uo_out[7] = ROJO_GROUND;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Señales no usadas
    wire _unused = &{uio_in};

endmodule

// --- Submódulos --- //

module clock_divider(input clk, input rst, output reg slow_clk);
    parameter DIVISOR = 100000000;
    reg [$clog2(DIVISOR)-1:0] counter = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            slow_clk <= 0;
        end else if (counter == DIVISOR - 1) begin
            counter <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

module next_state(input S1, S0, S, L1, L2, L3, output [1:0] x);
    wire nS1 = ~S1, nS0 = ~S0, nS = ~S, nL1 = ~L1, nL2 = ~L2, nL3 = ~L3;
    wire t1, t2, t3, t4, t5, t6, t7;
    wire u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12;

    assign t1 = S1 & nS & nL1 & nL2 & L3;
    assign t2 = S1 & nS & nL1 & L2 & nL3;
    assign t3 = S0 & nS & nL1;
    assign t4 = S0 & L3;
    assign t5 = S0 & L2;
    assign t6 = S0 & S & L1;
    assign t7 = S0 & S1;
    assign x[1] = t1 | t2 | t3 | t4 | t5 | t6 | t7;

    assign u1  = nS1 & nS & nL1 & nL2 & L3;
    assign u2  = ~S0 & nS1 & nS & nL1 & L2 & nL3;
    assign u3  = S1 & L2 & L3;
    assign u4  = S1 & S & L3;
    assign u5  = S1 & S & L2;
    assign u6  = nS1 & nS & L1 & nL2 & nL3;
    assign u7  = S0 & nS1 & S & nL1 & nL2 & nL3;
    assign u8  = S1 & L1 & L2;
    assign u9  = S1 & S & L1;
    assign u10 = S1 & nS & nL1 & nL2 & nL3;
    assign u11 = ~S0 & S1 & L1;
    assign u12 = S0 & S1 & L3;
    assign x[0] = u1 | u2 | u3 | u4 | u5 | u6 | u7 | u8 | u9 | u10 | u11 | u12;
endmodule

module d_flipflop(input clk, input rst, input enable, input D1, D0, output reg X1, X0);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            X1 <= 0;
            X0 <= 0;
        end else if (enable) begin
            X1 <= D1;
            X0 <= D0;
        end
    end
endmodule

module output_logic(input [1:0] S0, output GROUND, L1, L2, L3);
    assign GROUND = ~S0[1] & ~S0[0];
    assign L1     = ~S0[1] &  S0[0];
    assign L2     =  S0[1] & ~S0[0];
    assign L3     =  S0[1] &  S0[0];
endmodule

module LED_indicador(input S0, output VERDE, ROJO);
    assign VERDE = S0;
    assign ROJO  = ~S0;
endmodule
