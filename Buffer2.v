//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Buffer2 (
    input wire [31:0] DataIn1,  // Dirección (hacia Mem)
    input wire [31:0] DataIn2,  // Salida ALU (hacia BancoReg)
    input wire [31:0] DataIn3,  // Otro dato (ej. DR2 o similar)
    input wire clk,
    input wire EN,
    input wire W_in,
    input wire R_in,
    output reg [31:0] BOut1,
    output reg [31:0] BOut2,
    output reg [31:0] BOut3,
    output reg W_out,
    output reg R_out
);
    always @(posedge clk) begin
        if (EN) begin
            BOut1 <= DataIn1;
            BOut2 <= DataIn2;
            BOut3 <= DataIn3;
            W_out <= W_in;
            R_out <= R_in;
        end
    end
endmodule