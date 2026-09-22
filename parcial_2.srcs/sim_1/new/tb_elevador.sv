`timescale 1ns / 1ps

module tb_elevador;
    logic clk;
    logic reset;
    logic b1, b2, b3;
    logic led_subiendo, led_bajando;
    logic led_piso1reset, led_piso1, led_piso2, led_piso3;

    elevador_top dut (
        .clk           (clk),
        .reset         (reset),
        .b1            (b1),
        .b2            (b2),
        .b3            (b3),
        .led_subiendo  (led_subiendo),
        .led_bajando   (led_bajando),
        .led_piso1reset(led_piso1reset),
        .led_piso1     (led_piso1),
        .led_piso2     (led_piso2),
        .led_piso3     (led_piso3)
    );

    // Generador de reloj de 10 ns (100 MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        b1 = 0; b2 = 0; b3 = 0;
        #20;
        reset = 0;
        #20;

        // Caso 1: Estando en Piso 1, pedir Piso 3 (debe subir a Piso 2, luego a Piso 3)
        $display("[T=%0t] Solicitando Piso 3...", $time);
        b3 = 1;
        #10;
        b3 = 0;
        #40;

        // Caso 2: Desde Piso 3, pedir Piso 1 (debe bajar a Piso 2, luego a Piso 1)
        $display("[T=%0t] Solicitando Piso 1...", $time);
        b1 = 1;
        #10;
        b1 = 0;
        #40;

        $finish;
    end
endmodule