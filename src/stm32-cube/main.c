#include <stm32f0xx.h>
#include "stm32f0xx_it.h"

#define LED_PIN 5

void SysTick_Handler(void)
{
	/* Toggle GPIO pin PA5: */
	GPIOA->ODR ^= (1U << LED_PIN);
}

int main(void)
{
	/* Enable clock for GPIOA and set GPIO pin PA5 as output: */
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	GPIOA->MODER |= (1U << (2 * LED_PIN));

	/* Initialize SysTick to generate an interrupt every half-second: */
	SysTick_Config(SystemCoreClock / 2);

	while (1);
}
