
'------------------------------------------------------------------
Function Command_GetFW(ByVal AppBios, ByRef MajorValue, ByRef MinValue)
  Dim CanSendArg,CanReadArg,CANConfig
  Dim CanManager, Result

  Set CanSendArg = CreateObject("ICAN.CanSendArg")
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  
  If Memory.Exists("CanConfig") Then
    Memory.Get "CanConfig",CanConfig
  End If
  
  With CanSendArg
    .CanId = CanConfig.CANIDcmd
    If CANConfig.Config = 0 Then
    'Standalone
    .Data(0) = $(CMD_DOWNLOAD_VERSION)
    .Data(1) = AppBios
    .length = 2
    Else
    'XFCU
    .Data(0) = $(CMD_DOWNLOAD_VERSION) + &h10
    .Data(1) = AppBios
    .Data(2) = SLOT_NO
    .length = 3
    End If
  End With
  If Memory.Exists("CanManager") AND CanConfig.CANIDvalid = 1 Then    
    Memory.Get "CanManager",CanManager        
    Result = CanManager.SendCmd(CanSendArg,250,SC_CHECK_ERROR_BYTE,CanReadArg)
    'DebugMessage "Result" & Result
    
    DebugMessage "SendCmd: (TX:" & CanSendArg.Format & ") (RX :" & CanReadArg.Format & ")"
    If Result = SCA_NO_ERROR Then
      Command_GetFW = 1
      If CANConfig.Config = 0 Then
        MajorValue = CanReadArg.Data(3)
        MinValue   = CanReadArg.Data(4)
      Else
        MajorValue = CanReadArg.Data(4)
        MinValue   = CanReadArg.Data(5)      
      End If
      LogAdd ("Read Firmware")
    Else
      Command_GetFW = 0
      LogAdd ("Read Firmware Timeout")
    End If
  Else
    LogAdd ("No CAN Manager")
  End If
End Function
'------------------------------------------------------------------

' Prepare Commands
'------------------------------------------------------------------
Function Command_Prepare_RefRun
  If CANSendPrepareCMD($(CMD_PREPARE_REF_RUN),1,SLOT_NO,1,0,50000) = True Then
    LogAdd "Reference Run command started"
  Else
    LogAdd "Reference Run Error!"
  End If
End Function

'------------------------------------------------------------------
Function Command_Prepare_ClearErr ()
  If CANSendPrepareCMD($(CMD_CONFIRM),1,SLOT_NO,1,0,1000) = True Then
    LogAdd "Clear Error command started"
  Else
    LogAdd "Clear Error Error!"
  End If
End Function

'------------------------------------------------------------------
Function Command_Prepare_QuitRefillPos ()

  If CANSendPrepareCMD($(CMD_PREPARE_QUIT_REFILL_POSITION),1,SLOT_NO,1,0,5000) = True Then
    LogAdd "Quit Refill command started"
  Else
    LogAdd "Quit Refill Error!"
  End If

End Function
'------------------------------------------------------------------
Function Command_Prepare_RefillStart ( Cassette, ZAcceleration )
  Memory.CANData(0) = Cassette
  Memory.CANData(1) = ZAcceleration
 
  If CANSendPrepareCMD($(CMD_PREPARE_TRAY_REPLANISH),1,SLOT_NO,1,2,5000) = True Then
    LogAdd "Refill command started"
  Else
    LogAdd "Refill Error"
  End If
End Function
'------------------------------------------------------------------
Function Command_Prepare_Unload ()
  If CANSendPrepareCMD($(CMD_PREPARE_TRAY_UNLOAD),1,SLOT_NO,1,0,5000) = True Then
    LogAdd "Tray unload command started"
    Command_Prepare_Unload = True
  Else
    LogAdd "Tray unload Error!"
    Command_Prepare_Unload = False
  End If  
End Function
'------------------------------------------------------------------
Function Command_Prepare_Tray ( Tray,Xacc,Zacc )
  Dim CanSendArg,CanReadArg,CANConfig
  Dim Validation
  Set CanSendArg = CreateObject("ICAN.CanSendArg")
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  
  Validation = ValidateAcc(Xacc)
  Validation = ValidateAcc(Zacc)
  
  If Validation = 0 Then
   
    Memory.CANData(0) = Tray
    Memory.CANData(1) = Xacc
    Memory.CANData(2) = Zacc
    If CANSendPrepareCMD($(CMD_PREPARE_TRAY),1,SLOT_NO,1,3,10000) = True Then
      Command_Prepare_Tray = True
      'display message only if no endurance run in progress.
      If Memory.Endurance_InProgress = 0 Then
        LogAdd "Prepare Tray command started."      
      End If
    Else
      LogAdd "Prepare Tray Error!" 
      Command_Prepare_Tray = False
    End If
  End If

End Function

'------------------------------------------------------------------

Function Command_PrepareTransport ( )
    If CANSendPrepareCMD($(CMD_PREPARE_TRANSPORT),1,SLOT_NO,1,0,10000) = True Then
      Command_PrepareTransport = True
    Else
      LogAdd "Prepare Transport Error!"  
      Command_PrepareTransport = False
    End If
End Function 

'------------------------------------------------------------------
' MC Get/Send Commands
'------------------------------------------------------------------
Function Command_GetNumOfSlots( )
  If CANSendGetMC($(CMD_GET_DATA),$(MC_NUMBER_OF_SLOTS),SLOT_NO,1,0) = True Then
    LogAdd "Get Number of Slot command sent"
  Else
    LogAdd "Get Number of Slot command Error!"
  End If
End Function
'------------------------------------------------------------------
Function Command_GetCassette()

  If CANSendGetMC($(CMD_GET_DATA),$(MC_JTF3_CASSETTE_TYPE),SLOT_NO,1,0) = True Then
    Command_GetCassette = True
    LogAdd "Get Cassette Ok"
  Else
    Command_GetCassette = False
    LogAdd "Get Cassette NOK"
  End If
  
End Function
'------------------------------------------------------------------
Function Command_GetRFID ( Data )

  Memory.CANData(0) = Data

  If CANSendGetMC($(CMD_GET_DATA),$(MC_JTF3_RFID_DATA),SLOT_NO,1,1) = True Then
    LogAdd  "Get RFID "
    Command_GetRFID = True    
  Else
    LogAdd  "Get RFID Error!"
    Command_GetRFID = False
  End If

End Function
'------------------------------------------------------------------
Function Command_Debug_DoorFunction ( Lock )

  Memory.CANData(0) = $(JTF_DBG_DOOR)
  Memory.CANData(1) = Lock
  
  If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,2) = True Then
    LogAdd "Door Command Sent"       
  Else
    LogAdd "Door Command Error"        
  End If
  
End Function
'------------------------------------------------------------------
Function Command_Debug_AxisBrake ( Axis,OnOff )

  Memory.CANData(0) = $(JTF_DBG_BRAKE)    
  Memory.CANData(1) = Axis    
  Memory.CANData(2) = OnOff          

  If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,3) = True Then
    If OnOff = 1 Then
      LogAdd "Brake Engaged Command Sent"
    Else
      LogAdd "Brake Released Command Sent"
    End If
  Else
    LogAdd " Brake Command Error!"
  End If
    
End Function
'------------------------------------------------------------------

Function Command_Debug_AxisRefRun ( Axis )

  Memory.CANData(0) = $(JTF_DBG_AXIS_REFRUN) 
  Memory.CANData(1) = Axis

  If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,2) = True Then
    LogAdd "Reference Run Command Sent"
  Else
    LogAdd "Reference Run Command Error!"
  End If

End Function

'------------------------------------------------------------------
Function Command_Debug_MoveLevel ( level,name )

  Memory.CANData(0) = $(JTF_DBG_LEVEL)
  Memory.CANData(1) = AXIS_Elvt
  Memory.CANData(2) = level
  
   If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,3) = True Then
    LogAdd "Move to Level Command Sent: "& name & String.Format(" (0x%02X)",level)
   Else
    LogAdd "Move to level command Error!"
  End If
End Function
'------------------------------------------------------------------
Function Command_Debug_MoveAxis ( Axis,level,name )

  Memory.CANData(0) = $(JTF_DBG_LEVEL)
  Memory.CANData(1) = Axis
  Memory.CANData(2) = level
  
   If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,3) = True Then
    LogAdd "Move Axis Command Sent: "& name & String.Format(" (0x%02X)",level)
   Else
    LogAdd "Move Axis command Error!"
  End If
End Function
'------------------------------------------------------------------
Function Command_Debug_MoveOffset ( Value )
  
  Memory.CANData(0) = $(JTF_DBG_MVOFFSET)
  Memory.CANData(1) = Lang.GetByte(Value,0)
  Memory.CANData(2) = Lang.GetByte(Value,1)

  If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,3) = True Then
    LogAdd " Move Offset Command Sent :" & Value 
  Else
    LogAdd " Move Offset Command Error!"
  End If

End Function
'------------------------------------------------------------------
Function Command_Debug_SaveOffset ( Position )
  
  Memory.CANData(0) = $(JTF_DBG_SAVEOFFSET)
  Memory.CANData(1) = Position

  If CANSendTACMD($(CMD_SEND_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,2) = True Then
    LogAdd " Save Offset Command Sent"
  Else
    LogAdd " Save Offset Command Error!"
  End If

End Function

'------------------------------------------------------------------
Function Command_GetData_GetRefRun ( Axis )

  Memory.CANData(0) = Axis   

  If CANSendGetMC($(CMD_GET_DATA),$(MC_JTF3_REFERENCE_STATE),SLOT_NO,1,1) = True Then
    'LogAdd  "Get Reference Run Status Command Sent"
    Command_GetData_GetRefRun = 1
  Else
    'LogAdd  "Get Reference Run Status Command Error!"
    Command_GetData_GetRefRun = 0
  End If

End Function

'------------------------------------------------------------------
' Feeder Get/Send Commands
'------------------------------------------------------------------
' Note that this function uses the CANRead argument passed into it.
Function Command_GetIO ( )

  If CANSendGetFeed($(FEED_GET_DATA),$(PARAM_SENSOR_STATE),SLOT_NO,0) = True Then
    Command_GetIO = True     
  Else
    Command_GetIO = False
  End If
  
End Function

'------------------------------------------------------------------
Function Command_GetEncPosCnt ( Axis,Pos ) 
  
  Memory.CANData(0) = pos
  
  If CANSendGetFeed($(FEED_GET_DATA),Axis,SLOT_NO,1) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If
  
End Function

'------------------------------------------------------------------
Function Command_SetEncPosCnt ( Axis,Pos,Value)

  Memory.CANData(0) = Pos    
  Memory.CANData(1) = Lang.GetByte(Value,0)     
  Memory.CANData(2) = Lang.GetByte(Value,1)   
  Memory.CANData(3) = Lang.GetByte(Value,2)   
  Memory.CANData(4) = Lang.GetByte(Value,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),Axis,SLOT_NO,5) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If
  
End Function

'------------------------------------------------------------------

Function Command_SetFlsSavIncompleteCnt ( Value )

  Memory.CANData(0) = Lang.GetByte(Value,0)     
  Memory.CANData(1) = Lang.GetByte(Value,1)
  
  If CANSendGetFeed($(FEED_SEND_DATA),$(PARAM_RTDAT_FLA_SAVE_INCOMPL_CNT),SLOT_NO,2) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If
  
End Function
'------------------------------------------------------------------

Function Command_SetFlsCRCCnt ( Value )

  Memory.CANData(0) = Lang.GetByte(Value,0)     
  Memory.CANData(1) = Lang.GetByte(Value,1)   
  Memory.CANData(2) = Lang.GetByte(Value,2)   
  Memory.CANData(3) = Lang.GetByte(Value,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),$(PARAM_RTDAT_FLA_PAGE_ERR_CNT),SLOT_NO,4) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If
  
End Function

'------------------------------------------------------------------

Function Command_SetEraseFlashPage ( Page )

  Memory.CANData(0) = Page
  Memory.CANData(1) = &hAA
  Memory.CANData(2) = &h55
  
  If CANSendGetFeed($(FEED_SEND_DATA),$(TST_ERASE_FLASHPAGE),SLOT_NO,3) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If
  
End Function
'------------------------------------------------------------------

Function Command_SetOffset( Pos,Axis,CurrEncValue )

  Memory.CANData(0) = Pos    
  Memory.CANData(1) = Lang.GetByte(CurrEncValue,0)     
  Memory.CANData(2) = Lang.GetByte(CurrEncValue,1)   
  Memory.CANData(3) = Lang.GetByte(CurrEncValue,2)   
  Memory.CANData(4) = Lang.GetByte(CurrEncValue,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),Axis,SLOT_NO,5) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If

End Function

'------------------------------------------------------------------
Function Command_SetIndexOffset( CurrEncValue )

  Memory.CANData(0) = Lang.GetByte(CurrEncValue,0)     
  Memory.CANData(1) = Lang.GetByte(CurrEncValue,1)   
  Memory.CANData(2) = Lang.GetByte(CurrEncValue,2)   
  Memory.CANData(3) = Lang.GetByte(CurrEncValue,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),$(PARAM_LVLPOS_INDEX),SLOT_NO,4) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If

End Function
'------------------------------------------------------------------
Function Command_SetDoorOffset( CurrEncValue )

  Memory.CANData(0) = Lang.GetByte(CurrEncValue,0)     
  Memory.CANData(1) = Lang.GetByte(CurrEncValue,1)   
  Memory.CANData(2) = Lang.GetByte(CurrEncValue,2)   
  Memory.CANData(3) = Lang.GetByte(CurrEncValue,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),$(PARAM_LVLPOS_DOOR),SLOT_NO,4) = True Then
    LogAdd "Command OK!"
  Else
    LogAdd "Command Error!"
  End If

End Function
'------------------------------------------------------------------
Function Command_GetCnvyTrayInfo(  )
  Dim CANData
  Memory.Get "CANData",CANData
  If CANSendGetFeed($(FEED_GET_DATA),$(PARAM_TRAYINFO_CNVY),SLOT_NO,0) = True Then
    Visual.Select("inputTrayConveyor").Value = String.Format("0x%08X", Lang.MakeLong4(CANData.Data(2),CANData.Data(3),CANData.Data(4),CANData.Data(5)))
  Else
    LogAdd "Read Tray Info Error!"
  End If
End Function

'------------------------------------------------------------------
Function Command_GetEncoderValue( ByVal Encoder )
  Command_GetEncoderValue = CANSendGetFeed($(FEED_GET_DATA),Encoder,SLOT_NO,0)
End Function

'------------------------------------------------------------------

Function Command_SetEncoder (Axis, Pos, Val)
  
  Memory.CANData(0) = Pos    
  Memory.CANData(1) = Lang.GetByte(Val,0)     
  Memory.CANData(2) = Lang.GetByte(Val,1)   
  Memory.CANData(3) = Lang.GetByte(Val,2)   
  Memory.CANData(4) = Lang.GetByte(Val,3)   
  
  If CANSendGetFeed($(FEED_SEND_DATA),Axis,SLOT_NO,5) = True Then
    Memory.SignalArray.Data(pos_sel) =  Val        
  Else
    LogAdd "Read Encoder Error!"
  End If

End Function 
'------------------------------------------------------------------


