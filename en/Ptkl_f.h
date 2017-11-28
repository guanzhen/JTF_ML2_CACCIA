/* ************************************************************************************************
   1  DESCRIPTION
   ************************************************************************************************
*/
/*!
 * \file              Ptkl_f.h
 *
 * \brief             Header for structurs and "addresses" of feeder data
 *
 * \author            Alexander Worzischek
 *
 * \date  14.02.13,   Initial version
 * \version 24.11.14, X8: V0.28, E8: V0.02 \n
 *                    - Param VALUE_ENCSPW_IDXPOS renamed to VALUE_ENCSPW_IDXPOS_FACT. \n
 *                    - Params VALUE_ENCSPW_PERIODPOS and VALUE_ENCSPW_IDXERRPOSDIFF added. \n
 *                    - Params PARAM_WARNING_COMMON,VALUE_CANERRCAPTURE, VALUE_CANERRCAPTURE_PREV
 *                      and VALUE_CAN_RX_TX_ERRCNT added. \n
 * \version 28.04.15, X8: V0.31, E8: V0.02 \n
 *                    - TST_EVENTLOG and VALUE_EVENTLOG_ADDR_STATE added. \n
 *                    - VALUE_TAPEDRV_REQUEST_FLAGS added. \n
 * \version 25.11.15, X8: V0.35, E8: V0.02 \n
 *                    - VALUE_TAPEDRV_FEEDER_OFFSET and VALUE_TAPEDRV_PUP_ALIGN_OFFSET added. \n
 *                      VALUE_TAPEDRV_POS_ERR_PITR_IDLE_OK_START_STOP,
 *                      VALUE_TAPEDRV_POS_ERR_PITR_IDLE_OK_MIN_MAX,
 *                      VALUE_TAPEDRV_POS_ERR_PITR_ROT_ALIGN_CTRL_START_STOP and
 *                      VALUE_TAPEDRV_POS_ERR_PITR_ROT_ALIGN_CTRL_MIN_MAX added. \n
 * \version 22.02.16, X8: V0.36, E8: V0.02 \n
 *                    - VALUE_TAPEDRV_MONITOR_FLAGS and VALUE_FOILDRV_MONITOR_FLAGS added. \n
 * \version 24.08.16, X8: V0.37, E8: V0.02 \n
 *                    - Renaming of several variables and defines to adapt to project X24Smart. \n
 *
 * \b Description: \n
 * Text
 */

#ifndef PTKL_F_H_
#define PTKL_F_H_


/* ************************************************************************************************
   2  INCLUDE FILES
   ************************************************************************************************
*/


/* ************************************************************************************************
   3  DEFINES
   ************************************************************************************************
*/
// defines PARAM_xxxx are fixed numbers for accessing variables (which location in RAM varies) via CAN

#define PARAM_FEEDER_TYPE                               0x01  ///< feedertype
#define PARAM_CAN_WARNING_CNT                           0x03  ///< "number of CAN warning level reached"
#define PARAM_CPU_TEMPERATURE_MAX                       0x05  ///< maximum temperature of the processor during lifetime
#define PARAM_ALARM_COMMON                              0x07  ///< current alarm state of the feeder as entire module (no track alarms), Note: entire variable readable, while reading via MC_FEEDERALARMS gets only masked variable
#define PARAM_ALARM_COMMON_PREVIOUS                     0x08  ///< last alarm state of the feeder as entire module (no track alarms)
#define PARAM_WARNING_COMMON                            0x09  ///< current warning state of the feeder as entire module (no track warnings)

// 0x10 ---------------------------------------------------------------------------------------------------------------------------------------------
#define PARAM_ALARM_TRACK1                              0x11  ///< current alarm state of the feeders track 1
#define PARAM_ALARM_TRACK1_PREVIOUS                     0x12  ///< previous alarm state of the feeders track 1
#define PARAM_FEED_CNT_SINCE_SPLICE                     0x15  ///< number of transport cycles since the last detected splice

// 0x20 ---------------------------------------------------------------------------------------------------------------------------------------------
#define PARAM_DRV_TAPE_CYCLE_CNT                        0x26  ///< number of transport cycles (activations) of the tape drive
#define PARAM_DRV_FOIL_CYCLE_CNT                        0x27  ///< number of transport cycles (activations) of the foil drive

// 0x30 ---------------------------------------------------------------------------------------------------------------------------------------------
#define PARAM_OFFSET_PUP_ALIGN                          0x31  ///< alignment of the construction based offset of the pickup position, e.g. for fine tuning
#define PARAM_SPLICE_CONNECT_ERR_CNT                    0x35  ///< number of splice sensor disconnections
#define PARAM_ENCODER_MOTOR_ERROR                       0x37  ///< array with error states of all motor encoders
#define PARAM_RTDAT_EEP_SAVE_INCOMPL_CNT                0x3A  ///< number of incomplete saves of runtime data to eeprom
#define PARAM_RTDAT_FLA_PAGE_ERR_CNT                    0x3B  ///< number of CRC errors in the runtime data flash pages
#define PARAM_RTDAT_FLA_SAVE_INCOMPL_CNT                0x3C  ///< number of incomplete saves of runtime data to flash
#define PARAM_DRV_TAPE_DISTANCE_CNT                     0x3D  ///< moved distance [mm] of tape drive during lifetime -> used by feeder test box, so do not change the value!

// parameter numbers for Test/Debugging
// 0x40 ---------------------------------------------------------------------------------------------------------------------------------------------
#define TST_FLASHINITSAVEADDR                           0x40  ///< Nummern der aktuellen Init- und der Save-Page
#define TST_FLASHPAGESTATE                              0x41  ///< Zustand der 4 flash pages zur Datensicherung
#define TST_SYSUPTIME1                                  0x42  ///< Betriebszeit in flash page 1
#define TST_SYSUPTIME2                                  0x43  ///< Betriebszeit in flash page 2
#define TST_SYSUPTIME3                                  0x44  ///< Betriebszeit in flash page 3
#define TST_SYSUPTIME4                                  0x45  ///< Betriebszeit in flash page 4
#define TST_FLASHERASETIME                              0x46  ///< Zeitdauer zum Löschen einer flash page
#define TST_RD_WR_MEMORY                                0x47  ///< r/w of a 16bit value of/to RAM or flash (not usable via X-FCU as telegram length has to be extended with a long value for flash address)
#define TST_ERASE_FLASHPAGE                             0x48  ///< erase a given flash page (not usable via X-FCU as telegram length has to be extended with a long value for flash address)
#define TST_STORE_FACTDATA_FLASH                        0x49  ///< store factory to DSC data flash
#define TST_STORE_LIFECYCLETEST_DATA                    0x4A  ///< store life cycle test data (e.g. CAN-ID, etc.) to DSC data flash
#define TST_CONFIG_LIFECYCLETEST_DRIVE                  0x4B  ///< config drive tape used in lifecycle test
//#define TST_                                            0x4C  ///<
#define TST_EVENTLOG                                    0x4D  ///< 


// Adressen der Factory Daten
// 0x50 ---------------------------------------------------------------------------------------------------------------------------------------------
#define FACTDATA_START_ADDRESS                          0x50  ///< Define für Startadresse der Factory-Daten um Adressen im CAN-Kommando auf Gültigkeit prüfen zu können
#define FACTDATA_ASSEMBLYSTATE                          0x50  ///< current state during assembly of the feeder
#define FACTDATA_TESTJIGNUMBER                          0x51  ///< No. of the test jig the feeder has been checked
#define FACTDATA_FEEDERTYPE                             0x52  ///< feedertype
#define FACTDATA_MANUFACTURER                           0x53  ///< manufacturer (abbreviation: KL = ASM Munich)
#define FACTDATA_MANUFACTDATE                           0x54  ///< manufacturing date: year/month (according to Siemens code)
#define FACTDATA_MANUFACTDAY                            0x55  ///< manufacturing date: day
#define FACTDATA_SERIALNUMBER                           0x56  ///< serial number
#define FACTDATA_MATERIALNUMBER1                        0x57  ///< material-No. of the entire feeder part 1
#define FACTDATA_MATERIALNUMBER2                        0x58  ///< material-No. of the entire feeder part 2
#define FACTDATA_MATERIALNUMBER3                        0x59  ///< material-No. of the entire feeder part 3
#define FACTDATA_SLOTEDIFNUMBER                         0x5A  ///< number of occupied slots on a X-feedertable and mounted EDIFs

// 0x60 ---------------------------------------------------------------------------------------------------------------------------------------------
#define FACTDATA_ASSEMBLYSTATE_TD                       0x60  ///< current state during assembly of the tape drive
#define FACTDATA_TESTJIGNUMBER_TD                       0x61  ///< No. of the test jig the tape drive has been checked
#define FACTDATA_DRIVETYPE                              0x62  ///< type of tape drive
#define FACTDATA_MANUFACTURER_TD                        0x63  ///< manufacturer (abbreviation: KL = ASM Munich)
#define FACTDATA_MANUFACTDATE_TD                        0x64  ///< manufacturing date: year/month (according to Siemens code)
#define FACTDATA_MANUFACTDAY_TD                         0x65  ///< manufacturing date: day
#define FACTDATA_SERIALNUMBER_TD                        0x66  ///< serial number
#define FACTDATA_MATERIALNUMBER1_TD                     0x67  ///< material-No. of the tape drive part 1
#define FACTDATA_MATERIALNUMBER2_TD                     0x68  ///< material-No. of the tape drive part 2
#define FACTDATA_MATERIALNUMBER3_TD                     0x69  ///< material-No. of the tape drive part 3
#define FACTDATA_OFFSET_PUP1                            0x6A  ///< offset of pickup position #1
#define FACTDATA_OFFSET_PUP2                            0x6B  ///< offset of pickup position #2
#define FACTDATA_OFFSET_PUP3                            0x6C  ///< offset of pickup position #3
#define FACTDATA_OFFSET_PUP4                            0x6D  ///< offset of pickup position #4
//#define FACTDATA_COMPTABLEVALIDLEFT                     0x63       // nicht implementiert
//#define FACTDATA_COMPVALUESPROCKET01LEFT                0x64       // nicht implementiert
//#define FACTDATA_COMPVALUESPROCKET45LEFT                0x90       // nicht implementiert
//#define FACTDATA_END_ADDRESS                            0xCD  ///< Define for Endadresse der Factory-Daten um Adressen im CAN-Kommando auf Gültigkeit prüfen zu können
//#define FACTDATA_CMD_RESTORE                            0xCE  ///< Factory Daten vom Flash ins RAM laden (um Speicherinhalt verifizieren zu können)
//#define FACTDATA_CMD_STORE                              0xCF  ///< Speichern der Factory Daten ins Flash (Daten für Sicherungscode im CAN-Telegramm müssen 0xAA 0x55 sein)

#define FREE_USE                                        0x77  ///< free use for debugging

// Hardware Adressen und Debug-Variablen

// 0x80 TAPE DRIVE ----------------------------------------------------------------------------------------------------------------------------------
#define VALUE_TAPEDRV_FLAGS                                     0x80  ///< various flags indication actual states of the tape drive
#define VALUE_TAPEDRV_CTRL_STATE                                0x81  ///< current state of tape drive motion control state machine
#define VALUE_TAPEDRV_MONITOR_STATE                             0x82  ///< current state of tape drive monitor state machine
#define VALUE_TAPEDRV_MOVEMENT_TYPE                             0x83  ///< type of the previous tape drive movement
#define VALUE_TAPEDRV_MOVEMENT_MODE                             0x84  ///< mode of the previous tape drive movement
#define VALUE_TAPEDRV_TIMEOUT                                   0x85  ///< timeout [ms] to stop the drive if no regular stop condition occurred before timeout has elapsed
#define VALUE_TAPEDRV_MONITOR_FLAGS                             0x86  ///< flags for tape drive monitor
#define VALUE_TAPEDRV_REQUEST_FLAGS                             0x87  ///< flags for requesting the tape drive to execute a movement type
#define VALUE_TAPEDRV_POS_ERR_PITR_IDLE_OK_START_STOP           0x88  ///< pos error [um] at begin and end of state TPDR_CTRL_STATUS_PITCH_TRANS_IDLE_OK
#define VALUE_TAPEDRV_POS_ERR_PITR_IDLE_OK_MIN_MAX              0x89  ///< min and max (signed) pos error [um] in state TPDR_CTRL_STATUS_PITCH_TRANS_IDLE_OK
#define VALUE_TAPEDRV_POS_ERR_PITR_ROT_ALIGN_CTRL_START_STOP    0x8A  ///< pos error [um] at begin and end of state TPDR_CTRL_STATUS_PITCH_TRANS_ROT_ALIGN_CTRL
#define VALUE_TAPEDRV_POS_ERR_PITR_ROT_ALIGN_CTRL_MIN_MAX       0x8B  ///< min and max (signed) pos error [um] in state TPDR_CTRL_STATUS_PITCH_TRANS_ROT_ALIGN_CTRL

#define VALUE_TAPEDRV_MVMM_CHANGED_CNT                  0x90  ///< number of movement mode changes by the tape drive because the position deviation is too large for the current trajectory profile
#define VALUE_TAPEDRV_SWING_REJECT_CNT                  0x91  ///< number of swing reject actions in the tape drive
#define VALUE_TAPEDRV_BACKLASH                          0x92  ///< total backlash value of tape drive
#define VALUE_TAPEDRV_PITCH_MOVE_TRANS_TIME             0x93  ///< transport time (start to targ corr true) in ctrlCyc of last pitch transport
#define VALUE_TAPEDRV_PITCH_MOVE_TARG_CORR_TIME         0x94  ///< targ corr time (first targ corr entry to targ corr true) in ctrl Cyc of last pitch transport
#define VALUE_TAPEDRV_PITCH_SPEED_IDX                   0x95  ///< current state of index to profile of tape drive
#define VALUE_TAPEDRV_POS_ERR_PITR_CURR                 0x96  ///< current pos error [um] (refreshed in all pitch stati except TPDR_CTRL_STATUS_PITCH_TRANS_IDLE_OK)
#define VALUE_TAPEDRV_POS_ERR_PITR_POSP_1_START_STOP    0x97  ///< pos error [um] at begin and end of state TPDR_CTRL_STATUS_PITCH_TRANS_POSPOW_1
#define VALUE_TAPEDRV_POS_ERR_PITR_POSP_1_MIN_MAX       0x98  ///< min and max (signed) pos error [um] in state TPDR_CTRL_STATUS_PITCH_TRANS_POSPOW_1
#define VALUE_TAPEDRV_POS_ERR_PITR_POSP_2_START_STOP    0x99  ///< pos error [um] at begin and end of state TPDR_CTRL_STATUS_PITCH_TRANS_POSPOW_2
#define VALUE_TAPEDRV_POS_ERR_PITR_POSP_2_MIN_MAX       0x9A  ///< min and max (signed) pos error [um] in state TPDR_CTRL_STATUS_PITCH_TRANS_POSPOW_2
#define VALUE_TAPEDRV_FEEDER_OFFSET                     0x9B  ///< alignment [µm] of the pickup positions construction based offset in Y direction (tape moving direction), e.g. fine tuning or application specific pickup window
#define VALUE_TAPEDRV_PUP_ALIGN_OFFSET                  0x9C  ///< alignment [µm] of the pickup positions in Y direction (tape moving direction) , e.g. for optimizing matrix head picks

// 0xA0 FOIL DRIVE ----------------------------------------------------------------------------------------------------------------------------------
#define VALUE_FOILDRV_FLAGS                             0xA0  ///< various flags indication actual states of the foil drive
#define VALUE_FOILDRV_CTRL_STATE                        0xA1  ///< current state of foil drive motion control state machine
#define VALUE_FOILDRV_MONITOR_STATE                     0xA2  ///< current state of foil drive monitor state machine
#define VALUE_FOILDRV_MOVEMENT_TYPE                     0xA3  ///< type of the previous tape drive movement
#define VALUE_FOILDRV_MOVEMENT_MODE                     0xA4  ///< mode of the previous tape drive movement
#define VALUE_FOILDRV_TIMEOUT                           0xA5  ///< timeout [ms] to stop the drive if no regular stop condition occurred before timeout has elapsed
#define VALUE_FOILDRV_MONITOR_FLAGS                     0xA6  ///< flags for foil drive monitor

// 0xC0 (values for sprocket wheel encoder) ---------------------------------------------------------------------------------------------------------
#define VALUE_ENCSPW_FLAGS                              0xC0  ///< status flags of encoder
#define VALUE_ENCSPW_ENCPOS                             0xC1  ///< absolut position of sprocket wheel
#define VALUE_ENCSPW_SPWPOS                             0xC2
#define VALUE_ENCSPW_GRIDPOSNR                          0xC3  ///< pitch grid number of encoder position
#define VALUE_ENCSPW_OFFSSPROCKET0                      0xC4  ///< encoder offset
#define VALUE_ENCSPW_SINMINMAX                          0xC5  ///< min./max. sine amplitude voltage
#define VALUE_ENCSPW_COSMINMAX                          0xC6  ///< min./max. cosine amplitude voltage
#define VALUE_ENCSPW_SINCOSOFFS                         0xC7  ///< sine/cosine offset voltage (mean of min./max.)
#define VALUE_ENCSPW_SINCOSPERIOD                       0xC8  ///< sine/cosine period counter
#define VALUE_ENCSPW_IDXPOS_FACT                        0xC9  ///< index position found @ first calibration
#define VALUE_ENCSPW_IDXPOS_PWMVAL                      0xCA  ///< index position + index PWM duty cycle (reflective photo interrupter control)
#define VALUE_ENCSPW_ERROR_CNTR                         0xCB  ///< 4 byte error counter packed to 1 long
#define VALUE_ENCSPW_SINCOSADCDIFF                      0xCC  ///< Debug: sin/cos voltage diff. between Power off/on
#define VALUE_ENCSPW_PERPOSCNTDIFF                      0xCD  ///< Debug: period pos./counter diff. between Power off/on
#define VALUE_ENCSPW_ERROR                              0xCE  ///< error of main encoder at sprocket wheel
#define VALUE_ENCSPW_REVOLCNT                           0xCF  ///< encoder revolution counter (used for 8mm pitch)

// 0xD0 ---------------------------------------------------------------------------------------------------------------------------------------------
#define VALUE_POSITION_ERROR                            0xD0  ///< offset of actual to target sprocket wheel position  // ??? double with VALUE_TAPEDRV_POS_ERR_PITR_CURR, could be deleted when assembly test jig has been considered and changed as well
#define VALUE_DATA_STATE                                0xD1  ///< union for displaying the validation state of stored data
#define VALUE_SETTING_STATE                             0xD2  ///< union for displaying feeder settings
#define VALUE_TEST_NUMBER                               0xD3  ///< currently activated test number
#define VALUE_TESTMODE_STATE                            0xD4  ///< current state of test mode state machine
#define VALUE_MISC_FLAGS                                0xD5  ///< current state of miscellaneous flags
//#define VALUE_ISRLOADCNT                                0xD7  ///< Zähler for Interruptlast-Messung
#define VALUE_SAMPLES_PER_SEC_MIN                       0xD7  ///< number of main loops/second minimum
//#define VALUE_ISRLOAD                                   0xD8  ///< Interruptlast
#define VALUE_POSFLAGDISTMS                             0xD9  ///< POS-Flag Distanz in µsteps LINKS und RECHTS zusammengefasst
#define VALUE_HARDWAREVERSION                           0xDA  ///< HW-Stand der Steuerplatine
#define VALUE_PLDVERSION                                0xDB  ///< Version der PLD-SW
#define VALUE_CTRLPANELVERSION                          0xDC  ///< HW-Stand des Bedienfeldes
#define VALUE_CANFLAGS                                  0xDD  ///< Zustands-Flags der CAN-Kommunikation
#define VALUE_SPLICE_FLAGS                              0xDE  ///< Zustands-Flags der Splice-Überwachung
#define VALUE_BUTTONFLAGS                               0xDF  ///< Zustands-Flags der Tasten im Bedienfeld

// 0xE0 ---------------------------------------------------------------------------------------------------------------------------------------------
#define VALUE_BUTTONACTION                              0xE0  ///< current state of actions triggered by ctrl panel keys (e.g. special display of pitch LEDs)
#define VALUE_EVENTLOG_ADDR_STATE                       0xE1  ///< address of next event and state of all eventlog pages
#define VALUE_ENCSPW_PERIODPOS                          0xE2  ///< periodic repetitive sprocket wheel encoder position
#define VALUE_ENCSPW_IDXERRPOSDIFF                      0xE3  ///< position diff. when index pos. error occurs
//#define VALUE_                                          0xE4  ///<
//#define VALUE_                                          0xE5  ///<
#define VALUE_SPLICE_STATE                              0xE6  ///< current state of the splice detection state machine
#define VALUE_SPLICE_TARGET_POS                         0xE7  ///< target position for observation when splice reaches the pickup position
#define VALUE_SPLICE_DETECTED_CNT                       0xE8  ///< number of detected splices since last power ON
//#define VALUE_                                          0xE9  ///<
#define VALUE_POWER_5V                                  0xEA  ///< 5V power supply voltage level
//#define VALUE_                                          0xEB  ///<
//#define VALUE_                                          0xEC  ///<
#define VALUE_FOILROCKER_STATE                          0xED  ///< current state (position) of the foil rocker
//#define VALUE_                                          0xEE  ///<
#define VALUE_BUTTONSTATE                               0xEF  ///< current state of the control panel keys and the removal handle (pressed/released)

// 0xF0 ---------------------------------------------------------------------------------------------------------------------------------------------
//#define VALUE_CONSTCRC16                                0xF0  ///< Checksumme for den Bereich im Datenflash, der für Konstanten reserviert wurde
#define VALUE_BOOTCRC16                                 0xF1  ///< checksum of bootloader software
#define VALUE_FLASHEVENTS                               0xF2  ///< Zustands-Flags for Ereignisse bei Flash-Zugriffen
#define VALUE_SAMPLESPERSEC                             0xF3  ///< number of main loops/second
#define VALUE_CANERRCAPTURE                             0xF4  ///< current capture of CAN_ESR1 register
#define VALUE_CANERRCAPTURE_PREV                        0xF5  ///< last captured state of CAN_ESR1 register from previous power ON phase shifted right by 3 to get SYNCH flag into a 16 bit vaiable
#define VALUE_CAN_RX_TX_ERRCNT                          0xF6  ///< CAN_ECR register with Rx and Tx error counters
#define VALUE_ADC_B4                                    0xF7  ///< ADC-B4-Result (splice sensor)
#define VALUE_ADC_A1                                    0xF8  ///< ADC-A1-Result (tape drive encoder zero index)
#define VALUE_ADC_A0                                    0xF9  ///< ADC-A0-Result (EDIF power supply voltage level)
#define VALUE_ADC_B0                                    0xFA  ///< ADC-B0-Result (HW version raw value)
#define VALUE_ADC_B5                                    0xFB  ///< ADC-B5-Result (control panel version)
#define VALUE_ADC_A3                                    0xFC  ///< ADC-A3-Result (tape drive encoder sinus signal)
#define VALUE_ADC_B7                                    0xFD  ///< ADC-B7-Result (tape drive encoder cosinus signal)
#define VALUE_CPU_TEMPERATURE                           0xFE  ///< cpu temperature [1/10°C]
#define VALUE_APPCRC16                                  0xFF  ///< checksum of application software


/* ************************************************************************************************
   4  TYPEDEFS
   ************************************************************************************************
*/


/* ************************************************************************************************
   5  VARIABLES
   ************************************************************************************************
*/


/* ************************************************************************************************
   6  MAKROS
   ************************************************************************************************
*/


/* ************************************************************************************************
   7  FUNCTION PROTOTYPES
   ************************************************************************************************
*/


#endif

// --------------------- End of file Ptkl_f.h -----------------------------------------------------
