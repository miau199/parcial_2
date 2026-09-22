`timescale 1ns / 1ps

module elevador_top (
    input  logic       clk,
    input  logic       reset,
    input  logic       b1,
    input  logic       b2,
    input  logic       b3,
    output logic       led_subiendo,
    output logic       led_bajando,
    output logic       led_piso1reset, // Decodificador 2'b00 (si ocurriera)
    output logic       led_piso1,      // Decodificador 2'b01
    output logic       led_piso2,      // Decodificador 2'b10
    output logic       led_piso3       // Decodificador 2'b11
);

    logic [1:0] dest_wire;
    logic [1:0] piso_wire;
    logic       llegada_wire;

    // Instancia MEF 1 (Moore)
    mef1_requests u_mef1 (
        .clk     (clk),
        .rst     (reset),
        .b1      (b1),
        .b2      (b2),
        .b3      (b3),
        .llegada (llegada_wire),
        .dest    (dest_wire)
    );

    // Instancia MEF 2 (Mealy)
    mef2_motor u_mef2 (
        .clk         (clk),
        .rst         (reset),
        .dest        (dest_wire),
        .piso_actual (piso_wire),
        .subir       (led_subiendo),
        .bajar       (led_bajando),
        .llegada     (llegada_wire)
    );

    // Decodificador 2 a 4 para LEDs de piso (tal como el bloque Decoder en main)
    assign led_piso1reset = (piso_wire == 2'b00);
    assign led_piso1      = (piso_wire == 2'b01);
    assign led_piso2      = (piso_wire == 2'b10);
    assign led_piso3      = (piso_wire == 2'b11);

endmodule    