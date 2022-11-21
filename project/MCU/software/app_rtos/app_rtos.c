#include "includes.h"

/* Definition of Task stacks */
#define TASK_STACKSIZE 2048  // Number of 32 bit words (e.g. 8192 bytes)
OS_STK task1_stk[TASK_STACKSIZE];
OS_STK task2_stk[TASK_STACKSIZE];

#define TASK1_PRIORITY 4
#define TASK2_PRIORITY 5



void task1(void* pdata)
{
    while(1)
    {
        printf("Hello from task1\n");
        OSTimeDlyHMSM(0, 0, 3, 0) // (hours, minutes, seconds, milliseconds)
    }
}

void task2(void* pdata)
{
    while(1)
    {
        printf("Hello from task2\n");
        OSTimeDlyHMSM(0, 0, 3, 0) // (hours, minutes, seconds, milliseconds)
    }
}

int main(void)
{   
    //Create the task
    OSTaskCreateExt(task1, //Pointer to task function
                NULL, // pointer to argument that is passed to task
                (void *)&task1_stk[TASK_STACKSIZE-1], // Pointer to top of task stack
                TASK1_PRIORITY, // Task priority
                TASK1_PRIORITY, // Task ID - same as priority
                task1_stk, // Pointer to bottom of task stack
                TASK_STACKSIZE, // Stacksize
                NULL, // Pointer to user supplied memory
                0); // Various task options
 



     OSTaskCreateExt(task1, 
                NULL, 
                (void *)&task1_stk[TASK_STACKSIZE-1], 
                TASK1_PRIORITY, 
                TASK1_PRIORITY, 
                task1_stk, 
                TASK_STACKSIZE, 
                NULL, 
                0); 

     

    /
    OSStart();
    return 0; 
}