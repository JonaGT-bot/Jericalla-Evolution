//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module Control(
    input wire [1:0] OpCode,
    output reg WE, 
    output reg [1:0] AluOp,
    output reg Demux,
    output reg W,  
    output reg R   
);
always @(*) begin
    // Valores por defecto
    WE = 0; AluOp = 2'b00; Demux = 0; W = 0; R = 0;

    case (OpCode)
        2'b00: begin // Suma
            WE = 1; 
            AluOp = 2'b00;
        end
        2'b01: begin // Resta
            WE = 1;
            AluOp = 2'b01;
        end
        2'b10: begin // SLT
            WE = 1;
            AluOp = 2'b10;
        end
        2'b11: begin // StoreWord
            WE = 0;
            Demux = 1;   // Indica que iremos a memoria
            W = 1;       // Señal de escritura en MemDatos
        end
    endcase
end
endmodule