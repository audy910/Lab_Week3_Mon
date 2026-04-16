module dutyCycleSM (
    input  logic clk,
    input  logic in,
    output logic [3:0] duty_cycle
);
    typedef enum logic [1:0] {WAIT, PRESSED} state_t;
    state_t state;

    initial begin
        duty_cycle = 4'd0;
        state      = WAIT;
    end

    always_ff @(posedge clk) begin
        case (state)
            WAIT: begin
                if (in) begin
                    duty_cycle <= (duty_cycle >= 9) ? 4'd0 : duty_cycle + 1;
                    state      <= PRESSED;
                end
            end
            PRESSED: begin
                if (!in) state <= WAIT;
            end
            default: state <= WAIT;
        endcase
    end

endmodule