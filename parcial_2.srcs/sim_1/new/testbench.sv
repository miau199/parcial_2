`timescale 1ns / 1ps

module testbench;
    logic clk;
    logic reset;
    logic b1, b2, b3;
    logic led_subiendo, led_bajando;
    logic led_piso1, led_piso2, led_piso3;

    // Instancia del Top
    top uut (
        .clk          (clk),
        .reset        (reset),
        .b1           (b1),
        .b2           (b2),
        .b3           (b3),
        .led_subiendo (led_subiendo),
        .led_bajando  (led_bajando),
        .led_piso1    (led_piso1),
        .led_piso2    (led_piso2),
        .led_piso3    (led_piso3)
    );

    // Generador de reloj (Periodo = 10 ns -> 100 MHz)
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        reset = 1;
        b1    = 0;
        b2    = 0;
        b3    = 0;
        #20;
        reset = 0;
        #20;

        // Caso 1: Estando en Piso 1, solicitar Piso 3
        $display("[T=%0t] Presionando Boton 3...", $time);
        b3 = 1;
        #10;
        b3 = 0;

        // Esperar transiciones de subida (P1 -> P2 -> P3)
        #60;

        // Caso 2: Estando en Piso 3, solicitar Piso 1
        $display("[T=%0t] Presionando Boton 1...", $time);
        b1 = 1;
        #10;
        b1 = 0;

        // Esperar transiciones de bajada (P3 -> P2 -> P1)
        #60;

        $display("[T=%0t] Fin de la simulacion exitosa.", $time);
        $finish;
    end
endmodule