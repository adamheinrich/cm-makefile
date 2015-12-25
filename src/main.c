#include <stm32f0xx.h>

#define LED_PIN 5
 
void SysTick_Handler(void)
{
	GPIOA->ODR ^= (1UL << LED_PIN);
}

int main(void)
{
	/* Enable clock for GPIOA and set GPIO pin PA5 as output: */
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	GPIOA->MODER |= (1UL << (2*LED_PIN));

	/* Initialize SysTick to generate an interrupt every half-second: */
	SysTick_Config(SystemCoreClock / 2);

	while (1);
}
