library ieee;
use ieee.std_logic_1164.all;


entity TrafficLightsController is
	port( clk, rst, tr1, tr4 : in std_logic;
			r, g, y: out std_logic_vector (4 downto 0) );
end entity;

architecture lightBehaviour of TrafficLightsController is

	shared variable innerclk60 : std_logic;
	shared variable innerclk30 : std_logic;
	shared variable count60 : integer := 0;
	shared variable count30 : integer := 0;
	shared variable sm : std_logic_vector (9 downto 0) := "0000000000";
					-- each two bits correspond to each lane:
					-- sm(1 downto 0) gives the state of L0 lights
					-- 00 means red
					-- 10 means yellow
					-- 11 means green

begin
	
	-- Set Time of clock cycle = 5 secs for a realtime simulation;
	process(clk)
	begin
	
		--r(0) for L0 lane
		--r(1) for L1 lane
		-- .
		-- .
		-- g(0) for L0 lane
		-- .
		-- .
		-- ..
		
		-- Switching pattern L2, L3, L4, L0, L1.
		
		if rising_edge(clk) then
		
			if rst = '1' then
			
				count60 := 0;
				count30 := 0;
				r (4 downto 0) <= "11011";
				g (4 downto 0) <= "00100";
				y (4 downto 0) <= "00000";
				sm := "0000110000";
				
			else
				
				count60 := count60 + 1;
				count30 := count30 + 1;
				-- Simulating 60 seconds clock
				if count60 = 12 then
					innerclk60 := '1';
					count60 := 0;
				end if;
				
				-- Simulating 30 seconds clock
				if count30 = 6 then
					innerclk30 := '1';
					count30 := 0;
				end if;
				
				-- Simulating states..
				
				if sm = "0000110000" then
					if innerclk60 = '1' then
						sm := "0000100000";
						innerclk60 := '0';
					end if;
				elsif sm = "0000100000" then
					sm := "0011000000";
					count60 := 0;
					count30 := 0;
				elsif sm = "0011000000" then
					if innerclk60 = '1' then
						sm := "0010000000";
						innerclk60 := '0';
					end if;
				elsif sm = "0010000000" then
					if tr4 = '1' then
						sm := "1100000000";
					else
						sm := "0000000011";
					end if;
					count60 := 0;
					count30 := 0;
				elsif sm = "1100000000" then
					if innerclk30 = '1' then
						sm := "1000000000";
						innerclk30 := '0';
					end if;
				elsif sm = "1000000000" then
					sm := "0000000011";
					count60 := 0;
					count30 := 0;
				elsif sm = "0000000011" then
					if innerclk60 = '1' then
						sm := "0000000010";
						innerclk60 := '0';
					end if;
				elsif sm = "0000000010" then
					if tr1 = '1' then
						sm := "0000001100";
					else
						sm := "0000110000";
					end if;
					count60 := 0;
					count30 := 0;
				elsif sm = "0000001000" then
					sm := "0000110000";
					count60 := 0;
					count30 := 0;
				elsif sm = "0000001100" then
					if innerclk30 = '1' then
						sm := "0000001000";
						innerclk30 := '0';
					end if;
				end if;
				
				-- Let the output flow to LIGHT's
				
				--For L0
				if sm (1 downto 0) = "00" then
					-- make red light of L0 glow
					r(0) <= '1';
					y(0) <= '0';
					g(0) <= '0';
				elsif sm(1 downto 0) = "10" then
					-- make yellow light of L0 glow
					r(0) <= '0';
					y(0) <= '1';
					g(0) <= '0';
				elsif sm(1 downto 0) = "11" then
					-- make green light fo L0 glow
					r(0) <= '0';
					y(0) <= '0';
					g(0) <= '1';
				end if;
				--For L1
				if sm (3 downto 2) = "00" then
					-- make red light of L1 glow
					r(1) <= '1';
					y(1) <= '0';
					g(1) <= '0';
				elsif sm(3 downto 2) = "10" then
					-- make yellow light of L1 glow
					r(1) <= '0';
					y(1) <= '1';
					g(1) <= '0';
				elsif sm(3 downto 2) = "11" then
					-- make green light fo L1 glow
					r(1) <= '0';
					y(1) <= '0';
					g(1) <= '1';
				end if;
				--For L2
				if sm (5 downto 4) = "00" then
					-- make red light of L2 glow
					r(2) <= '1';
					y(2) <= '0';
					g(2) <= '0';
				elsif sm(5 downto 4) = "10" then
					-- make yellow light of L2 glow
					r(2) <= '0';
					y(2) <= '1';
					g(2) <= '0';
				elsif sm(5 downto 4) = "11" then
					-- make green light fo L2 glow
					r(2) <= '0';
					y(2) <= '0';
					g(2) <= '1';
				end if;
				--For L3
				if sm (7 downto 6) = "00" then
					-- make red light of L3 glow
					r(3) <= '1';
					y(3) <= '0';
					g(3) <= '0';
				elsif sm(7 downto 6) = "10" then
					-- make yellow light of L3 glow
					r(3) <= '0';
					y(3) <= '1';
					g(3) <= '0';
				elsif sm(7 downto 6) = "11" then
					-- make green light fo L3 glow
					r(3) <= '0';
					y(3) <= '0';
					g(3) <= '1';
				end if;
				--For L4
				if sm (9 downto 8) = "00" then
					-- make red light of L4 glow
					r(4) <= '1';
					y(4) <= '0';
					g(4) <= '0';
				elsif sm(9 downto 8) = "10" then
					-- make yellow light of L4 glow
					r(4) <= '0';
					y(4) <= '1';
					g(4) <= '0';
				elsif sm(9 downto 8) = "11" then
					-- make green light fo L4 glow
					r(4) <= '0';
					y(4) <= '0';
					g(4) <= '1';
				end if;
				
				innerclk60 := '0';
				innerclk30 := '0';
				
			end if; -- end of rst check block
			
		end if; -- end of clock
	
	end process;



end architecture;