library ieee;
use ieee.std_logic_1164.all;

entity BCDto7Seg is
	port(
	
	--Inputs
	BCD 		: in std_logic_vector (3 downto 0);
	--Outputs
	DISPLAY	: out std_logic_vector (0 to 6);
	);
end BCDto7Seg;

architecture a of BCDto7Seg is

signal bcd_in			: std_logic_vector (3 downtto 0);
signal display_out	: std_logic_vector (0 to 6);

begin
	bcd_in <=BCD;
	DISPLAY<=display_out;
	
process(bcd_in) is
	begin
	case bcd_in is
		when "0000" => display_out<="0000001";
		when "0001" => display_out<="1001111";
		when "0010" => display_out<="0010010";
		when "0011" => display_out<="0000110";
		when "0100" => display_out<="1001100";
		when "0101" => display_out<="0100100";
		when "0110" => display_out<="0100000";
		when "0111" => display_out<="0001111";
		when "1000" => display_out<="0000000";		
		when "1001" => display_out<="0000100";
		when others => display_out<="1111111";
	end case;
end process;
end a;
