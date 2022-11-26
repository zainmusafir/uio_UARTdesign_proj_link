#include <stdio.h>
#include "system.h" //access Nios II system info
#include "io.h" //access to IORD and IORW
#include "unistd.h" //access to usleep
#include "altera_avalon_pio_regs.h" //access to PIO macros
#include <sys/alt_irq.h> // access to the IRQ routines
#include "altera_avalon_spi.h"

/* Declare a global variable to holds the edge capture value
Declaring a variable as volatile tells the compiler that
the value of the variable may change at any time without
any action being taken by the code the compiler finds nearby.
This variable will be connected to the interrupt register which
is controlled from HW and not SW. The compile will therefor not
find any code that controls this variable, and if not declared as
volatile, the compile may decided to optimize and remove this variable. */
volatile int edge_capture;
volatile int uart_status;

/* This is the ISR which will be called when the system signals an interrupt. */
static void handle_interrupts(void* context)
{   
    //Cast context to edge_capture's type
    //Volatile to avoid compiler optimization
    //this will point to the edge_capture variable.
    volatile int* edge_capture_ptr = (volatile int*) context;

    //Read the edge capture register on the PIO and store the value
    //The value will be stored in the edge_capture variable and accessible
    //from other parts of the code.
    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(PIO_IRQ_BASE);

    //Write to edge capture register to reset it
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_IRQ_BASE,0);

}


static void handle_interrupt_uart(void* context)
{   
   
    volatile int* uart_status_ptr = (volatile int*) context;
    //Read the UART module’s status register and store the value in the volatile int variable uart_status.
    
    *uart_status_ptr = IORD(UART_BASIC_BASE,2);
    //Reset the interrupt bits in the UART module’s status register. This is done by performing a 
    //write operation to the UART’s status register.
    IOWR(UART_BASIC_BASE,2,0);

}


/* This function is used to initializes and registers the interrupt handler. */
static void init_interrupt_pio()
{
    //Recast the edge_capture point to match the
    //alt_irq_register() function prototypo
    void* edge_capture_ptr = (void*)&edge_capture;

    //Enable a single interrupt input by writing a one to the corresponding interruptmask bit locations
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_IRQ_BASE,0x1);

    //Reset the edge capture register
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_IRQ_BASE,0);

    //Register the interrupt handler in the system
    //The ID and PIO_IRQ number is available from the system.h file.
    alt_ic_isr_register(PIO_IRQ_IRQ_INTERRUPT_CONTROLLER_ID,
        PIO_IRQ_IRQ, handle_interrupts, edge_capture_ptr, 0x0);

    /* In order to keep the impact of interrupts on the execution of the main program to a minimum,
    it is important to keep interrupt routines short. If additional processing is necessary for a
    particular interrupt, it is better to do this outside of the ISR. E.g., checking the value
    of the edge_capture variable.*/

}

static void init_interrupt_uart()
{
    //Recast the uart_status_ptr  to match the alt_irq_register() function prototype
    //Note that uart_status has been declared as a volatile int up top
    void* uart_status_ptr = (void*)&uart_status;
    //Register the interrupt handler in the system
    //The ID and UART_BASIC_0_IRQ number is available from the system.h file.
    alt_ic_isr_register(UART_BASIC_0_IRQ_INTERRUPT_CONTROLLER_ID,
        UART_BASIC_0_IRQ, handle_interrupt_uart, uart_status_ptr, 0x0);
}



int main(){
    printf("Hello, World!\n");
    int sw_data = 1;
    //accelerometer data
    int return_codex;


    alt_u8 spi_rx_data[6];
    alt_u8 spi_tx_data[6];

    alt_u8 spi_tx[8];
    alt_u8 spi_rx[8];

    //reading from adXL regs
    spi_tx[0] = 0xc0 | 0x32; //multiple-byte read + address of first data register.
    return_codex = alt_avalon_spi_command(SPI_BASE,0,1,spi_tx,6,spi_rx,0);


 // To read device ID register send 0x80
    spi_tx_data[0] = 0x80 | 0x0; //Single byte read + address
    return_codex = alt_avalon_spi_command(SPI_BASE, 0, 1, spi_tx_data, 1, spi_rx_data, 0);


printf("returned id : %x \n",*spi_rx_data);
    // Initialize the interrupt
    init_interrupt_pio();init_interrupt_uart();
    
    while(1){
        //Access registers using IORD and IOWR from io.h
        sw_data = IORD(PIO_SW_BASE,0);
        IOWR(PIO_LED_BASE,0,sw_data);
        

         if (uart_status>0)
        {
            //Check if rx_irq bit is set
            if ((uart_status >> 5) & 0x1)   //rx bit 
            {
            
            rx_data=IORD(UART_BASIC_BASE,1);
            IOWR(UART_BASIC_BASE,1,rx_data);   //write to tx
            }
1
             
            if ((uart_status >> 4) & 0x1) //tx bit 
            {   
            
        
            }  
            // Now some of the other status bits may have been set, but we
            // don´t do anything with them yet
        }
        //Alternative solution using PIO macros
        //sw_data = IORD_ALTERA_AVALON_PIO_DATA(PIO_SW_BASE);
        //IOWR_ALTERA_AVALON_PIO_DATA(PIO_LED_BASE,sw_data);

        // When an interrupt event has occurred, the edge_capture variable has been updated
        // Poll the edge capture variable check for interrupt
        if (edge_capture == 0x1) //bit position 0 corresponds to button press
        {
            printf("Interrupt detected, Key1 was pressed!\n");
            edge_capture = 0; // reset variable to "unregister" event
        }
        
        usleep(100000); //sleep 100 us

    }
    return 0;
}