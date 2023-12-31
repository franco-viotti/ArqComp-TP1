module toplevel
  #(
     parameter NB_BTN    =   3,  //! Numero de bits de botones
     parameter NB_OP     =   6,  //! Numero de bits de codigo de operacion
     parameter NB_AB     = 4     //! Numero de bits de operandos
   )
   (
     input [NB_OP - 1 : 0]      i_sw,     //! Switches de entrada
     input [NB_BTN - 1 : 0]     i_btn,    //! Botones selectores
     input                      i_reset,  //! Boton de reset
     input                      clock,    //! Entrada de clock
     output [NB_AB - 1 : 0]     o_led     //! LEDs de salida
   );

  reg [NB_AB - 1: 0]     a;         //! Operando A
  reg [NB_AB - 1: 0]     b;         //! Operando B
  reg [NB_OP - 1: 0]     operation; //! Operador

  wire [NB_AB - 1: 0]     wire_a;
  wire [NB_AB - 1: 0]     wire_b;
  wire [NB_OP - 1: 0]     wire_operation;

  always @(posedge clock) //Asignacion de registros
  begin
     if(i_reset)begin //! Reset
        a           <=   {NB_AB{1'b0}};
        b           <=   {NB_AB{1'b0}};
        operation   <=   {NB_OP{1'b0}};
    end

    case(i_btn)       //! Asignacion segun boton
      3'b001  :
        a <= i_sw[NB_AB-1 : 0];
      3'b010  :
        b <= i_sw[NB_AB-1 : 0];
      3'b100  :
        operation <= i_sw[NB_OP-1 : 0];
    endcase
  end

  assign wire_a             =   a;
  assign wire_b             =   b;
  assign wire_operation     =   operation;

  ALU //! Instancia de ALU
    #(
      .NB_AB(NB_AB),
      .NB_OP(NB_OP),
      .ADD(6'b100000),
      .SUB(6'b100010),
      .AND(6'b100100),
      .OR (6'b100101),
      .XOR(6'b100110),
      .SRA(6'b000011),
      .SRL(6'b000010),
      .NOR(6'b100111)
    )
    u_ALU
    (
      .i_opcode(wire_operation),
      .i_A(wire_a             ),
      .i_B(wire_b             ),
      .o_result(o_led         )
    );

endmodule

