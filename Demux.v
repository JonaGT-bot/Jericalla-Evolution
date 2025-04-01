//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Demux (
    input [31:0] In,
    input op,
    output reg [31:0] OutAlu,
    output reg [31:0] OutBuffer
);
    
    always @(*) begin
        if (op == 1'b0) begin
            OutAlu = In;
            OutBuffer = 32'b0;
        end else begin
            OutAlu = 32'b0;
            OutBuffer = In;
        end
    end
endmodule