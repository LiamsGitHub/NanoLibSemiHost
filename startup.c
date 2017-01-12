/*
 * startup.c
 *
 * This code is adapted from Johan Simonsson's Mini Example project at http://fun-tech.se/stm32/OlimexBlinky/mini.php
 * Demonstrates startup using C instead of the usual assembly
 * Adjusted to work with my Linker file and Makefile targeting the STM32F100C8
 * Did not bother to set up NVIC
 *  Created on: Mar 29, 2014
 *      Author: Liam
 */

extern int main(void);
extern void SystemInit(void);

extern unsigned int __stack_base__;

extern unsigned long _start_data_flash;		/* start address for the initialization values of the .data section. defined in linker script */
extern unsigned long __data_start__;		/* start address for the .data section. defined in linker script */
extern unsigned long __data_end__;		/* end address for the .data section. defined in linker script */

extern unsigned long __bss_start__;			/* start address for the .bss section. defined in linker script */
extern unsigned long __bss_end__;			/* end address for the .bss section. defined in linker script */

void init_memory(void);
void Reset_Handler(void);
void nmi_handler(void);
void hardfault_handler(void);


// Define the vector table
unsigned int * myvectors[4]
__attribute__ ((section(".vectors")))= {
    (unsigned int *)	&__stack_base__,         // stack pointer
    (unsigned int *) 	Reset_Handler,     // code entry point
    (unsigned int *)	nmi_handler,       // NMI handler (not really)
    (unsigned int *)	hardfault_handler  // hard fault handler (let's hope not)
};

void init_memory(void)
{
    unsigned long *pulDest;
    unsigned long *pulSrc;

    // Copy the data segment initializers from flash to SRAM in ROM mode

		pulSrc = &_start_data_flash;
		for(pulDest = &__data_start__; pulDest < &__data_end__; ) {
			*(pulDest++) = *(pulSrc++);
		}

    // Zero fill the bss segment.
    //
    for(pulDest = &__bss_start__; pulDest < &__bss_end__; )
    {
        *(pulDest++) = 0;
    }

}

void Reset_Handler(void)
{
	SystemInit(); // Set up the clocks and low level initialization like BSS
    main(); // Application entry point
}


void nmi_handler(void)
{
    return ;
}

void hardfault_handler(void)
{
    return ;
}
