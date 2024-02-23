module juego(
        input logic             clk_pi,
        input logic             rst_n_pi,
        input logic [1:0]       lanzar_pi,          //boton de lanzar de cada jugador
        output logic [1:0]      ultimo_ganador_po,  //2 "segmentos"
        output logic [7:0]      control_anodos_po,     //para definir el "7 segmentos encendido
        output logic [2*3-1:0]  dados_po,           //6 leds
        output logic [2*4-1:0]  conteos_po          //8 leds
    );
    
    timeunit 1ns;
    timeprecision 1ps;
    
    logic            clk_en;
    
    logic [1:0][3:0] cuenta_ganes; //ganes por jugador
    logic [1:0][2:0] cara_actual;  //cara calculada
    logic [1:0][2:0] cara_actual_r;//cara del dado obtenida
    
    logic [1:0][4:0] num_aleatorio;
    
    logic            habilita_dados;
    logic [1:0]      dado_listo;
    
    logic [1:0]      jugador_gana;
    logic            tirar_dados;
    logic            define_gane;
    
    fsm_juego u_fsm_juego (
        .clk_i          (clk_pi),
        .rst_n_i        (rst_n_pi),
        .tirar_i        (lanzar_pi),
        .done_dados_i   (habilita_dados),
        .en_dados_o     (tirar_dados),
        .en_gane_o      (define_gane)
    );
    
    reduce_reloj control_reloj(
        .clk_i(clk_pi),
        .rst_n_i(rst_n_pi),
        .clk_en_o(clk_en)
    );
    
    logic [1:0][4:0] seed;
    assign seed[0] = 5'b10101;
    assign seed[1] = 5'b01010;
    generate 
        genvar i;
        for(i=0;i<2;i++) begin: jugador
        
            contador_tirar tiempo_dado (
                .clk_i(clk_pi),
                .rst_n_i(rst_n_pi),
                .clk_en_i(clk_en),
                .iniciar_i(lanzar_pi[i]),
                .decrementar_i(tirar_dados),
                .done_o(dado_listo[i])
            );
            
            lfsr #(.NUM_BITS(5)) generador(
                .clk_i       (clk_pi),
                .rst_n_i     (rst_n_pi),
                .enable_i    (lanzar_pi|(habilita_dados&~dado_listo[i])),
                .seed_data_i (seed[i]),
                .lfsr_data_o (num_aleatorio[i]),
                .lfsr_done_o ()
            );
            
            calcula_cara sumador_cara(
                .data_i (num_aleatorio[i]),
                .data_o (cara_actual[i])
            );
            
            registro resultado(
                .clk_i      (clk_pi),
                .rst_n_i    (rst_n_pi),
                .enable_i   (habilita_dados&~dado_listo),
                .data_i     (cara_actual[i]),
                .data_o     (cara_actual_r[i])
            );
            
            contador ganados(
                .clk_i      (clk_pi),
                .rst_n_i    (rst_n_pi),
                .enable_i   (define_gane&jugador_gana[i]),
                .data_o     (cuenta_ganes[i])
            );
        end: jugador
    endgenerate
    
    calcula_ganador quien_gana(
        .dados_i    ({cara_actual_r[1],cara_actual_r[0]}),
        .ganador_o  (jugador_gana)
    );
    
    assign conteos_po = cuenta_ganes;       //asignacion de leds (en orden)
    assign control_anodos_po = 8'b1111_1110;   //solo un 7 segmentos encendido
    
    always_ff @(posedge clk_pi)
        if(!rst_n_pi) ultimo_ganador_po <= '0;
        else if(define_gane) ultimo_ganador_po <= jugador_gana;
         
endmodule
