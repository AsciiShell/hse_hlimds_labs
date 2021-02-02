/******************************************************************************
 * Philosophers Monitor for Multiprocessor Tutorial   
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
 * This example allows user intercation with the 5 other CPUs representing
 * each of the 5 dining philosophers.  Via STDIN, the user is prompted to
 * enter a chopstick number to toggle its state from acquired to released
 * or released to acquired.  Run the dining_philosophers.s application
 * on 5 CPUs to watch the interaction with philosophers_monitor.
 
 * Please refer to the Altera Multiprocessor Tutorial documentation for 
 * details on this software example.
 *
 *****************************************************************************/

#include <stdio.h>

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

   alt_mutex_dev *left_chopstick, *right_chopstick;
   int philosopher_id;

   printf("Hello from CPU %d  (--instance number may be different).\n", 
          ALT_CPU_CPU_ID_VALUE);
   philosopher_id = ALT_CPU_CPU_ID_VALUE;
   

/* System.h is unique for each philosopher cpu and corresponding BSP.
 * system.h holds the base #defines for all accessible peripherals
 * via each cpu's unique memory map.  Only 2 mutex peripherals are
 * accessible by any philosopher cpu, while all 5 mutex peripherals
 * are accessible through cpu named, cpu_top.  Assign left and right
 * chopsticks based on visibility of the mutex peripherals.
 */
 
#ifdef PHILOSOPHER_ZERO_CHOPSTICK_MUTEX_BASE 
#ifdef PHILOSOPHER_ONE_CHOPSTICK_MUTEX_BASE 
   /* Identified as philosopher 0. */
   left_chopstick = altera_avalon_mutex_open( "/dev/philosopher_zero_chopstick_mutex");
   right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_one_chopstick_mutex");
#endif
#endif

#ifdef PHILOSOPHER_ONE_CHOPSTICK_MUTEX_BASE 
#ifdef PHILOSOPHER_TWO_CHOPSTICK_MUTEX_BASE 
   /* Identified as philosopher 1. */
   left_chopstick = altera_avalon_mutex_open( "/dev/philosopher_one_chopstick_mutex");
   right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_two_chopstick_mutex");
#endif
#endif

#ifdef PHILOSOPHER_TWO_CHOPSTICK_MUTEX_BASE 
//#ifdef PHILOSOPHER_THREE_CHOPSTICK_MUTEX_BASE 
#ifdef PHILOSOPHER_ZERO_CHOPSTICK_MUTEX_BASE 
   /* Identified as philosopher 2. */
   left_chopstick = altera_avalon_mutex_open( "/dev/philosopher_two_chopstick_mutex");
  // right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_three_chopstick_mutex");
   right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_zero_chopstick_mutex");
#endif
#endif


//#ifdef PHILOSOPHER_THREE_CHOPSTICK_MUTEX_BASE 
//#ifdef PHILOSOPHER_FOUR_CHOPSTICK_MUTEX_BASE 
   /* Identified as philosopher 3. */
//   left_chopstick = altera_avalon_mutex_open( "/dev/philosopher_three_chopstick_mutex");
//   right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_four_chopstick_mutex");
//#endif
//#endif

//#ifdef PHILOSOPHER_FOUR_CHOPSTICK_MUTEX_BASE 
//#ifdef PHILOSOPHER_ZERO_CHOPSTICK_MUTEX_BASE 
   /* Identified as philosopher 4. */
//   left_chopstick = altera_avalon_mutex_open( "/dev/philosopher_four_chopstick_mutex");
//   right_chopstick = altera_avalon_mutex_open( "/dev/philosopher_zero_chopstick_mutex");
//#endif
//#endif



/* Each philosopher performs a repeating sequence of activities.  Think,
 * grab left chopstick, grab right chopstick, eat, and drop both chopsticks.
 * If the philosopher cannot immediately grab the right chopstick after 
 * successfully acquiring the left chopstick, the left chopstick must be 
 * immediately dropped.  This prevents a deadlock situation which could
 * otherwise occur if all philosophers n picked up their left chopstick at
 * the same time, and then all philosophers waited indefinitely for 
 * philosopher ((n+1)%5) to complete eating and drop their left chopstick.
 */
 
 /* Think, grab left chopstick, grab right chopstick, eat, 
  * drop both chopsticks, repeat.
  */
   while(1)
   {
      if (!altera_avalon_mutex_trylock (left_chopstick, philosopher_id))
      {
         if (!altera_avalon_mutex_trylock (right_chopstick, philosopher_id))
         {
         		/* Both chopstick successfully acquired. */
            printf ("Philosopher %d is eating.\n", philosopher_id);
            altera_avalon_mutex_unlock (right_chopstick);
         }
         else
         {
         	  /* To prevent deadlock, immediately drop the left chopstick
         	   * if the right chopstick cannot be immediately acquired.
         	   */
            printf ("Philosopher %d could not pick up the right_chopstick.\n", philosopher_id);
         }
         altera_avalon_mutex_unlock (left_chopstick);
      }
      else
      { 
         printf ("Philosopher %d could not pick up the left_chopstick.\n", philosopher_id);
      }
   printf ("Philosopher %d is thinking.\n", philosopher_id);

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

