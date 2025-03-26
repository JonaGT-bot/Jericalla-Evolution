//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Alu(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [1:0] OP,
    output reg [31:0] Res
);
always @(*) begin
    case(OP)
        2'b00: Res = A + B; 
        2'b01: Res = A - B; 
        2'b10: Res = (A < B) ? 32'd1 : 32'd0; 

        default: Res = 32'd0;
    endcase
 
end
endmodule