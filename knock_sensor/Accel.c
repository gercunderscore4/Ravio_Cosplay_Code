/****************************************************************
 * Accelerometer interface for ATtiny85
 ****************************************************************/

#include "stdlib.h"
#include "Accel.h"

#define I2C_SLAVE_WRITE(x) (x & 0xfe)
#define I2C_SLAVE_READ(x) (x | 0x01)

void accel_setup_interrupt (void) {
    uint8_t data[3] = {0, 0, 0};

    USI_TWI_Master_Initialise();

    data[0] = I2C_SLAVE_WRITE(ACCEL_ADDR);
    data[1] = THRESH_TAP_ADDR;
    data[2] = THRESH_TAP_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = DUR_ADDR;
    data[2] = DUR_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = TAP_AXES_ADDR;
    data[2] = TAP_AXES_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = ACT_TAP_AXES_ADDR;
    data[2] = ACT_TAP_AXES_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = PWR_CTL_ADDR;
    data[2] = PWR_CTL_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = INT_MAP_ADDR;
    data[2] = INT_MAP_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);

    data[1] = INT_ENABLE_ADDR;
    data[2] = INT_ENABLE_VALUE;
    USI_TWI_Start_Transceiver_With_Data_Stop(data, 3, FALSE);
}

void accel_clear_interrupt (void) {
    uint8_t data[] = {
        I2C_SLAVE_WRITE(ACCEL_ADDR),
        INT_SOURCE_ADDR,
    };
    uint8_t more_data[] = {
        I2C_SLAVE_READ(ACCEL_ADDR), 
        0x00,
    };

    USI_TWI_Start_Transceiver_With_Data_Stop(data, 2, FALSE);
    USI_TWI_Start_Transceiver_With_Data_Stop(more_data, 2, TRUE);
}
