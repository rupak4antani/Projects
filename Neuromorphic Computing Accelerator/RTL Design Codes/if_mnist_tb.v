//`timescale 1ns/1ps

module if_mnist_tb;

    // =============================================================
    // PARAMETERS
    // =============================================================
    parameter DATA_WIDTH     = 8;
    parameter NUM_NEURONS    = 784;
    parameter NUM_TIMESTEPS  = 25;
    parameter THRESHOLD      = 255;

    // =============================================================
    // SIGNALS
    // =============================================================
    reg  clk, rst_n;
    reg  i_start;
    reg  [NUM_NEURONS*DATA_WIDTH-1:0] i_data;

    wire [NUM_NEURONS-1:0] o_spikes;
    wire o_done;
    wire encoding_active;

    // Layer outputs
    wire [1023:0] layer1_out;
    wire [511:0]  layer2_out;
    wire [9:0]    layer3_out;

    // Final outputs
    wire [3:0] predicted_digit;
    wire [7:0] max_spike_count;

    reg layers_enable;
    reg classifier_enable;

    // Local variables
    reg [DATA_WIDTH-1:0] neuron_inputs [0:NUM_NEURONS-1];
    integer i, file_handle, scan_result;
    real value;
    integer f_img, f_lbl;
    integer total_images = 0;
    integer correct = 0;
    integer expected_digit;
    real accuracy;
    real expected_real;


    // =============================================================
    // CLOCK GENERATION
    // =============================================================
    initial begin
        clk = 0;
        forever #2 clk = ~clk;   // 100 MHz
    end

    // =============================================================
    // RATE ENCODER INSTANTIATION
    // =============================================================
    rate_encoder_test #(
        .PIXEL_WIDTH(DATA_WIDTH),
        .NUM_NEURONS(NUM_NEURONS),
        .NUM_TIMESTEPS(NUM_TIMESTEPS),
        .V_THRESH(THRESHOLD)
    ) encoder (
        .clk(clk),
        .rst_n(rst_n),
        .start(i_start),
        .pixel_intensity_flat(i_data),
        .spike_out_flat(o_spikes),
        .timestep_count(),
        .encoding_done(o_done),
        .encoding_active(encoding_active)
    );

    // =============================================================
    // IF LAYERS
    // =============================================================
    if_mnist_layer_new #(.layer_number(1), .inp_neuron(784), .out_neuron(1024), .thr(1))
    layer1 (.clk(clk), .rst_n(rst_n), .enable(layers_enable),
            .inp_spike(o_spikes), .out_spike(layer1_out));

    if_mnist_layer_new #(.layer_number(2), .inp_neuron(1024), .out_neuron(512), .thr(1))
    layer2 (.clk(clk), .rst_n(rst_n), .enable(layers_enable),
            .inp_spike(layer1_out), .out_spike(layer2_out));

    if_mnist_layer_new #(.layer_number(3), .inp_neuron(512), .out_neuron(10), .thr(1))
    layer3 (.clk(clk), .rst_n(rst_n), .enable(layers_enable),
            .inp_spike(layer2_out), .out_spike(layer3_out));

    // =============================================================
    // FINAL OUTPUT CLASSIFIER
    // =============================================================
    final_out_if_mnist #(.out_neuron(10), .COUNTER_WIDTH(8)) classifier (
        .clk(clk),
        .rst_n(rst_n),
        .enable(classifier_enable),
        .final_output(layer3_out),
        .number(predicted_digit),
        .max_count(max_spike_count)
    );

    // =============================================================
    // ENABLE LAYERS & CLASSIFIER BASED ON ENCODER ACTIVITY
    // =============================================================
    always @(posedge clk) begin
        layers_enable     <= encoding_active;
        classifier_enable <= encoding_active;
    end

    // =============================================================
// MAIN TEST SEQUENCE (MULTI-IMAGE CLASSIFICATION)
// =============================================================
initial begin
    // $dumpfile("if_mnist_tb.vcd");
    // $dumpvars(0, if_mnist_tb);

    rst_n = 0;
    i_start = 0;
    layers_enable = 0;
    classifier_enable = 0;

    #20 rst_n = 1;

    // ---------------------------------------------------------
    // Open input and expected-output files
    // ---------------------------------------------------------
    f_img = $fopen("input_data_epoch_1.txt", "r");
    f_lbl = $fopen("input_labels_epoch_1.txt", "r");

    if (f_img == 0 || f_lbl == 0) begin
        $display("ERROR: Cannot open input/output files!");
        $finish;
    end

    // ---------------------------------------------------------
    // For each image
    // ---------------------------------------------------------
    while (!$feof(f_img)) begin
        total_images = total_images + 1;

        // -------- HARD RESET BEFORE EACH IMAGE --------
        rst_n = 0;
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // -------------------------------------
        // ---- Read 784 pixels for 1 image ----
        // -------------------------------------
        for (i = 0; i < NUM_NEURONS; i = i + 1) begin
            if ($fscanf(f_img, "%f", value) != 1) begin
                //$display("ERROR reading pixel %0d of image %0d", i, total_images);
                //$finish;
            end
            neuron_inputs[i] = value * 255;
        end

        // Read expected digit (REAL FORMAT)
    if ($fscanf(f_lbl, "%f", expected_real) != 1) begin
        //$display("ERROR reading expected digit for image %0d", total_images);
        //$finish;
    end

    expected_digit = expected_real;  // convert real → integer


        // -------------------------------------
        // ---- Pack pixels into i_data ----
        // -------------------------------------
        for (i = 0; i < NUM_NEURONS; i = i + 1)
            i_data[(i+1)*DATA_WIDTH - 1 -: DATA_WIDTH] = neuron_inputs[i];

        // Reset classifier counters before each image
        for (i = 0; i < 10; i = i + 1)
            classifier.count[i] = 0;

        // -------------------------------------
        // ---- Run rate encoder ----
        // -------------------------------------
        @(posedge clk); i_start = 1;
        @(posedge clk); i_start = 0;

        wait(o_done);

        // Allow final layer & classifier to finish pipeline
        repeat(5) @(posedge clk);

        // -------------------------------------
        // ---- Compare with ground truth ----
        // -------------------------------------
        $display("Image %0d: Predicted=%0d  Expected=%0d",
                 total_images, predicted_digit, expected_digit);

        if (predicted_digit == expected_digit)
            correct = correct + 1;

    end

    // ---------------------------------------------------------
    // FINAL ACCURACY
    // ---------------------------------------------------------
    accuracy = (correct * 100.0) / (total_images - 1);

    $display("=========================================");
    $display(" Total Images   : %0d", (total_images - 1));
    $display(" Correct         : %0d", correct);
    $display(" Accuracy        : %0f %%", accuracy);
    $display("=========================================");

    $finish;
    end


    // =============================================================
    // DEBUG MONITORS
    // =============================================================
    // always @(posedge clk) begin
    //     if (encoding_active)
    //         $display("Time %0t | Encoder spikes[127:0] = %b", $time, o_spikes[127:0]);
    // end

    // always @(posedge clk) begin
    //     if (layers_enable && |layer3_out)
    //         $display("Time %0t | Layer3 spikes = %b | Pred = %0d",
    //                  $time, layer3_out, predicted_digit);
    // end


endmodule
