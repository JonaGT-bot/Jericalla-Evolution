//Jonathan Garcia Tovar
//Laura Vanessa Quintero Arreola
module JericallaEvo(
    input wire [16:0] Instruccion,
    input wire CLK,
    output reg [31:0] Salida
);
    // Decodificación de la instrucción
    wire [1:0] OpCode = Instruccion[16:15];
    wire [4:0] WA = Instruccion[14:10];
    wire [4:0] RA1 = Instruccion[9:5];
    wire [4:0] RA2 = Instruccion[4:0];
    
    // Señales de Control
    wire WE, Demux, W, R;
    wire [1:0] AluOp;
    
    // Salidas BancoRegistros
    wire [31:0] DR1, DR2;
    
    // Salidas Buffer1
    wire [31:0] Q1, Q2;
    wire We_buf1;
    wire [1:0] AluOp_buf1;
    wire Demux_buf1;
    
    // Salidas ALU
    wire [31:0] ALU_out;
    
    // Salidas Buffer2
    wire [31:0] B1_out, B2_out, B3_out;
    wire W_buf2, R_buf2;
    
    // Salida Memoria
    wire [31:0] DataOut;
    
    Control control (
        .OpCode(OpCode),
        .WE(WE),
        .AluOp(AluOp),
        .Demux(Demux),
        .W(W),
        .R(R)
    );
    
    BancoRegistros registros (
        .RA1(RA1),
        .RA2(RA2),
        .WA(WA),
        .WD(B2_out),  // Conectamos la salida del Buffer2
        .WE(WE),
        .clk(CLK),
        .DR1(DR1),
        .DR2(DR2)
    );
    
    Buffer1 buffer1 (
        .DR1(DR1),
        .DR2(DR2),
        .clk(CLK),
        .EN(1'b1),         // Para simplicidad, habilitado siempre
        .We_in(WE),
        .AluOp_in(AluOp),
        .Demux_in(Demux),
        .Q1(Q1),
        .Q2(Q2),
        .We_out(We_buf1),
        .AluOp_out(AluOp_buf1),
        .Demux_out(Demux_buf1)
    );
    
    // ALU
    Alu alu (
        .A(Q1),
        .B(Q2),
        .OP(AluOp_buf1),
        .Res(ALU_out)
    );
    
    // MUX explícito en lugar de tri-state
    wire [31:0] muxData1 = (Demux_buf1) ? Q1 : 32'b0;
    wire [31:0] muxData2 = ALU_out;
    wire [31:0] muxData3 = Q2;
    
    Buffer2 buffer2 (
        .DataIn1(muxData1),
        .DataIn2(muxData2),
        .DataIn3(muxData3),
        .clk(CLK),
        .EN(1'b1),   // habilitado siempre
        .W_in(W),
        .R_in(R),
        .BOut1(B1_out),
        .BOut2(B2_out),
        .BOut3(B3_out),
        .W_out(W_buf2),
        .R_out(R_buf2)
    );
    
    MemoriaDatos memDatos (
        .Address(B1_out),
        .DataIn(B3_out),
        .W(W_buf2),
        .R(R_buf2),
        .clk(CLK),
        .DataOut(DataOut)
    );
    
    // Registro de salida
    always @(posedge CLK) begin
        Salida <= DataOut;
    end
endmodule

// Testbench
module Testbench_JericallaEvo;
    reg [16:0] Instruccion;
    reg CLK;
    wire [31:0] Salida;
    
    // Instancia del TOP
    JericallaEvo uut (
        .Instruccion(Instruccion),
        .CLK(CLK),
        .Salida(Salida)
    );
    
    // Generación de reloj
    initial CLK = 0;
    always #200 CLK = ~CLK;
    
    initial begin

        // Prueba Suma (OpCode = 00)
        // Instruccion[16:15] = 00
        // WA=4, RA1=8, RA2=5
        Instruccion = 17'b00_00100_00000_00001; 
        #1000;
        
        // Resta (OpCode = 01)
        Instruccion = 17'b01_00101_00001_00010; 
        #1000;
        
        // SLT (OpCode = 10)
        Instruccion = 17'b10_00110_00010_00011; 
        #1000;
        
        // StoreWord (OpCode = 11) Caso 1
        Instruccion = 17'b11_00000_00111_00100; 
        #1000;
        
        // StoreWord (OpCode = 11) Caso 2
        Instruccion = 17'b11_00000_01000_00101; 
        #1000;

        // StoreWord (OpCode = 11) Caso 3
        Instruccion = 17'b11_00000_01001_00110; 
        #1000;

        // Finalizar
        #1000;
        $finish;
    end
endmodule