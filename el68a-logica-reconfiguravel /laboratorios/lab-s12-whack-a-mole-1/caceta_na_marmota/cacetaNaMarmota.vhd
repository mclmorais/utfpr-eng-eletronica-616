entity cacetaNaMarmota is
  port (
        clk             : in std_logic;
        rst             : in std_logic;
  );
end entity cacetaNaMarmota;


architecture aCacetaNaMarmota of cacetaNaMarmota is
  
  component controladorPontos is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        marcouPonto     : in std_logic;
        estado          : in std_logic;
        saidaAtual      : out integer;
        saidaMaxima     : out integer;
    );
end component controladorPontos;

  signal marcouPonto : std_logic := '0';

begin
  
  instanciaControladorPontos : component controladorPontos
  port map(
    clk => clk,
    rst => rst,
    marcouPonto => marcouPonto,
  );
  
  
end architecture aCacetaNaMarmota;