/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#include "stdlib.h"
#include "Accel.h"

#define I2C_SLAVE_WRITE(x) (x & 0xfe)
#define I2C_SLAVE_READ(x) (x | 0x01)

void accel_setup_interrupt (void) {
    uint8_t data[] = {I2C_SLAVE_WRITE(ACCEL_ADDR), 0x00, 0x00};

    USI_TWI_Master_Initialise();

    data[1] = THRESH_TAP_ADDR;
    data[2] = THRESH_TAP_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = DUR_ADDR;
    data[2] = DUR_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = TAP_AXES_ADDR;
    data[2] = TAP_AXES_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = ACT_TAP_AXES_ADDR;
    data[2] = ACT_TAP_AXES_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = PWR_CTL_ADDR;
    data[2] = PWR_CTL_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = INT_MAP_ADDR;
    data[2] = INT_MAP_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);

    data[1] = INT_ENABLE_ADDR;
    data[2] = INT_ENABLE_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, sizeof(data), FALSE);
}
