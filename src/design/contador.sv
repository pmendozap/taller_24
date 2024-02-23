module contador(
        input logic         clk_i,
        input logic         rst_n_i,
        input logic         enable_i,
        output logic [3:0]  data_o
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    always_ff @(posedge clk_i) begin
        if(!rst_n_i) data_o <= 'd0; //no se ha ganado nada
        else if(enable_i)
                     data_o <= data_o + 1'b1;
    end
endmodule
