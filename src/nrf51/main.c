#include "nrf_delay.h"
#include "nrf_gpio.h"

#define LED_PIN		17

int main(void)
{
	nrf_gpio_cfg_output(LED_PIN);

	for (;;) {
		nrf_gpio_pin_clear(LED_PIN);
		nrf_delay_ms(100);

		nrf_gpio_pin_set(LED_PIN);
		nrf_delay_ms(400);
	}
}
