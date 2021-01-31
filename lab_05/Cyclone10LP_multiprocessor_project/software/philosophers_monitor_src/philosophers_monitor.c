/******************************************************************************
 * Dining Philosophers for Multiprocessor Tutorial   
 *
 * Copyright (c) 2011 Altera Corporation, San Jose, California, USA.           
 * All rights reserved. All use of this software and documentation is          
 * subject to the License Agreement located at the end of this file below.     
 *                                                                        
 * Date              - May 23, 2011                                                     
 * Module            - philosophers_monitor.c           
 *
 * Known Issues      - None.
 * Minimum version   - 11.0
 *
 * Description:
 *                                                                 
 * This example allows user interaction with the 5 other CPUs representing
 * each of the 5 dining philosophers.  Via STDIN, the user is prompted to
 * enter a chopstick number to toggle its state from acquired to released
 * or released to acquired.  Run the dining_philosophers.s application
 * on 5 CPUs to watch the interaction with philosophers_monitor.
 
 * Please refer to the Altera Multiprocessor Tutorial documentation for 
 * details on this software example.
 *
 *****************************************************************************/

#include "alt_types.h"
#include <stdio.h>
#include <sys/alt_stdio.h>

/* 
 * Qsys hardware definitions
 */
#include "system.h"

/*
 * Mutex API
 */
#include "altera_avalon_mutex.h"

int main()
{

   alt_mutex_dev *chopstick_mutex[3];
   long chopsticks_held[3];

   int philosopher_id;
   int selected_chopstick_mutex_index;


   printf("Hello from top CPU %d (--instance number may be different).\n", 
          ALT_CPU_CPU_ID_VALUE);
   philosopher_id = ALT_CPU_CPU_ID_VALUE;

/* Open all accessible chopsticks. */
#ifdef PHILOSOPHER_ZERO_CHOPSTICK_MUTEX_BASE 
   chopstick_mutex[0] = altera_avalon_mutex_open("/dev/philosopher_zero_chopstick_mutex");
   chopsticks_held[0] = 0;
#endif

#ifdef PHILOSOPHER_ONE_CHOPSTICK_MUTEX_BASE 
   chopstick_mutex[1]  = altera_avalon_mutex_open("/dev/philosopher_one_chopstick_mutex");
   chopsticks_held[1] = 0;
#endif

#ifdef PHILOSOPHER_TWO_CHOPSTICK_MUTEX_BASE 
   chopstick_mutex[2]  = altera_avalon_mutex_open("/dev/philosopher_two_chopstick_mutex");
   chopsticks_held[2] = 0;
#endif
/*
#ifdef PHILOSOPHER_THREE_CHOPSTICK_MUTEX_BASE 
   chopstick_mutex[3] = altera_avalon_mutex_open("/dev/philosopher_three_chopstick_mutex");
   chopsticks_held[3] = 0;
#endif

#ifdef PHILOSOPHER_FOUR_CHOPSTICK_MUTEX_BASE 
   chopstick_mutex[4]  = altera_avalon_mutex_open("/dev/philosopher_four_chopstick_mutex");
   chopsticks_held[4] = 0;
#endif
*/
   printf ("To alternately grab or drop a chopstick, enter a chopstick id (0 - 2): \n");

   while(1)
   {
	  /* Wait for chopstick selection input on jtag_uart_top. */
      selected_chopstick_mutex_index = alt_getchar(stdin);

      /* Echo input character. */
      alt_putchar(selected_chopstick_mutex_index);

      /* Convert ASCII character to equivalent digit. */
      selected_chopstick_mutex_index -= '0';

      /* Check that a valid chopstick number selected. */
      if ((selected_chopstick_mutex_index < 0) || (selected_chopstick_mutex_index > 2))
      {
          printf ("\nPlease select a valid chopstick id (0 - 2).\n");
      }
      else
      {
         printf("\nChopstick %d selected.\n", selected_chopstick_mutex_index);

         /* Try to grab, or alternately release, the selected chopstick mutex */
         if (chopsticks_held[selected_chopstick_mutex_index])
         {
            altera_avalon_mutex_unlock (chopstick_mutex[selected_chopstick_mutex_index]);
            printf("Chopstick %d dropped.\n", selected_chopstick_mutex_index);
            chopsticks_held[selected_chopstick_mutex_index] = 0;
         }

         else
         {
            printf("Attempting to grab chopstick %d.\n", selected_chopstick_mutex_index);
            while (altera_avalon_mutex_trylock(chopstick_mutex[selected_chopstick_mutex_index], philosopher_id))
            {
            	printf("Attempting to grab chopstick %d.\n", selected_chopstick_mutex_index);
				/* Loop until selected chopstick mutex is successfully locked */;
            }
            printf("Chopstick %d grabbed.\n", selected_chopstick_mutex_index);
            chopsticks_held[selected_chopstick_mutex_index] = 1;
         }
      }
   }

   return(0);
}

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2011 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

