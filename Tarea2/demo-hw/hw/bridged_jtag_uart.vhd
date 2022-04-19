--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2011 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_0_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_address_to_slave : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_avalon_master_read_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_write_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- outputs:
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                 signal z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC
              );
end entity jtag_uart_0_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_0_avalon_jtag_slave_arbitrator is
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_z80avalonmm_0_avalon_master :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal wait_for_jtag_uart_0_avalon_jtag_slave_counter :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_arbiterlock :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_arbiterlock2 :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_continuerequest :  STD_LOGIC;
                signal z80avalonmm_0_saved_grant_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_0_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave);
  --assign jtag_uart_0_avalon_jtag_slave_readdata_from_sa = jtag_uart_0_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readdata_from_sa <= jtag_uart_0_avalon_jtag_slave_readdata;
  internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(z80avalonmm_0_avalon_master_address_to_slave(31 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("00000000000000000000000000000000")))) AND ((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n));
  --assign jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_0_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_0_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_0_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_0_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_0_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_0_avalon_jtag_slave_waitrequest;
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_arb_share_set_values <= std_logic'('1');
  --jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests <= internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jtag_uart_0_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_0_avalon_jtag_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(jtag_uart_0_avalon_jtag_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_0_avalon_jtag_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --jtag_uart_0_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_allgrants <= jtag_uart_0_avalon_jtag_slave_grant_vector;
  --jtag_uart_0_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_0_avalon_jtag_slave_waits_for_read OR jtag_uart_0_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave <= jtag_uart_0_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_0_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND jtag_uart_0_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_0_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_0_avalon_jtag_slave_arb_share_counter <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_0_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_0_avalon_jtag_slave AND NOT jtag_uart_0_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --z80avalonmm_0/avalon_master jtag_uart_0/avalon_jtag_slave arbiterlock, which is an e_assign
  z80avalonmm_0_avalon_master_arbiterlock <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND z80avalonmm_0_avalon_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 <= jtag_uart_0_avalon_jtag_slave_arb_share_counter_next_value;
  --z80avalonmm_0/avalon_master jtag_uart_0/avalon_jtag_slave arbiterlock2, which is an e_assign
  z80avalonmm_0_avalon_master_arbiterlock2 <= jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable2 AND z80avalonmm_0_avalon_master_continuerequest;
  --jtag_uart_0_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --z80avalonmm_0_avalon_master_continuerequest continued request, which is an e_assign
  z80avalonmm_0_avalon_master_continuerequest <= std_logic'('1');
  internal_z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_writedata <= z80avalonmm_0_avalon_master_writedata;
  --master is always granted when requested
  internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --z80avalonmm_0/avalon_master saved-grant jtag_uart_0/avalon_jtag_slave, which is an e_assign
  z80avalonmm_0_saved_grant_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart_0/avalon_jtag_slave, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_0_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_0_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_0_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_0_avalon_jtag_slave_chipselect <= internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave;
  --jtag_uart_0_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_0_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_0_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_0_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_0_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_0_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_0_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_0_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_0_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_0_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_read_n <= NOT ((internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave AND NOT z80avalonmm_0_avalon_master_read_n));
  --~jtag_uart_0_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_write_n <= NOT ((internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave AND NOT z80avalonmm_0_avalon_master_write_n));
  shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_z80avalonmm_0_avalon_master <= z80avalonmm_0_avalon_master_address_to_slave;
  --jtag_uart_0_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_0_avalon_jtag_slave_from_z80avalonmm_0_avalon_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_0_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer <= jtag_uart_0_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_0_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_read <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_read_cycle <= internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave AND NOT z80avalonmm_0_avalon_master_read_n;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_0_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_0_avalon_jtag_slave_waits_for_write <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_0_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_0_avalon_jtag_slave_in_a_write_cycle <= internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave AND NOT z80avalonmm_0_avalon_master_write_n;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_0_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_0_avalon_jtag_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa;
  --vhdl renameroo for output signals
  z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave;
  --vhdl renameroo for output signals
  z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave <= internal_z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave;
--synthesis translate_off
    --jtag_uart_0/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity z80avalonmm_0_avalon_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_avalon_master_read_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_write_n : IN STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                 signal z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;

              -- outputs:
                 signal z80avalonmm_0_avalon_master_address_to_slave : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_avalon_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal z80avalonmm_0_avalon_master_reset_n : OUT STD_LOGIC;
                 signal z80avalonmm_0_avalon_master_waitrequest_n : OUT STD_LOGIC
              );
end entity z80avalonmm_0_avalon_master_arbitrator;


architecture europa of z80avalonmm_0_avalon_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal internal_z80avalonmm_0_avalon_master_address_to_slave :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_z80avalonmm_0_avalon_master_waitrequest_n :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_address_last_time :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal z80avalonmm_0_avalon_master_read_n_last_time :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_run :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_write_n_last_time :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_writedata_last_time :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic(((std_logic_vector'("00000000000000000000000000000001") AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave OR NOT ((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n)))))))))));
  --cascaded wait assignment, which is an e_assign
  z80avalonmm_0_avalon_master_run <= r_0;
  --optimize select-logic by passing only those address bits which matter.
  internal_z80avalonmm_0_avalon_master_address_to_slave <= Std_Logic_Vector'(std_logic_vector'("00000000000000000000000000000") & z80avalonmm_0_avalon_master_address(2 DOWNTO 0));
  --z80avalonmm_0/avalon_master readdata mux, which is an e_mux
  z80avalonmm_0_avalon_master_readdata <= jtag_uart_0_avalon_jtag_slave_readdata_from_sa;
  --actual waitrequest port, which is an e_assign
  internal_z80avalonmm_0_avalon_master_waitrequest_n <= z80avalonmm_0_avalon_master_run;
  --z80avalonmm_0_avalon_master_reset_n assignment, which is an e_assign
  z80avalonmm_0_avalon_master_reset_n <= reset_n;
  --vhdl renameroo for output signals
  z80avalonmm_0_avalon_master_address_to_slave <= internal_z80avalonmm_0_avalon_master_address_to_slave;
  --vhdl renameroo for output signals
  z80avalonmm_0_avalon_master_waitrequest_n <= internal_z80avalonmm_0_avalon_master_waitrequest_n;
--synthesis translate_off
    --z80avalonmm_0_avalon_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        z80avalonmm_0_avalon_master_address_last_time <= std_logic_vector'("00000000000000000000000000000000");
      elsif clk'event and clk = '1' then
        z80avalonmm_0_avalon_master_address_last_time <= z80avalonmm_0_avalon_master_address;
      end if;

    end process;

    --z80avalonmm_0/avalon_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= NOT internal_z80avalonmm_0_avalon_master_waitrequest_n AND ((NOT z80avalonmm_0_avalon_master_read_n OR NOT z80avalonmm_0_avalon_master_write_n));
      end if;

    end process;

    --z80avalonmm_0_avalon_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((z80avalonmm_0_avalon_master_address /= z80avalonmm_0_avalon_master_address_last_time))))) = '1' then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("z80avalonmm_0_avalon_master_address did not heed wait!!!"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --~z80avalonmm_0_avalon_master_read_n check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        z80avalonmm_0_avalon_master_read_n_last_time <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
      elsif clk'event and clk = '1' then
        z80avalonmm_0_avalon_master_read_n_last_time <= z80avalonmm_0_avalon_master_read_n;
      end if;

    end process;

    --~z80avalonmm_0_avalon_master_read_n matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(NOT z80avalonmm_0_avalon_master_read_n) /= std_logic'(NOT z80avalonmm_0_avalon_master_read_n_last_time)))))) = '1' then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("~z80avalonmm_0_avalon_master_read_n did not heed wait!!!"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --~z80avalonmm_0_avalon_master_write_n check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        z80avalonmm_0_avalon_master_write_n_last_time <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
      elsif clk'event and clk = '1' then
        z80avalonmm_0_avalon_master_write_n_last_time <= z80avalonmm_0_avalon_master_write_n;
      end if;

    end process;

    --~z80avalonmm_0_avalon_master_write_n matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(NOT z80avalonmm_0_avalon_master_write_n) /= std_logic'(NOT z80avalonmm_0_avalon_master_write_n_last_time)))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("~z80avalonmm_0_avalon_master_write_n did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --z80avalonmm_0_avalon_master_writedata check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        z80avalonmm_0_avalon_master_writedata_last_time <= std_logic_vector'("00000000000000000000000000000000");
      elsif clk'event and clk = '1' then
        z80avalonmm_0_avalon_master_writedata_last_time <= z80avalonmm_0_avalon_master_writedata;
      end if;

    end process;

    --z80avalonmm_0_avalon_master_writedata matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'(((active_and_waiting_last_time AND to_std_logic(((z80avalonmm_0_avalon_master_writedata /= z80avalonmm_0_avalon_master_writedata_last_time)))) AND NOT z80avalonmm_0_avalon_master_write_n)) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("z80avalonmm_0_avalon_master_writedata did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bridged_jtag_uart_reset_clk_0_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity bridged_jtag_uart_reset_clk_0_domain_synch_module;


architecture europa of bridged_jtag_uart_reset_clk_0_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bridged_jtag_uart is 
        port (
              -- 1) global signals:
                 signal clk_0 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_z80avalonmm_0
                 signal ADDR_to_the_z80avalonmm_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal CS_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                 signal DAT_I_to_the_z80avalonmm_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal DAT_O_from_the_z80avalonmm_0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal INT_n_from_the_z80avalonmm_0 : OUT STD_LOGIC;
                 signal IORQ_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                 signal RD_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                 signal WAIT_n_from_the_z80avalonmm_0 : OUT STD_LOGIC;
                 signal WR_n_to_the_z80avalonmm_0 : IN STD_LOGIC
              );
end entity bridged_jtag_uart;


architecture europa of bridged_jtag_uart is
component jtag_uart_0_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_address_to_slave : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_avalon_master_read_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_write_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC;
                    signal z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave : OUT STD_LOGIC
                 );
end component jtag_uart_0_avalon_jtag_slave_arbitrator;

component jtag_uart_0 is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart_0;

component z80avalonmm_0_avalon_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_address : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_avalon_master_read_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_write_n : IN STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;
                    signal z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave : IN STD_LOGIC;

                 -- outputs:
                    signal z80avalonmm_0_avalon_master_address_to_slave : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_avalon_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal z80avalonmm_0_avalon_master_reset_n : OUT STD_LOGIC;
                    signal z80avalonmm_0_avalon_master_waitrequest_n : OUT STD_LOGIC
                 );
end component z80avalonmm_0_avalon_master_arbitrator;

component z80avalonmm_0 is 
           port (
                 -- inputs:
                    signal ADDR : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal CS_n : IN STD_LOGIC;
                    signal DAT_I : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal IORQ_n : IN STD_LOGIC;
                    signal RD_n : IN STD_LOGIC;
                    signal WR_n : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal waitrequest_n : IN STD_LOGIC;

                 -- outputs:
                    signal DAT_O : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal INT_n : OUT STD_LOGIC;
                    signal WAIT_n : OUT STD_LOGIC;
                    signal address : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal read_n : OUT STD_LOGIC;
                    signal write_n : OUT STD_LOGIC;
                    signal writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component z80avalonmm_0;

component bridged_jtag_uart_reset_clk_0_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component bridged_jtag_uart_reset_clk_0_domain_synch_module;

                signal clk_0_reset_n :  STD_LOGIC;
                signal d1_jtag_uart_0_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal internal_DAT_O_from_the_z80avalonmm_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal internal_INT_n_from_the_z80avalonmm_0 :  STD_LOGIC;
                signal internal_WAIT_n_from_the_z80avalonmm_0 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_0_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_address :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal z80avalonmm_0_avalon_master_address_to_slave :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal z80avalonmm_0_avalon_master_read_n :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal z80avalonmm_0_avalon_master_reset_n :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_waitrequest_n :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_write_n :  STD_LOGIC;
                signal z80avalonmm_0_avalon_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;
                signal z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave :  STD_LOGIC;

begin

  --the_jtag_uart_0_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_0_avalon_jtag_slave : jtag_uart_0_avalon_jtag_slave_arbitrator
    port map(
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_address => jtag_uart_0_avalon_jtag_slave_address,
      jtag_uart_0_avalon_jtag_slave_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_0_avalon_jtag_slave_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_0_avalon_jtag_slave_reset_n => jtag_uart_0_avalon_jtag_slave_reset_n,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_0_avalon_jtag_slave_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      jtag_uart_0_avalon_jtag_slave_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave,
      clk => clk_0,
      jtag_uart_0_avalon_jtag_slave_dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      jtag_uart_0_avalon_jtag_slave_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      jtag_uart_0_avalon_jtag_slave_readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      jtag_uart_0_avalon_jtag_slave_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      reset_n => clk_0_reset_n,
      z80avalonmm_0_avalon_master_address_to_slave => z80avalonmm_0_avalon_master_address_to_slave,
      z80avalonmm_0_avalon_master_read_n => z80avalonmm_0_avalon_master_read_n,
      z80avalonmm_0_avalon_master_write_n => z80avalonmm_0_avalon_master_write_n,
      z80avalonmm_0_avalon_master_writedata => z80avalonmm_0_avalon_master_writedata
    );


  --the_jtag_uart_0, which is an e_ptf_instance
  the_jtag_uart_0 : jtag_uart_0
    port map(
      av_irq => jtag_uart_0_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_0_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_0_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_0_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_0_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_0_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_0_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_0_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_0_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_0_avalon_jtag_slave_writedata,
      clk => clk_0,
      rst_n => jtag_uart_0_avalon_jtag_slave_reset_n
    );


  --the_z80avalonmm_0_avalon_master, which is an e_instance
  the_z80avalonmm_0_avalon_master : z80avalonmm_0_avalon_master_arbitrator
    port map(
      z80avalonmm_0_avalon_master_address_to_slave => z80avalonmm_0_avalon_master_address_to_slave,
      z80avalonmm_0_avalon_master_readdata => z80avalonmm_0_avalon_master_readdata,
      z80avalonmm_0_avalon_master_reset_n => z80avalonmm_0_avalon_master_reset_n,
      z80avalonmm_0_avalon_master_waitrequest_n => z80avalonmm_0_avalon_master_waitrequest_n,
      clk => clk_0,
      d1_jtag_uart_0_avalon_jtag_slave_end_xfer => d1_jtag_uart_0_avalon_jtag_slave_end_xfer,
      jtag_uart_0_avalon_jtag_slave_readdata_from_sa => jtag_uart_0_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_0_avalon_jtag_slave_waitrequest_from_sa,
      reset_n => clk_0_reset_n,
      z80avalonmm_0_avalon_master_address => z80avalonmm_0_avalon_master_address,
      z80avalonmm_0_avalon_master_read_n => z80avalonmm_0_avalon_master_read_n,
      z80avalonmm_0_avalon_master_write_n => z80avalonmm_0_avalon_master_write_n,
      z80avalonmm_0_avalon_master_writedata => z80avalonmm_0_avalon_master_writedata,
      z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_granted_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_qualified_request_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_read_data_valid_jtag_uart_0_avalon_jtag_slave,
      z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave => z80avalonmm_0_requests_jtag_uart_0_avalon_jtag_slave
    );


  --the_z80avalonmm_0, which is an e_ptf_instance
  the_z80avalonmm_0 : z80avalonmm_0
    port map(
      DAT_O => internal_DAT_O_from_the_z80avalonmm_0,
      INT_n => internal_INT_n_from_the_z80avalonmm_0,
      WAIT_n => internal_WAIT_n_from_the_z80avalonmm_0,
      address => z80avalonmm_0_avalon_master_address,
      read_n => z80avalonmm_0_avalon_master_read_n,
      write_n => z80avalonmm_0_avalon_master_write_n,
      writedata => z80avalonmm_0_avalon_master_writedata,
      ADDR => ADDR_to_the_z80avalonmm_0,
      CS_n => CS_n_to_the_z80avalonmm_0,
      DAT_I => DAT_I_to_the_z80avalonmm_0,
      IORQ_n => IORQ_n_to_the_z80avalonmm_0,
      RD_n => RD_n_to_the_z80avalonmm_0,
      WR_n => WR_n_to_the_z80avalonmm_0,
      clk => clk_0,
      readdata => z80avalonmm_0_avalon_master_readdata,
      reset_n => z80avalonmm_0_avalon_master_reset_n,
      waitrequest_n => z80avalonmm_0_avalon_master_waitrequest_n
    );


  --reset is asserted asynchronously and deasserted synchronously
  bridged_jtag_uart_reset_clk_0_domain_synch : bridged_jtag_uart_reset_clk_0_domain_synch_module
    port map(
      data_out => clk_0_reset_n,
      clk => clk_0,
      data_in => module_input,
      reset_n => reset_n_sources
    );

  module_input <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000"))));
  --vhdl renameroo for output signals
  DAT_O_from_the_z80avalonmm_0 <= internal_DAT_O_from_the_z80avalonmm_0;
  --vhdl renameroo for output signals
  INT_n_from_the_z80avalonmm_0 <= internal_INT_n_from_the_z80avalonmm_0;
  --vhdl renameroo for output signals
  WAIT_n_from_the_z80avalonmm_0 <= internal_WAIT_n_from_the_z80avalonmm_0;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component bridged_jtag_uart is 
           port (
                 -- 1) global signals:
                    signal clk_0 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_z80avalonmm_0
                    signal ADDR_to_the_z80avalonmm_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal CS_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                    signal DAT_I_to_the_z80avalonmm_0 : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal DAT_O_from_the_z80avalonmm_0 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal INT_n_from_the_z80avalonmm_0 : OUT STD_LOGIC;
                    signal IORQ_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                    signal RD_n_to_the_z80avalonmm_0 : IN STD_LOGIC;
                    signal WAIT_n_from_the_z80avalonmm_0 : OUT STD_LOGIC;
                    signal WR_n_to_the_z80avalonmm_0 : IN STD_LOGIC
                 );
end component bridged_jtag_uart;

                signal ADDR_to_the_z80avalonmm_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal CS_n_to_the_z80avalonmm_0 :  STD_LOGIC;
                signal DAT_I_to_the_z80avalonmm_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal DAT_O_from_the_z80avalonmm_0 :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal INT_n_from_the_z80avalonmm_0 :  STD_LOGIC;
                signal IORQ_n_to_the_z80avalonmm_0 :  STD_LOGIC;
                signal RD_n_to_the_z80avalonmm_0 :  STD_LOGIC;
                signal WAIT_n_from_the_z80avalonmm_0 :  STD_LOGIC;
                signal WR_n_to_the_z80avalonmm_0 :  STD_LOGIC;
                signal clk :  STD_LOGIC;
                signal clk_0 :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_0_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : bridged_jtag_uart
    port map(
      DAT_O_from_the_z80avalonmm_0 => DAT_O_from_the_z80avalonmm_0,
      INT_n_from_the_z80avalonmm_0 => INT_n_from_the_z80avalonmm_0,
      WAIT_n_from_the_z80avalonmm_0 => WAIT_n_from_the_z80avalonmm_0,
      ADDR_to_the_z80avalonmm_0 => ADDR_to_the_z80avalonmm_0,
      CS_n_to_the_z80avalonmm_0 => CS_n_to_the_z80avalonmm_0,
      DAT_I_to_the_z80avalonmm_0 => DAT_I_to_the_z80avalonmm_0,
      IORQ_n_to_the_z80avalonmm_0 => IORQ_n_to_the_z80avalonmm_0,
      RD_n_to_the_z80avalonmm_0 => RD_n_to_the_z80avalonmm_0,
      WR_n_to_the_z80avalonmm_0 => WR_n_to_the_z80avalonmm_0,
      clk_0 => clk_0,
      reset_n => reset_n
    );


  process
  begin
    clk_0 <= '0';
    loop
       wait for 10 ns;
       clk_0 <= not clk_0;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
