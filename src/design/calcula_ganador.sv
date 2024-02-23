module calcula_ganador(
        input logic [1:0][2:0] dados_i,
        output logic[1:0]      ganador_o
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    //coloca 1 al jugador que gana
    //si hay empate ninguno obtiene 1
    assign ganador_o[0] = dados_i[0]>dados_i[1];
    assign ganador_o[1] = dados_i[0]<dados_i[1];
    
endmodule
