module contador_tirar(
        input logic         clk_i,
        input logic         rst_n_i,
        input logic         clk_en_i,
        input logic         iniciar_i,
        input logic         decrementar_i,
        output logic        done_o
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    logic [5:0] cuenta;
    
    always_ff@(posedge clk_i) begin
        if(!rst_n_i) cuenta <= 6'b10_0000;
        else begin
            if(iniciar_i) begin
                cuenta[5] <= 1'b1;
                cuenta[4:0] <= cuenta[4:0] + 1'b1;
            end else begin
                if((clk_en_i)&&(decrementar_i)&&(cuenta>0))
                    cuenta <= cuenta - 1'b1;
            end
        end
    end
    
    
    assign done_o = (|cuenta)?0:1; 
endmodule
