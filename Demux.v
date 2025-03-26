//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Demux (
    input wire [31:0] Q1,  // Entrada desde Buffer1
    input wire op,
    output reg [31:0] OutAlu,
    output reg [31:0] OutBuffer2
);
    
    always @(*) begin
        if (op == 1'b0) begin
            OutAlu = Q1;
            OutBuffer2 = 32'b0;
        end else begin
            OutAlu = 32'b0;
            OutBuffer2 = Q1;
        end
    end
endmodule