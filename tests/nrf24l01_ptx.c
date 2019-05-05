/* Here in lies a concerted and complete effort to get my Nordic
 * nRF24L01+ working. I've had this thing collecting dust for
 * about a year, and it's time to buckle down and figure it out.
 */

#include <avrm/uart.h>
#include <avrm/delay.h>
#include <nrf24l01.h>

int main(void)
{
  // Setup the UART, necessary for stdio actions.
  uart_init();

  // Wait for the nRF24L01p to be ready.
  delay_us(nRF24L01p_TIMING_INITIAL_US);

  // Initialize the nRF24L01p.
  // TODO: Actual info for arguments.
  nRF24L01p_init(0, 0);

  // Enable pipe 0.
  nRF24L01p_config_pipe(nRF24L01p_PIPE_0, 0xA7A7A7A7A7, 32);

  // Set TX mode.
  nRF24L01p_config_transceiver_mode(nRF24L01p_VALUE_CONFIG_PRIM_TX);

  // const char *str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit,
  // sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
  // minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea
  // commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit
  // esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
  // non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  const char *str = "This is something that is exactly 96 char long so as to fill the FIFOs completly. Sorry friend.";

  for (;;)
  {
    nRF24L01p_write((byte *) str, 96, nRF24L01p_PIPE_0);
    delay_ms(1000);
  }

  return 0;
}
