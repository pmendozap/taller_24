module lfsr #(parameter NUM_BITS = 4) //por defecto 4 BITS!
  (
   input logic                  clk_i,
   input logic                  rst_n_i,
   input logic                  enable_i,
 
   // Optional Seed Value
   input logic [NUM_BITS-1:0]   seed_data_i,
 
   output logic [NUM_BITS-1:0]  lfsr_data_o,
   output logic                 lfsr_done_o
   );
   
  timeunit 1ns;
  timeprecision 1ps;
 
  logic [NUM_BITS:1] lfsr_r;
  logic              xnor_fb;
 
 
  // Purpose: Load up LFSR with Seed if Data Valid (DV) pulse is detected.
  // Othewise just run LFSR when enabled.
  always @(posedge clk_i)
    begin
      if (!rst_n_i) // Reset con LÓGICA NEGATIVA!
         lfsr_r <= seed_data_i; //El sistema inicia con el valor establecido por seed_data_i
      else if (enable_i == 1'b1) //mientras Enable es 1, entonces el sistema genera un nuevo valor!
        begin
            lfsr_r <= {lfsr_r[NUM_BITS-1:1], xnor_fb};
        end
    end
 
  // Create Feedback Polynomials.  Based on Application Note:
  // http://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
  always @(*)
    begin
      case (NUM_BITS)
        3: begin
          xnor_fb = lfsr_r[3] ^~ lfsr_r[2];
        end
        4: begin
          xnor_fb = lfsr_r[4] ^~ lfsr_r[3];
        end
        5: begin
          xnor_fb = lfsr_r[5] ^~ lfsr_r[3];
        end
        6: begin
          xnor_fb = lfsr_r[6] ^~ lfsr_r[5];
        end
        7: begin
          xnor_fb = lfsr_r[7] ^~ lfsr_r[6];
        end
        8: begin
          xnor_fb = lfsr_r[8] ^~ lfsr_r[6] ^~ lfsr_r[5] ^~ lfsr_r[4];
        end
        9: begin
          xnor_fb = lfsr_r[9] ^~ lfsr_r[5];
        end
        10: begin
          xnor_fb = lfsr_r[10] ^~ lfsr_r[7];
        end
        11: begin
          xnor_fb = lfsr_r[11] ^~ lfsr_r[9];
        end
        12: begin
          xnor_fb = lfsr_r[12] ^~ lfsr_r[6] ^~ lfsr_r[4] ^~ lfsr_r[1];
        end
        13: begin
          xnor_fb = lfsr_r[13] ^~ lfsr_r[4] ^~ lfsr_r[3] ^~ lfsr_r[1];
        end
        14: begin
          xnor_fb = lfsr_r[14] ^~ lfsr_r[5] ^~ lfsr_r[3] ^~ lfsr_r[1];
        end
        15: begin
          xnor_fb = lfsr_r[15] ^~ lfsr_r[14];
        end
        16: begin
          xnor_fb = lfsr_r[16] ^~ lfsr_r[15] ^~ lfsr_r[13] ^~ lfsr_r[4];
          end
        17: begin
          xnor_fb = lfsr_r[17] ^~ lfsr_r[14];
        end
        18: begin
          xnor_fb = lfsr_r[18] ^~ lfsr_r[11];
        end
        19: begin
          xnor_fb = lfsr_r[19] ^~ lfsr_r[6] ^~ lfsr_r[2] ^~ lfsr_r[1];
        end
        20: begin
          xnor_fb = lfsr_r[20] ^~ lfsr_r[17];
        end
        21: begin
          xnor_fb = lfsr_r[21] ^~ lfsr_r[19];
        end
        22: begin
          xnor_fb = lfsr_r[22] ^~ lfsr_r[21];
        end
        23: begin
          xnor_fb = lfsr_r[23] ^~ lfsr_r[18];
        end
        24: begin
          xnor_fb = lfsr_r[24] ^~ lfsr_r[23] ^~ lfsr_r[22] ^~ lfsr_r[17];
        end
        25: begin
          xnor_fb = lfsr_r[25] ^~ lfsr_r[22];
        end
        26: begin
          xnor_fb = lfsr_r[26] ^~ lfsr_r[6] ^~ lfsr_r[2] ^~ lfsr_r[1];
        end
        27: begin
          xnor_fb = lfsr_r[27] ^~ lfsr_r[5] ^~ lfsr_r[2] ^~ lfsr_r[1];
        end
        28: begin
          xnor_fb = lfsr_r[28] ^~ lfsr_r[25];
        end
        29: begin
          xnor_fb = lfsr_r[29] ^~ lfsr_r[27];
        end
        30: begin
          xnor_fb = lfsr_r[30] ^~ lfsr_r[6] ^~ lfsr_r[4] ^~ lfsr_r[1];
        end
        31: begin
          xnor_fb = lfsr_r[31] ^~ lfsr_r[28];
        end
        32: begin
          xnor_fb = lfsr_r[32] ^~ lfsr_r[22] ^~ lfsr_r[2] ^~ lfsr_r[1];
        end
        default xnor_fb=0; //En caso de que NUM_BITS esté por fuera del rango, usar cero! (el sistema se queda fijo en cero)
      endcase // case (NUM_BITS)
    end // always @ (*)
 
 
  assign lfsr_data_o = lfsr_r[NUM_BITS:1];
 
  // Conditional Assignment (?)
  assign lfsr_done_o = (lfsr_r[NUM_BITS:1] == seed_data_i) ? 1'b1 : 1'b0; // se terminó un cicl
 
endmodule // LFSR