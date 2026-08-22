module rate_encoder_test #(
    parameter PIXEL_WIDTH = 8,  // Input pixel intensity width (e.g., 0 to 255)
    parameter V_THRESH    = 255, // Threshold for IF neuron (matches max pixel intensity)
    parameter NUM_TIMESTEPS = 25, // Total simulation timesteps
    parameter NUM_NEURONS = 784  // Number of input neurons
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    // Flattened input: NUM_NEURONS * PIXEL_WIDTH bits packed together
    input wire [(NUM_NEURONS*PIXEL_WIDTH)-1:0] pixel_intensity_flat,
    // Flattened output: NUM_NEURONS bits packed together
    output reg [NUM_NEURONS-1:0] spike_out_flat,
    output reg [4:0] timestep_count,
    output reg encoding_done,
    output reg encoding_active
);

    // --- Local Parameters and Variables ---
    // Voltage register width: PIXEL_WIDTH (for accumulation) + extra bits for V_THRESH comparison.
    // Since V_THRESH = 255 (8-bit max), voltage only needs PIXEL_WIDTH bits.
    // If V_THRESH was smaller than max pixel intensity, voltage could accumulate to V_THRESH-1 + max_input.
    // Assuming V_THRESH = max_pixel_intensity (255), we use PIXEL_WIDTH bits.
    parameter VOLTAGE_WIDTH = PIXEL_WIDTH; 

    // Internal unpacked arrays (synthesizable registers)
    reg [VOLTAGE_WIDTH-1:0] voltage [0:NUM_NEURONS-1];
    reg [PIXEL_WIDTH-1:0]   pixel_intensity [0:NUM_NEURONS-1];
    reg [4:0] ts_counter;

    integer i;

    // --- Unpack Logic (Combinational) ---
    // Unpack the flattened input into internal array
    always @(*) begin
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            pixel_intensity[i] = pixel_intensity_flat[(i*PIXEL_WIDTH) +: PIXEL_WIDTH];
        end
    end
    
    // --- Sequential Logic (IF Neuron Core & Control) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset state
            for (i = 0; i < NUM_NEURONS; i = i + 1) begin
                voltage[i] <= 0;
            end
            ts_counter      <= 0;
            encoding_active <= 0;
            encoding_done   <= 0;
            timestep_count  <= 0;
            spike_out_flat  <= 0;
        end
        else if (start && !encoding_active) begin
            // Start sequence (One cycle pulse on 'start')
            for (i = 0; i < NUM_NEURONS; i = i + 1) begin
                voltage[i] <= 0; // Clear voltage
            end
            ts_counter      <= 0;
            encoding_active <= 1; // Begin active encoding
            encoding_done   <= 0;
        end
        else if (encoding_active) begin
            if (ts_counter < NUM_TIMESTEPS) begin
                // Processing Timestep
                for (i = 0; i < NUM_NEURONS; i = i + 1) begin
                    // Calculate next potential (new_v)
                    // Note: This uses standard integer addition.
                    // For rate encoding, the input (pixel_intensity) is the current.
                    // The sum should be checked against V_THRESH.
                    
                    // Fire condition check
                    if ((voltage[i] + pixel_intensity[i]) >= V_THRESH) begin
                        // 1. Spike generated
                        spike_out_flat[i] <= 1'b1;
                        // 2. Hard reset
                        voltage[i] <= 0; 
                    end
                    else begin
                        // 1. No spike
                        spike_out_flat[i] <= 1'b0;
                        // 2. Integrate
                        voltage[i] <= voltage[i] + pixel_intensity[i];
                    end
                end
                
                // Advance timestep counter
                ts_counter     <= ts_counter + 1;
                timestep_count <= ts_counter + 1;
            end
            else begin
                // End of Timesteps
                encoding_active <= 0;
                encoding_done   <= 1;
                spike_out_flat  <= 0; // Stop spiking when done
            end
        end
        else begin
            // Hold state when done or waiting for start
            spike_out_flat <= 0;
        end
    end

endmodule