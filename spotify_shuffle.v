
`timescale 1ns/1ps

// =====================================================
// MODULE 1: 5-BIT LFSR
// Polynomial: x^5 + x^3 + 1
// Non-zero seed prevents zero-state lockup.
// =====================================================

module lfsr5 (
    input clk,
    input rst,
    input load,
    input [4:0] load_data,
    output reg [4:0] state
);

    always @(posedge clk or posedge rst) begin

        if (rst)
            state <= 5'b00001;

        else if (load) begin

            if (load_data == 5'b00000)
                state <= 5'b00001;
            else
                state <= load_data;

        end

    end

endmodule


// =====================================================
// MODULE 2: SHUFFLE CONTROLLER
// =====================================================

module shuffle_controller (

    input clk,
    input rst,
    input next_btn,

    output reg [3:0] current_song,
    output reg round_done,
    output reg [15:0] played_mask

);

    wire [4:0] lfsr_state;

    reg [15:0] work_mask;

    reg [4:0] scan_state;
    reg [4:0] selected_state;

    reg [3:0] selected_index;

    reg found;
    reg new_round;

    integer i;


    // LFSR next-state function

    function [4:0] lfsr_step;

        input [4:0] s;

        begin

            if (s == 5'b00000)
                lfsr_step = 5'b00001;

            else
                lfsr_step = {
                    s[3:0],
                    s[4] ^ s[2]
                };

        end

    endfunction


    // Combinational song selection

    always @(*) begin

        new_round = &played_mask;

        if (new_round)
            work_mask = 16'h0000;
        else
            work_mask = played_mask;


        scan_state = lfsr_state;

        // Avoid immediate repetition across rounds

        if (new_round)
            scan_state = lfsr_step(lfsr_state);


        found = 1'b0;

        selected_index = 4'd0;
        selected_state = 5'b00001;


        // Search up to 31 non-zero LFSR states

        for (i = 0; i < 31; i = i + 1) begin

            if (!found) begin

                if (
                    !work_mask[scan_state[3:0]] &&
                    !(new_round &&
                      scan_state[3:0] == current_song)
                ) begin

                    found = 1'b1;

                    selected_index = scan_state[3:0];

                    selected_state = scan_state;

                end

                else begin

                    scan_state = lfsr_step(scan_state);

                end

            end

        end

    end


    // LFSR instance

    lfsr5 u_lfsr (

        .clk(clk),
        .rst(rst),
        .load(next_btn && found),
        .load_data(selected_state),
        .state(lfsr_state)

    );


    // Sequential output updates

    always @(posedge clk or posedge rst) begin

        if (rst) begin

            current_song <= 4'd0;

            played_mask <= 16'h0000;

            round_done <= 1'b0;

        end

        else begin

            round_done <= 1'b0;

            if (next_btn && found) begin

                current_song <= selected_index;

                played_mask <=
                    work_mask | (16'h0001 << selected_index);

                round_done <=
                    &(work_mask | (16'h0001 << selected_index));

            end

        end

    end

endmodule


// =====================================================
// MODULE 3: TOP MODULE
// =====================================================

module spotify_shuffle_top (

    input clk,
    input rst,
    input next_btn,

    output [3:0] current_song,
    output round_done,
    output [15:0] played_mask

);

    shuffle_controller u_controller (

        .clk(clk),
        .rst(rst),
        .next_btn(next_btn),

        .current_song(current_song),
        .round_done(round_done),
        .played_mask(played_mask)

    );

endmodule
