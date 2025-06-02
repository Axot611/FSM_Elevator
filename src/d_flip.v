module d_flipflop (
    input  logic clk,
    input  logic rst,
    input  logic D,
    output logic Q
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            Q <= 0;
        else
            Q <= D;
    end
endmodule
