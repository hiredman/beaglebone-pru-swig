%module PRU

%{
#include <prussdrv.h>
  %}


#include <sys/types.h>
#include <pthread.h>

#define NUM_PRU_HOSTIRQS        8
#define NUM_PRU_HOSTS          10
#define NUM_PRU_CHANNELS       10
#define NUM_PRU_SYS_EVTS       64

#define PRUSS0_PRU0_DATARAM     0
#define PRUSS0_PRU1_DATARAM     1
#define PRUSS0_PRU0_IRAM        2
#define PRUSS0_PRU1_IRAM        3

 //Available in AM33xx series - begin
#define PRUSS0_SHARED_DATARAM   4
#define PRUSS0_CFG              5
#define PRUSS0_UART             6
#define PRUSS0_IEP              7
#define PRUSS0_ECAP             8
#define PRUSS0_MII_RT           9
#define PRUSS0_MDIO            10
 //Available in AM33xx series - end

#define PRU_EVTOUT_0            0
#define PRU_EVTOUT_1            1
#define PRU_EVTOUT_2            2
#define PRU_EVTOUT_3            3
#define PRU_EVTOUT_4            4
#define PRU_EVTOUT_5            5
#define PRU_EVTOUT_6            6
#define PRU_EVTOUT_7            7

typedef void *(*prussdrv_function_handler) (void *);
/* typedef struct __sysevt_to_channel_map { */
/*   short sysevt; */
/*   short channel; */
/* } tsysevt_to_channel_map; */
/* typedef struct __channel_to_host_map { */
/*   short channel; */
/*   short host; */
/* } tchannel_to_host_map; */
/* typedef struct __pruss_intc_initdata { */
/*   //Enabled SYSEVTs - Range:0..63 */
/*   //{-1} indicates end of list */
/*   char sysevts_enabled[NUM_PRU_SYS_EVTS]; */
/*   //SysEvt to Channel map. SYSEVTs - Range:0..63 Channels -Range: 0..9 */
/*   //{-1, -1} indicates end of list */
/*   tsysevt_to_channel_map sysevt_to_channel_map[NUM_PRU_SYS_EVTS]; */
/*   //Channel to Host map.Channels -Range: 0..9  HOSTs - Range:0..9 */
/*   //{-1, -1} indicates end of list */
/*   tchannel_to_host_map channel_to_host_map[NUM_PRU_CHANNELS]; */
/*   //10-bit mask - Enable Host0-Host9 {Host0/1:PRU0/1, Host2..9 : PRUEVT_OUT0..7) */
/*   unsigned int host_enable_bitmask; */
/* } tpruss_intc_initdata; */

int prussdrv_init(void);

int prussdrv_open(unsigned int pru_evtout_num);

int prussdrv_pru_reset(unsigned int prunum);

int prussdrv_pru_disable(unsigned int prunum);

int prussdrv_pru_enable(unsigned int prunum);

int prussdrv_pru_write_memory(unsigned int pru_ram_id,
                              unsigned int wordoffset,
                              unsigned int *memarea,
                              unsigned int bytelength);

int prussdrv_pruintc_init(tpruss_intc_initdata * prussintc_init_data);

int prussdrv_map_l3mem(void **address);

int prussdrv_map_extmem(void **address);

int prussdrv_map_prumem(unsigned int pru_ram_id, void **address);

int prussdrv_map_peripheral_io(unsigned int per_id, void **address);

unsigned int prussdrv_get_phys_addr(void *address);

void *prussdrv_get_virt_addr(unsigned int phyaddr);

int prussdrv_pru_wait_event(unsigned int pru_evtout_num);

int prussdrv_pru_send_event(unsigned int eventnum);

int prussdrv_pru_clear_event(unsigned int eventnum);

int prussdrv_pru_send_wait_clear_event(unsigned int send_eventnum,
                                       unsigned int pru_evtout_num,
                                       unsigned int ack_eventnum);

int prussdrv_exit(void);

int prussdrv_exec_program(int prunum, char *filename);

int prussdrv_start_irqthread(unsigned int pru_evtout_num, int priority,
                             prussdrv_function_handler irqhandler);

tpruss_intc_initdata * prussdrv_pruintc_init_data(void);

#define AM33XX
#ifdef AM33XX
#define PRU0_PRU1_INTERRUPT     17
#define PRU1_PRU0_INTERRUPT     18
#define PRU0_ARM_INTERRUPT      19
#define PRU1_ARM_INTERRUPT      20
#define ARM_PRU0_INTERRUPT      21
#define ARM_PRU1_INTERRUPT      22
#else
#define PRU0_PRU1_INTERRUPT     32
#define PRU1_PRU0_INTERRUPT     33
#define PRU0_ARM_INTERRUPT      34
#define PRU1_ARM_INTERRUPT      35
#define ARM_PRU0_INTERRUPT      36
#define ARM_PRU1_INTERRUPT      37
#endif
#define CHANNEL0                0
#define CHANNEL1                1
#define CHANNEL2                2
#define CHANNEL3                3
#define CHANNEL4                4
#define CHANNEL5                5
#define CHANNEL6                6
#define CHANNEL7                7
#define CHANNEL8                8
#define CHANNEL9                9

#define PRU0                    0
#define PRU1                    1
#define PRU_EVTOUT0             2
#define PRU_EVTOUT1             3
#define PRU_EVTOUT2             4
#define PRU_EVTOUT3             5
#define PRU_EVTOUT4             6
#define PRU_EVTOUT5             7
#define PRU_EVTOUT6             8
#define PRU_EVTOUT7             9

#define PRU0_HOSTEN_MASK            0x0001
#define PRU1_HOSTEN_MASK            0x0002
#define PRU_EVTOUT0_HOSTEN_MASK     0x0004
#define PRU_EVTOUT1_HOSTEN_MASK     0x0008
#define PRU_EVTOUT2_HOSTEN_MASK     0x0010
#define PRU_EVTOUT3_HOSTEN_MASK     0x0020
#define PRU_EVTOUT4_HOSTEN_MASK     0x0040
#define PRU_EVTOUT5_HOSTEN_MASK     0x0080
#define PRU_EVTOUT6_HOSTEN_MASK     0x0100
#define PRU_EVTOUT7_HOSTEN_MASK     0x0200


#define PRUSS_INTC_INITDATA {   \
{ PRU0_PRU1_INTERRUPT, PRU1_PRU0_INTERRUPT, PRU0_ARM_INTERRUPT, PRU1_ARM_INTERRUPT, ARM_PRU0_INTERRUPT, ARM_PRU1_INTERRUPT,  -1  },  \
{ {PRU0_PRU1_INTERRUPT,CHANNEL1}, {PRU1_PRU0_INTERRUPT, CHANNEL0}, {PRU0_ARM_INTERRUPT,CHANNEL2}, {PRU1_ARM_INTERRUPT, CHANNEL3}, {ARM_PRU0_INTERRUPT, CHANNEL0}, {ARM_PRU1_INTERRUPT, CHANNEL1},  {-1,-1}},  \
 {  {CHANNEL0,PRU0}, {CHANNEL1, PRU1}, {CHANNEL2, PRU_EVTOUT0}, {CHANNEL3, PRU_EVTOUT1}, {-1,-1} },  \
 (PRU0_HOSTEN_MASK | PRU1_HOSTEN_MASK | PRU_EVTOUT0_HOSTEN_MASK | PRU_EVTOUT1_HOSTEN_MASK) /*Enable PRU0, PRU1, PRU_EVTOUT0 */ \
} \

