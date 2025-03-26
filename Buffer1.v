//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Buffer1 (
    input wire [31:0] DR1,
    input wire [31:0] DR2, 
    input wire clk,
    input wire EN,
    input wire We_in,  
    input wire [1:0] AluOp_in,  
    input wire Demux_in,  
    output reg [31:0] Q1,
    output reg [31:0] Q2,
    output reg We_out,
    output reg [1:0] AluOp_out,
    output reg Demux_out
);
    always @(posedge clk) begin
        if (EN) begin
            Q1 <= DR1;
            Q2 <= DR2;
            We_out <= We_in;
            AluOp_out <= AluOp_in;
            Demux_out <= Demux_in;
        end
    end
endmodule