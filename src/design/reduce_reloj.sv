module reduce_reloj(
        input logic         clk_i,
        input logic         rst_n_i,
        output logic        clk_en_o
    );
    
    logic [24:0]cuenta;
    
    //localparam logic [24:0] maximo = 25'd29_999_999;
    localparam logic [24:0] maximo = 25'd3;
    
    always_ff @(posedge clk_i)
        if(!rst_n_i) cuenta <= maximo;
        else if(cuenta == 25'd0)
                     cuenta <= maximo;
             else
                     cuenta <= cuenta - 1'b0;
    
    assign clk_en_o = (|cuenta)?0:1;
    
endmodule
