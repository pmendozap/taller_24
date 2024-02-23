module calcula_cara(
        input logic [4:0]   data_i,
        output logic [2:0]  data_o
    );

    timeunit 1ns;
    timeprecision 1ps;
    
    int i;
    always_comb begin
        data_o = 1; //valor de cara mínimo es 1
        //los 5 bits del LFSR definen si cambio a las caras 2 a la 
        for(i=0;i<5;i++) begin
            data_o = data_o + data_i[i];
        end
    end
endmodule
