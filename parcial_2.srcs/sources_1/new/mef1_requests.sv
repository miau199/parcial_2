`timescale 1ns / 1ps

module mef1_requests (
    input  logic       clk,
    input  logic       rst,       // Reset sincrono / asincrono del sistema
    input  logic       b1,        // Boton piso 1
    input  logic       b2,        // Boton piso 2
    input  logic       b3,        // Boton piso 3
    input  logic       llegada,   // Feedback desde MEF 2
    output logic [1:0] dest       // Destino hacia MEF 2
);

    // Codificacion de estados (identica al parcial 1)
    typedef enum logic [1:0] {
        S_IDLE = 2'b00, // Sin solicitud activa
        S_P1   = 2'b01, // Destino Piso 1
        S_P2   = 2'b10, // Destino Piso 2
        S_P3   = 2'b11  // Destino Piso 3
    } state_e;

    state_e current_state, next_state;

    // 1. Registro de estado
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Logica combinacional de proximo estado (reproduce MEF_tabla)
    always_comb begin
        next_state = current_state;

        if (rst || llegada) begin
            next_state = S_IDLE;
        end else begin
            case (current_state)
                S_IDLE: begin
                    // Prioridad segun tu tabla de verdad: B1 > B2 > B3
                    if (b1)
                        next_state = S_P1;
                    else if (b2)
                        next_state = S_P2;
                    else if (b3)
                        next_state = S_P3;
                    else
                        next_state = S_IDLE;
                end

                S_P1: next_state = S_P1;
                S_P2: next_state = S_P2;
                S_P3: next_state = S_P3;

                default: next_state = S_IDLE;
            endcase
        end
    end

    // 3. Logica de salida (Moore: depende unicamente del estado actual)
    assign dest = current_state;

endmodule