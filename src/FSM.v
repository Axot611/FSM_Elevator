module fsm (
    input  logic clk,
    input  logic rst,
    input  logic [2:0] next_state,
    output logic [2:0] state
);
    d_flipflop ff0 (.clk(clk), .rst(rst), .D(next_state[0]), .Q(state[0]));
    d_flipflop ff1 (.clk(clk), .rst(rst), .D(next_state[1]), .Q(state[1]));
    d_flipflop ff2 (.clk(clk), .rst(rst), .D(next_state[2]), .Q(state[2]));
endmodule
