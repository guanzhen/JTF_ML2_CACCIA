Dim CANID,CANIDRX1,CANIDRX2,CANIDDBG
Dim CANRXMsg
Dim exit_condition
Dim Pos_KikrOut,Pos_Pshrpickup,Pos_pshrtrayin,Pos_pshrtraytouch,Pos_clprstandby,pos_clprclamp
Dim CAN2,CAN2DBG,CAN2RX1,CAN2RX2
Dim Enccnt_Kikr,Enccnt_Clpr,Enccnt_Pshr,Enccnt_Elvt,Enccnt_Cnvy
Dim State
Dim FeederID
FeederID = "79ASMDE00001"
CANID     = "0x6e8"
CANIDDBG  = "0x6eA"
CANIDRX1  = "0x4e8"
CANIDRX2  = "0x0e8"
State = 0

CAN2     = "0x500"
CAN2DBG  = "0x503"
CAN2RX1  = "0x501"
CAN2RX2  = "0x000"

exit_condition = False
Pos_KikrOut       = 0x0000783f
Pos_Pshrpickup    = 0x00000e71
Pos_pshrtrayin    = 0xffffd6ed
Pos_pshrtraytouch = 0xfffff6d5
Pos_clprstandby   = 0xFFFFF800
pos_clprclamp     = 0xFFFFE000

Enccnt_Kikr = 0x00000011
Enccnt_Clpr = 0x00000022
Enccnt_Pshr = 0x00000033
Enccnt_Elvt = 0x00000044
Enccnt_Cnvy = 0x00000055

{
  CANRXMsg = WaitMsg{"0x6E8,0x6EA,0x500,0x502,0x503"}(250)

  If CANRXMsg.Success && ( CANRXMsg.CanId == 0x6E8 ||  CANRXMsg.CanId == 0x6EA )
  {
    Switch (CANRXMsg.Data[0])
    {
      '-------------------------------------------------------------------
      'Standalone
      Case 0x05:
      {
        If (CANRXMsg.Data[1] == 0x00)
          SendMsg{CANIDRX1}( 0x05,0x00,CANRXMsg.Data[2],0x00,0x01,0x33,0x44)
        Else If (CANRXMsg.Data[1] == 0x10)
          SendMsg{CANIDRX1}( 0x05,0x00,CANRXMsg.Data[2],0x00,0x03,0x33,0x44)
      }
      Case 0x52:
      {
        SendMsg{CANIDRX1}( CANRXMsg.Data[0],0x00,0x01)
        delay 200
        SendMsg{CANIDRX2}( 0x90,0x00,0x01)
        delay 2000
        SendMsg{CANIDRX2}( 0x00,0x00,0x01)
      }
      Case 0x54:
      {
        SendMsg{CANIDRX1}( CANRXMsg.Data[0],0x00,0x01)
        delay 200
        SendMsg{CANIDRX2}( 0x90,0x00,0x01)
        delay 2000
        SendMsg{CANIDRX2}( 0x00,0x00,0x01)
      }
      Case 0x60:
      {
        SendMsg{CANIDRX1}( CANRXMsg.Data[0],0x4c,0x01,0x00,0x00)
        delay 200
        'SendMsg{CANIDRX2}( 0x90,0x00,0x01)
        'delay 2000
        'SendMsg{CANIDRX2}( 0x40,0xC8,0x01)
        'delay 100        
        'SendMsg{CANIDRX2}( 0x00,0x00,0x01)
      }
      Case 0xFF:
      {
        exit_condition = true
      }
      Case 0x6A:
      {
        Switch (CANRXMsg.Data[1])
        {
          Case 0xD2:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x07,0x07)}

          Case 0xD5:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0xFF)
          }
          Case 0xA3:
          {
            Switch (CANRXMsg.Data[2])
            {            
              Case 0: 
              {
                State = 1
                SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00)
              }
              Case 1:
              {
                 Switch (State)
                 {
                 Case 0 :
                 {
                    SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x04)
                 }
                 Case 1 :
                 {
                    SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,FeederID[0],FeederID[1],FeederID[2],FeederID[3],FeederID[4])
                    State = State + 1
                 }
                 Case 2 :
                 {
                    SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,FeederID[5],FeederID[6],FeederID[7],FeederID[8],FeederID[9])
                    State = State + 1
                 }
                 Case 3 :
                 {
                    SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,FeederID[10],FeederID[11])
                    State = State + 1
                 }
                 Else 
                 {
                    SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x10)
                 }
                 }
              }
              Case 2:
              {
                  SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00)
                  State = 0
              }
            }
          }
          
          Else
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x00)
          }
        }      
      }
      'ParamGet
      Case 0x81:
      {
        Switch (CANRXMsg.Data[1])
        {
          Case 0x54:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x32,0x41)
          }
          Case 0x57:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x30,0x31,0x32,0x33)
          }
          Case 0x58:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x35,0x36,0x37,0x38)
          }
          Case 0x59:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x2D,0x01)
          }
          Case 0x61:
          {
           SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)
          }
          
          'Get Encoder counts
          Case 0x64:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Enccnt_Elvt[0],Enccnt_Elvt[1],Enccnt_Elvt[2],Enccnt_Elvt[3])
          }
          Case 0x65:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Enccnt_Pshr[0],Enccnt_Pshr[1],Enccnt_Pshr[2],Enccnt_Pshr[3])
          }
          Case 0x66:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Enccnt_Clpr[0],Enccnt_Clpr[1],Enccnt_Clpr[2],Enccnt_Clpr[3])
          }
          Case 0x67:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Enccnt_Kikr[0],Enccnt_Kikr[1],Enccnt_Kikr[2],Enccnt_Kikr[3])
          }          
          Case 0x68:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Enccnt_Cnvy[0],Enccnt_Cnvy[1],Enccnt_Cnvy[2],Enccnt_Cnvy[3])
          }
          
          Case 0x77:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
              Case 0x10:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x0F,0xAA,0xBB,0x10)}
              Case 0x11:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x00)}
              Case 0x20:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x0F,0xAA,0xBB,0x20)}
              Case 0x21:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x00)}
              Case 0x30:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x0F,0xAA,0xBB,0x30)}
              Case 0x31:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x01)}
              Case 0x40:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x0F,0xAA,0xBB,0x40)}
              Case 0x41:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x01)}
              Case 0x50:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x0F,0xAA,0xBB,0x50)}
              Case 0x51:{SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x01)}
            }
          }
          'Elevator
          Case 0x73:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
              Case 0x02: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
              Case 0x03: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
            }
          }
          'Kicker
          Case 0x74:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Pos_KikrOut[0],Pos_KikrOut[1],Pos_KikrOut[2],Pos_KikrOut[3])}
            }
          }
          Case 0x75:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Pos_Pshrpickup[0],Pos_Pshrpickup[1],Pos_Pshrpickup[2],Pos_Pshrpickup[3])}
              Case 0x02: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Pos_pshrtrayin[0],Pos_pshrtrayin[1],Pos_pshrtrayin[2],Pos_pshrtrayin[3])}
              Case 0x03: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Pos_pshrtraytouch[0],Pos_pshrtraytouch[1],Pos_pshrtraytouch[2],Pos_pshrtraytouch[3])}
            }
          }
          Case 0x76:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,Pos_clprstandby[0],Pos_clprstandby[1],Pos_clprstandby[2],Pos_clprstandby[3])}
              Case 0x02: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,pos_clprclamp[0],pos_clprclamp[1],pos_clprclamp[2],pos_clprclamp[3])}
            }
          }
          Case 0x78:
          {
            Switch (CANRXMsg.Data[2])
            {
              Case 0x01: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
              Case 0x02: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
              Case 0x03: {SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x48,0x07)}
            }
          }
          Case 0x92:
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0xFF)
          }
          Else
          {
            SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x00)
          }
        }
        
      }
     Else
     {
        SendMsg{CANIDRX1}(CANRXMsg.Data[0],0x00,0x00)
     }
    }
  }
  '-------------------------------------------------------------------
  'XFCU
  '-------------------------------------------------------------------
  Else If CANRXMsg.Success && ( CANRXMsg.CanId == 0x500)
  {
   Switch (CANRXMsg.Data[0])
    {
      Case 0x15:
      {
        If (CANRXMsg.Data[1] == 0x00)
          SendMsg{CAN2RX1}( 0x15,0x00,CANRXMsg.Data[2],CANRXMsg.Data[1],0x00,0x02,0x33,0x44)
        Else If (CANRXMsg.Data[1] == 0x10)
          SendMsg{CAN2RX1}( 0x15,0x00,CANRXMsg.Data[2],CANRXMsg.Data[1],0x01,0x02,0x03,0x04)      
      }      
      Case 0x91:
      {
        Switch (CANRXMsg.Data[1])        
        {
          Case 0x61:
          {
            SendMsg{CAN2RX1}(0x91,0x00,CANRXMsg.Data[2],0x48,0x07)
          }
        }
      }      
      Case 0x7A:
      {
        Switch (CANRXMsg.Data[1])
        {
          Case 0xD2:
          {
            SendMsg{CAN2RX1}(0x7A,0x00,CANRXMsg.Data[2],0x07,0x07)
          }
       }
      }      
      Case 0x60:
      {
        SendMsg{CAN2RX1}( 0x60,0x00,0xEC,0x1D,0x01,0x00,0x00)
        delay 2000
        SendMsg{CAN2DBG}( 0xC4,0x00,0xEC,0x1D,0x01)
        delay 200
        SendMsg{CAN2DBG}( 0x40,0x00,0xEC,0x1D,0x01)
      }
    
    }
  
  }
  
  delay 50

}
Until exit_condition == True
