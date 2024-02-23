`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.02.2024 10:14:06
// Design Name: 
// Module Name: prueba_basica
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module prueba_basica;

    logic            clk_tb;
    logic            rst_n_tb=0;
    logic [1:0]      lanzar_tb=0;
    
    logic [1:0]      ultimo_ganador_tb;  //2 "segmentos"
    logic [7:0]      control_anodos_tb;     //para definir el "7 segmentos encendido
    logic [2*3-1:0]  dados_tb;           //6 leds
    logic [2*4-1:0]  conteos_tb;          //8 leds


    clk_gen reloj (clk_tb);
    
    juego u_juego (
        .clk_pi(clk_tb),
        .rst_n_pi(rst_n_tb),
        .lanzar_pi(lanzar_tb),
        .ultimo_ganador_po(ultimo_ganador_tb),
        .control_anodos_po(control_anodos_tb),
        .dados_po(dados_tb),
        .conteos_po(conteos_tb)
    );
    
    initial begin
        #30
        @(posedge clk_tb) rst_n_tb <= 1;
        @(posedge clk_tb) lanzar_tb <= 1;
        @(posedge clk_tb) lanzar_tb <= 3;
        #150
        @(posedge clk_tb) lanzar_tb <= 0;
        
    end

endmodule
