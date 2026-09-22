`timescale 1ns / 1ps

module mef2_motor (
    input  logic       clk,
    input  logic       rst,
    input  logic [1:0] dest,       // D1, D0
    output logic [1:0] piso_actual,// P1, P0 (representacion del estado)
    output logic       subir,
    output logic       bajar,
    output logic       llegada
);

    // Estados fisicos validos: Piso 1 (01), Piso 2 (10), Piso 3 (11)
    typedef enum logic [1:0] {
        PISO_1 = 2'b01,
        PISO_2 = 2'b10,
        PISO_3 = 2'b11
    } pos_e;

    pos_e current_pos, next_pos;

    // 1. Registro de estado (al resetear inicia en Piso 1 como en Logisim)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_pos <= PISO_1;
        end else begin
            current_pos <= next_pos;
        end
    end

    // 2. Logica combinacional Mealy (Siguiente piso y salidas en funcion de Estado + Destino)
    always_comb begin
        // Valores por defecto
        next_pos = current_pos;
        subir    = 1'b0;
        bajar    = 1'b0;
        llegada  = 1'b0;

        case (current_pos)
            PISO_1: begin
                case (dest)
                    2'b00: begin next_pos = PISO_1; subir = 0; bajar = 0; llegada = 0; end
                    2'b01: begin next_pos = PISO_1; subir = 0; bajar = 0; llegada = 1; end
                    2'b10: begin next_pos = PISO_2; subir = 1; bajar = 0; llegada = 0; end
                    2'b11: begin next_pos = PISO_2; subir = 1; bajar = 0; llegada = 0; end
                    default: next_pos = PISO_1;
                endcase
            end

            PISO_2: begin
                case (dest)
                    2'b00: begin next_pos = PISO_2; subir = 0; bajar = 0; llegada = 0; end
                    2'b01: begin next_pos = PISO_1; subir = 0; bajar = 1; llegada = 0; end
                    2'b10: begin next_pos = PISO_2; subir = 0; bajar = 0; llegada = 1; end
                    2'b11: begin next_pos = PISO_3; subir = 1; bajar = 0; llegada = 0; end
                    default: next_pos = PISO_2;
                endcase
            end

            PISO_3: begin
                case (dest)
                    2'b00: begin next_pos = PISO_3; subir = 0; bajar = 0; llegada = 0; end
                    2'b01: begin next_pos = PISO_2; subir = 0; bajar = 1; llegada = 0; end
                    2'b10: begin next_pos = PISO_2; subir = 0; bajar = 1; llegada = 0; end
                    2'b11: begin next_pos = PISO_3; subir = 0; bajar = 0; llegada = 1; end
                    default: next_pos = PISO_3;
                endcase
            end

            default: begin
                next_pos = PISO_1;
            end
        endcase
    end

    assign piso_actual = current_pos;

endmodule
