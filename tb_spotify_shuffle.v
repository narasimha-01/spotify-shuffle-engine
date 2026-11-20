`timescale 1ns/1ps

module tb_spotify_shuffle;

reg clk;
    reg rst;
    reg next_btn;

wire [3:0] current_song;
    wire round_done;
    wire [15:0] played_mask;

    reg [15:0] seen_mask;

integer n;
    integer round_count;

    // DUT

    spotify_shuffle_top dut (

.clk(clk),
        .rst(rst),
        .next_btn(next_btn),

.current_song(current_song),
        .round_done(round_done),
        .played_mask(played_mask)

    );

    // Clock generation

    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    // Main test sequence

    initial begin

        $dumpfile("shuffle.vcd");

        $dumpvars(0, tb_spotify_shuffle);

        rst = 1;

        next_btn = 0;

        seen_mask = 16'h0000;

        round_count = 1;

        repeat (2) @(posedge clk);

        @(negedge clk);

        rst = 0;

        $display("--------------------------------");

        $display("SPOTIFY SHUFFLE ENGINE");

        $display("--------------------------------");

        // Generate 40 NEXT button presses

        for (n = 0; n < 40; n = n + 1) begin

            @(negedge clk);

            next_btn = 1;

            @(posedge clk);

            #1;

            // Duplicate detection

            if (seen_mask[current_song]) begin

$display(
                    "ERROR: Duplicate song %0d",
                    current_song
                );

                $finish;

            end

            seen_mask[current_song] = 1'b1;

$display(
                "Round %0d | Song Index: %0d | Played Mask: %h",
                round_count,
                current_song,
                played_mask
            );

            // Round completion check

            if (round_done) begin

                if (seen_mask !== 16'hFFFF) begin

                    $display("ERROR: Incomplete round");

                    $finish;

                end

                $display("--------------------------------");

                $display("ROUND %0d COMPLETED!", round_count);

                $display("--------------------------------");

                seen_mask = 16'h0000;

                round_count = round_count + 1;

            end

            @(negedge clk);

            next_btn = 0;

        end

        $display("--------------------------------");

        $display("SIMULATION COMPLETED SUCCESSFULLY");

        $display("Total NEXT presses: 40");

$display("Completed rounds: %0d",
                 round_count - 1);

$display("Remaining songs in current round: %0d",
                 count_songs(seen_mask));

        $display("--------------------------------");

        #20;

        $finish;

    end

    // Count played songs

    function integer count_songs;

        input [15:0] mask;

        integer j;

        begin

            count_songs = 0;

            for (j = 0; j < 16; j = j + 1) begin

                if (mask[j])

                    count_songs = count_songs + 1;

            end

        end

    endfunction

endmodule