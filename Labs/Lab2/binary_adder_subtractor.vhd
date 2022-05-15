library ieee;
use ieee.std_logic_1164.all
use std_logic_unsigned.all;

entity binary_adder_subtractor is
	generic
	(
		<name>	: <type>  :=	<default_value>;
		...
		<name>	: <type>  :=	<default_value>
	);


	port
	(
		-- Input ports
		add_or_subtract	: in  std_logic
		a,b					: in	std_logic_vector (7 downto 0);
		carry_in 			: in	std_logic;
		sum					: out std_logic_vector (7 downto 0);
		carry_out			: out std_logic

	);
end binary_adder_subtractor;


-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture a of binary_adder_subtractor is

	-- Declarations (optional)

begin

	-- Process Statement (optional)
	process(a,b,sum_temp,carry_in)
	begin
		sum_temp <= ('0' & a) +('0' & b) + ("00000000" & carry_in);
		carry<= sum_temp(8);
		sum<=sum_temp(7 downto 0);

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end <arch_name>;
