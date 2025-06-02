module next_state (
    input  logic [2:0] state,
    input  logic S, L1, L2, L3,
    output logic [2:0] next
);
    always_comb begin
        unique case (state)
            3'b000: next = S ? 3'b001 : 3'b000;  // IDLE -> GROUND
            3'b001: next = L1 ? 3'b010 : 3'b001; // GROUND -> L1
            3'b010: next = L2 ? 3'b011 : 3'b010; // L1 -> L2
            3'b011: next = L3 ? 3'b100 : 3'b011; // L2 -> L3
            3'b100: next = 3'b000;               // L3 -> IDLE
            default: next = 3'b000;
        endcase
    end
endmodule
