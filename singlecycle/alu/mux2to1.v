module mux2to1 (V, W, Selm, F);
  parameter k = 8;
  input [k-1:0] V, W;
  input Selm;
  output [k-1:0] F;
  reg [k-1:0] F;
  always @(V or W or Selm)
  if (Selm == 0) F <= V;
  else F <= W;
endmodule

