module ledBlink (
    input  logic clk,
    input  logic in,
    output logic out
);
    typedef enum logic [2:0]{START, ON, OFF} state_t;

    state_t state = START;
    state_t  next_state;

    always_ff @(posedge clk ) begin
        state <= next_state;
    end

    always_comb begin
        next_state = state; // Default: stay in current state
        case (state)
            START:next_state = OFF;
            ON:next_state = state_t'(in ? OFF : ON);
            OFF:next_state = state_t'(in ? ON : OFF);
            default: next_state = START;
        endcase
    end

    always_comb begin
        case(state)
            ON: out = 1;
            OFF: out = 0;
            default: out = 0;
        endcase 
    end

endmodule