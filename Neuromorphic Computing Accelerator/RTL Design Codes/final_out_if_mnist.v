module final_out_if_mnist #(
    parameter out_neuron = 10,
    parameter COUNTER_WIDTH = 8
)(
    input clk,
    input rst_n,
    input enable,
    input [out_neuron-1:0] final_output,
    output reg [3:0] number,
    output reg [COUNTER_WIDTH-1:0] max_count
);

    reg [COUNTER_WIDTH-1:0] count [0:out_neuron-1];
    integer i;

    // Initialize counters
    initial begin
        for (i = 0; i < out_neuron; i = i+1) begin
            count[i] = 0;
        end
        number = 0;
        max_count = 0;
    end

    // Count spikes synchronously on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < out_neuron; i = i+1) begin
                count[i] <= 0;
            end
        end else if (enable) begin
            for (i = 0; i < out_neuron; i = i+1) begin
                if (final_output[i]) begin
                    count[i] <= count[i] + 1;
                end
            end
        end
    end

    // Find neuron with maximum spike count (combinational)
    always @(*) begin
        number = 0;
        max_count = count[0];
        
        for (i = 1; i < out_neuron; i = i+1) begin
            if (count[i] > max_count) begin
                number = i;
                max_count = count[i];
            end
        end
    end

endmodule
