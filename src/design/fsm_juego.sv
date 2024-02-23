module fsm_juego(
        input logic         clk_i,
        input logic         rst_n_i,
        input logic [1:0]   tirar_i,
        input logic [1:0]   done_dados_i,
        output logic        en_dados_o,
        output logic        en_gane_o
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    typedef enum logic [2:0] {
        IDLE,
        GOT_ONE,
        GOT_TWO,
        LET_ONE,
        TIRA,
        EVALUA
    } t_estado; 
    
    
    t_estado estado;
    
    always_ff@(posedge clk_i) begin
        if(!rst_n_i) begin
            estado <= IDLE;
            en_dados_o <= 1'b0;
            en_gane_o <= 1'b0;
        end else begin
            case (estado)
                IDLE: begin
                    en_dados_o <= 1'b0;
                    en_gane_o <= 1'b0;
                    case(tirar_i)
                        2'b00: estado <= IDLE;
                        2'b01: estado <= GOT_ONE;    
                        2'b10: estado <= GOT_ONE;
                        2'b11: estado <= GOT_TWO;
                    endcase                     
                end
                GOT_ONE:
                    begin
                        case(tirar_i)
                            2'b00: estado <= IDLE;
                            2'b01: estado <= GOT_ONE;    
                            2'b10: estado <= GOT_ONE;
                            2'b11: estado <= GOT_TWO;
                        endcase                     
                    end
                GOT_TWO:
                    begin
                        case(tirar_i)
                            2'b00: estado <= TIRA;
                            2'b01: estado <= LET_ONE;    
                            2'b10: estado <= LET_ONE;
                            2'b11: estado <= GOT_TWO;
                        endcase                     
                    end
                LET_ONE:
                    begin
                        case(tirar_i)
                            2'b00: estado <= TIRA;
                            2'b01: estado <= LET_ONE;    
                            2'b10: estado <= LET_ONE;
                            2'b11: estado <= GOT_TWO;
                        endcase                     
                    end
                TIRA:
                    begin
                        en_dados_o <= 1'b1;
                        if(&done_dados_i == 0) estado <= TIRA;
                        else                   estado <= EVALUA;
                    end
                EVALUA:
                    begin
                        en_dados_o <= 1'b0;
                        en_gane_o <= 1'b1;
                        estado <= IDLE;
                    end
            endcase
        end
    end
endmodule
