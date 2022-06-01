library ieee;
use ieee.std_logic_1164.all;


entity Z80AvalonMM is
  port (
    -- clocks
    clk     : in std_logic;
    reset_n : in std_logic;

    -- z80 interface (inputs)
    ADDR   : in  std_logic_vector(7 downto 0);
    DAT_I  : in  std_logic_vector(7 downto 0);  -- data bus from z80
    CS_n   : in  std_logic;
    RD_n   : in  std_logic;
    WR_n   : in  std_logic;
    IORQ_n : in  std_logic;
    -- z80 interface (outputs)
    DAT_O  : out std_logic_vector(7 downto 0);  -- data bus to z80
    WAIT_n : out std_logic;
    INT_n  : out std_logic;

    -- Avalon MM Master interface (inputs)
    readdata      : in std_logic_vector(31 downto 0);
    waitrequest_n : in std_logic;

    -- Avalon MM Master interface (outputs)
    address   : out std_logic_vector(31 downto 0);
    writedata : out std_logic_vector(31 downto 0);
    write_n   : out std_logic;
    read_n    : out std_logic

    );                                  -- end of Z80AvalonMM ports
end Z80AvalonMM;



architecture Z80AvalonMM_arch of Z80AvalonMM is

  signal s_avalon_base_address_byte3 : std_logic_vector(7 downto 0);
  signal s_avalon_base_address_byte2 : std_logic_vector(7 downto 0);
  signal s_avalon_base_address_byte1 : std_logic_vector(7 downto 0);
  signal s_control_register          : std_logic_vector(7 downto 0);

  signal s_addrreg   : std_logic_vector(7 downto 0);
  signal s_wrdatareg : std_logic_vector(7 downto 0);
  signal s_rddatareg : std_logic_vector(31 downto 0);
  signal s_DAT_O     : std_logic_vector(7 downto 0);

  signal latch_wrdata_ena, latch_rddata_ena, latch_address_ena : std_logic;
  signal s_DAT_O_valid                                         : std_logic;

  type   STATE_TYPE is (IDLE, AVALON_WR, AVALON_WR_DONE, AVALON_RD, AVALON_RD_DONE , INVALID);
  signal STATE, NEXTSTATE : STATE_TYPE;


  signal s_Z80IO_WR_n, s_Z80IO_RD_n : std_logic;

begin  -- Z80AvalonMM_arch

-- concurrent statements
  s_Z80IO_WR_n <= CS_n or WR_n or IORQ_n;
  s_Z80IO_RD_n <= CS_n or RD_n or IORQ_n;

  writedata <= "000000000000000000000000" & s_wrdatareg;
  address   <= s_avalon_base_address_byte3 & s_avalon_base_address_byte2 & s_avalon_base_address_byte1 & s_addrreg(7 downto 2) & "00";

-- TODO fixxxxx
--  DAT_O <= s_rddatareg when s_DAT_O_valid = '1' else X"DB";  -- deadbeef for short
  s_DAT_O <= s_rddatareg( 7 downto 0) when  ADDR(1 downto 0)="00" else
             s_rddatareg(15 downto 8) when  ADDR(1 downto 0)="01" else
             X"DB";

  DAT_O <= s_DAT_O when s_DAT_O_valid = '1' else X"DB";
  INT_n <= '1';

  control_FSM_trans : process(s_Z80IO_RD_n, s_Z80IO_WR_n, waitrequest_n, STATE)
  begin  -- process control_FSM_trans
    case STATE is
      when IDLE =>
        write_n           <= '1';
        read_n            <= '1';
        WAIT_n            <= '1';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '0';

        if s_Z80IO_WR_n = '0' then
          NEXTSTATE         <= AVALON_WR;
          -- outputs
          latch_address_ena <= '1';
          latch_wrdata_ena  <= '1';
          WAIT_n            <= '0';

        elsif s_Z80IO_RD_n = '0' then
          if ADDR(1 downto 0)="00" then  -- reading the DATA port, we trigger
                                         -- an avalon RD cycle
            NEXTSTATE         <= AVALON_RD;
            --outputs
            latch_address_ena <= '1';
            WAIT_n            <= '0';
          else
            -- we're reading the VALID port, don't do anything on the avalon side
            NEXTSTATE <= IDLE;
            WAIT_n <= '1';
            s_DAT_O_valid <= '1';
          end if;
        else
          NEXTSTATE <= IDLE;
        end if;

-- WRITE Cycle States
      when AVALON_WR =>
        write_n           <= '0';
        read_n            <= '1';
        WAIT_n            <= '0';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '0';
        
        if waitrequest_n = '1' then
          NEXTSTATE <= AVALON_WR_DONE;
        else
          -- keep waiting for avalon
          NEXTSTATE <= AVALON_WR;
        end if;

      when AVALON_WR_DONE =>
        write_n           <= '1';
        read_n            <= '1';
        WAIT_n            <= '1';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '0';
        NEXTSTATE         <= IDLE;

-- READ Cycle States
      when AVALON_RD =>
        write_n           <= '1';
        read_n            <= '0';
        WAIT_n            <= '0';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '0';
        
        if waitrequest_n = '1' then
          NEXTSTATE        <= AVALON_RD_DONE;
          latch_rddata_ena <= '1';
        else
          NEXTSTATE <= AVALON_RD;
        end if;

      when AVALON_RD_DONE =>
        write_n           <= '1';
        read_n            <= '1';
        WAIT_n            <= '1';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '1';
        NEXTSTATE         <= IDLE;

-- Other Debug States
      when INVALID =>
        NEXTSTATE         <= INVALID;
        write_n           <= '1';
        read_n            <= '1';
        WAIT_n            <= '1';
        latch_address_ena <= '0';
        latch_wrdata_ena  <= '0';
        latch_rddata_ena  <= '0';
        s_DAT_O_valid     <= '0';
      when others => null;
    end case;
  end process control_FSM_trans;


  -- purpose: state machine transition process
  -- type   : sequential
  control_FSM : process (clk, reset_n, NEXTSTATE)
  begin  -- process control_FSM
    if rising_edge(clk) and reset_n = '0' then               -- synchronous reset (active low)
      STATE <= IDLE;
    elsif rising_edge(clk) then  -- rising clock edge
      STATE <= NEXTSTATE;
    end if;
  end process control_FSM;

  -- purpose: registers to hold the avalon base address
  -- type   : sequential
  -- inputs : clk, reset_n, DAT_I, WR_n, IORQ_n
  -- outputs: avalon_base_address
  avalon_base_address_regs : process (clk, reset_n, CS_n, WR_n, IORQ_n)
  begin  -- process avalon_base_address_regs
    if rising_edge(clk) and reset_n = '0' then               -- synchronous reset (active low)
      s_avalon_base_address_byte3 <= (others => '0');
      s_avalon_base_address_byte2 <= (others => '0');
      s_avalon_base_address_byte1 <= (others => '0');
      s_control_register          <= (others => '0');
    elsif rising_edge(clk) and (CS_n = '0' and WR_n = '0' and IORQ_n = '0') then
      case ADDR(2 downto 0) is
        when "111"   => s_control_register          <= DAT_I;  -- base + 7
        when "110"   => s_avalon_base_address_byte3 <= DAT_I;  -- base + 6
        when "101"   => s_avalon_base_address_byte2 <= DAT_I;  -- base + 5
        when "100"   => s_avalon_base_address_byte1 <= DAT_I;  -- base + 4
        when others => null;
      end case;
    end if;
  end process avalon_base_address_regs;

  wrdatareg : process (clk, reset_n, latch_wrdata_ena)
  begin  -- process writereg
    if rising_edge(clk) and reset_n = '0' then               -- synchronous reset (active low)
      s_wrdatareg <= (others => '0');
    elsif rising_edge(clk) and latch_wrdata_ena = '1' then  -- rising clock edge
      s_wrdatareg <= DAT_I;
    end if;
  end process wrdatareg;

  rddatareg : process (clk, reset_n, latch_rddata_ena)
  begin  -- process rddatareg
    if rising_edge(clk) and reset_n = '0' then               -- synchronous reset (active low)
      s_rddatareg <= (others => '0');
    elsif rising_edge(clk) and latch_rddata_ena = '1' then  -- rising clock edge
      s_rddatareg <= readdata;
    end if;
  end process rddatareg;

  addrreg : process (clk, reset_n, latch_address_ena)
  begin  -- process addrreg
    if rising_edge(clk) and reset_n = '0' then               -- synchronous reset (active low)
      s_addrreg <= (others => '0');
    elsif rising_edge(clk) and latch_address_ena = '1' then  -- rising clock edge
      s_addrreg <= ADDR;
    end if;
  end process addrreg;


end Z80AvalonMM_arch;
