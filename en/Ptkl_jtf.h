 /*
  
    FileName: Ptkl_jtf.h
    Version: 1
    Description: Initial release
    Author: GZ Chan
    Date: 2016-12-30
    
 */

//Tesla specific params
#define PARAM_SENSOR_STATE         0x61
#define PARAM_LED_STATUS           0x62
#define PARAM_OPRA_STATUS          0x63
#define PARAM_ENCCNT_ELVT          0x64
#define PARAM_ENCCNT_PSHR          0x65
#define PARAM_ENCCNT_CLPR          0x66
#define PARAM_ENCCNT_KIKR          0x67
#define PARAM_ENCCNT_CNVY          0x68

#define PARAM_LVLPOS_INDEX         0x70
#define PARAM_LVLPOS_DOOR          0x71
#define PARAM_LVLPOS_ELVT          0x73
#define PARAM_LVLPOS_KIKR          0x74
#define PARAM_LVLPOS_PSHR          0x75
#define PARAM_LVLPOS_CNVY          0x76
#define PARAM_LVLPOS_CLPR          0x78

#define PARAM_OFFSET_TRAYOUT       0x90
#define PARAM_OFFSET_TRAYIN        0x91
#define PARAM_TRAYINFO_CNVY        0x92

//Param for new EEPROM structure read/writes
#define FACTDATA_MFG_YEAR          0xA3
#define FACTDATA_MFG_MONTH         0xA4
#define FACTDATA_MFG_DAY           0xA5
#define FACTDATA_MFG               0xA6
#define FACTDATA_SERIALNUMBER1     0xA7
#define FACTDATA_SERIALNUMBER2     0xA8
#define FACTDATA_MATERIAL1         0xA9
#define FACTDATA_MATERIAL2         0xAA
#define FACTDATA_FUNCTIONLEVEL     0xAB
#define FACTDATA_REVISIONLEVEL     0xAC

//Param for DEBUG_Functions that requires read and write.
#define JTF_DBG_DOOR               0xB1
#define JTF_DBG_BRAKE              0xB2
#define JTF_DBG_LEVEL              0xB3
#define JTF_DBG_MVOFFSET           0xB4
#define JTF_DBG_AXIS_ENABLE        0xB5
#define JTF_DBG_AXIS_REFRUN        0xB6
#define JTF_DBG_ENDURANCE          0xB7
#define JTF_DBG_SAVEOFFSET         0xB8

//These are merged into ptkl_be.h
//Public Errors
#define PB_ERROR_JTF3_AXIS_ERROR   0x55
#define PB_ERROR_JTF3_DOOR         0x54
#define PB_ERROR_JTF3_BUSY         0x56
#define PB_ERROR_JTF3_RFID         0x57

#define CMD_PREPARE_REF_RUN                 0x5C
#define CMD_PREPARE_TRAY                    0x60
#define CMD_PREPARE_QUIT_REFILL_POSITION    0x5D
#define CMD_PREPARE_TRANSPORT               0x67


#define MC_JTF3_CASSETTE_TYPE     0xD2
#define MC_JTF3_RFID_DATA	        0xD3
#define MC_JTF3_REFERENCE_STATE   0xD5
