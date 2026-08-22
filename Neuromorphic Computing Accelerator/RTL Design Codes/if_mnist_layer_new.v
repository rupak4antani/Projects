module if_mnist_layer_new #(
    parameter layer_number = 1,
    parameter inp_neuron   = 784,
    parameter out_neuron   = 1024,
    parameter thr          = 1,   // Threshold for IF neuron
    parameter MEM_WIDTH    = 32
)(
    input  clk,
    input  rst_n,
    input  enable,
    input  [inp_neuron-1:0] inp_spike,
    output reg [out_neuron-1:0] out_spike
);
    // ------------------------------------------------------------
    // Memory and weight declarations
    // ------------------------------------------------------------
    real wij [0:out_neuron-1][0:inp_neuron-1];
    real membrane [0:out_neuron-1];
    integer i, j, fd;
    integer file_read_status;
    real weighted_sum;
    real new_membrane;  // Temporary variable for correct threshold checking
    
    // ------------------------------------------------------------
    // Weight loading from file
    // ------------------------------------------------------------
    initial begin
        case(layer_number)
            1: fd = $fopen("1.txt", "r");
            2: fd = $fopen("2.txt", "r");
            3: fd = $fopen("3.txt", "r");
            default: begin
                $display("ERROR: Unknown layer_number %0d", layer_number);
                $finish;
            end
        endcase
        
        if (fd == 0) begin
            $display("ERROR: Cannot open weights for layer %0d", layer_number);
            $finish;
        end
        
        for (i = 0; i < out_neuron; i = i + 1) begin
            for (j = 0; j < inp_neuron; j = j + 1) begin
                file_read_status = $fscanf(fd, "%f", wij[i][j]);
                //wij[i][j] = 10*wij[i][j];
                //wij[i][j] = -wij[i][j];
                if (file_read_status != 1) begin
                    $display("ERROR reading weights file %0d at [%0d][%0d]", 
                              layer_number, i, j);
                    $finish;
                end
            end
        end
        $fclose(fd);
        
        // Initialize membrane potentials
        for (j = 0; j < out_neuron; j = j + 1)
            membrane[j] = 0.0;
            
        // $display("Layer %0d: Weights loaded.", layer_number);
        // $display("Layer%0d sample weights: w[0][0]=%f w[10][0]=%f w[0][1]=%f", layer_number, wij[0][0], wij[10][0], wij[0][1]);

    end
    
    // ------------------------------------------------------------
    // Corrected IF neuron update logic with temporary variable
    // ------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset membranes & output spikes
            for (j = 0; j < out_neuron; j = j + 1) begin
                membrane[j] <= 0.0;
                out_spike[j] <= 1'b0;
            end
        end 
        else if (enable) begin
            for (i = 0; i < out_neuron; i = i + 1) begin
                weighted_sum = 0.0;
                
                // 1. Accumulate weighted inputs from THIS timestep
                for (j = 0; j < inp_neuron; j = j + 1) begin
                    if (inp_spike[j])
                        weighted_sum = weighted_sum + wij[i][j];
                end
                
                // 2. Calculate new membrane potential using temporary variable
                new_membrane = membrane[i] + weighted_sum;
                
                // if (j < 4 && weighted_sum != 0.0) 
                // begin
                //     $display("Layer%0d time=%0t j=%0d weighted_sum=%f new_mem=%f", layer_number, $time, j, weighted_sum, new_membrane);
                // end


                // 3. Fire spike if NEW membrane value reaches threshold
                if (new_membrane >= thr) 
                begin
                    out_spike[i] <= 1'b1;
                    membrane[i] <= 0.0;   // Hard reset after firing
                end
                else if(new_membrane < 0)
                begin
                    out_spike[i] <= 1'b0;
                    membrane[i] <= 0.0; 
                end
                else 
                begin
                    out_spike[i] <= 1'b0;
                    membrane[i] <= new_membrane;  // Accumulate membrane potential
                end
            end // end for j
        end 
        else 
        begin
            // When disabled, output is zero but membrane holds value
            for (i = 0; i < out_neuron; i = i + 1)
                out_spike[i] <= 1'b0;
        end
    end
    
endmodule
