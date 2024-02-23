module registro(
    input logic         clk_i,
    input logic         rst_n_i,
    input logic         enable_i,
    input logic [2:0]   data_i,
    output logic [2:0]  data_o
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    always_ff @(posedge clk_i) begin
        if(!rst_n_i) data_o <= 'd1; //inicio en la cara 1 (no existe cara cero)
        else if(enable_i)
                     data_o <= data_o;
    end
endmodule
