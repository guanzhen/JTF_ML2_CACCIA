
Const TRANSPORTLEVEL = &h3F
'------------------------------------------------------------------
'Window Init commands
'------------------------------------------------------------------
Function Init_Window_Command ()
  Dim counter,value
  value = 41
  
  For counter = 1 To 18
    Visual.Select("optMoveLevel").addItem counter,value    
    Visual.Select("optSelectTray").addItem counter,counter
    value = value + 1
  Next
  
  Visual.Select("optMoveLevel").addItem "Refill Top", 6
  Visual.Select("optMoveLevel").addItem "Refill Bottom", 5
  Visual.Select("optMoveLevel").addItem "RFID Read Top", 3
  Visual.Select("optMoveLevel").addItem "RFID Read Bottom", 4
  Visual.Select("optMoveLevel").addItem "Mid Index", 2
  Visual.Select("input_xacc").Value = "255"
  Visual.Select("input_zacc").Value = "255"
  
  Visual.Select("input_xacc").SetValidation VALIDATE_INPUT_MASK_UI1,"OrangeRed",10
  Visual.Select("input_zacc").SetValidation VALIDATE_INPUT_MASK_UI1,"OrangeRed",10
  'Visual.Select("inputCANID").SetValidation VALIDATE_INPUT_MASK_UI2,"OrangeRed",16
End Function

'------------------------------------------------------------------
' Button Click Functions
'------------------------------------------------------------------

Function OnClick_btnRefRun ( Reason )
  LogAdd "Reference run in progress... Please wait!"
  Command_Prepare_RefRun
  'Update reference status
  'System.Delay(200)
  'GetRefRun REF_ALL
  'GetRefRun REF_ELVT
  'GetRefRun REF_PSHR
  'GetRefRun REF_CLPR
  'GetRefRun REF_KIKR
  'GetRefRun REF_CNVY
  'Command_GetCnvyTrayInfo
End Function

'------------------------------------------------------------------
Function OnClick_btnCmdReturnTray (Reason )
  Command_Prepare_Unload
End Function

'------------------------------------------------------------------

Function OnClick_btnCmdPrepareTray ( Reason )
  LogAdd "Prepare Tray: "&Visual.Select("optSelectTray").SelectedItemAttribute("Value")
  Command_Prepare_Tray String.SafeParse(Visual.Select("optSelectTray").SelectedItemAttribute("Value"),"0x00"),String.SafeParse(Visual.Select("input_xacc").Value),String.SafeParse(Visual.Select("input_zacc").Value)

End Function

'------------------------------------------------------------------

 Function OnClick_btnRefillTop( Reason )
  Dim Cassette
  Cassette = 2
  LogAdd "Refill Cassette : Top"
  Command_Prepare_RefillStart Cassette, &hFF
  GetCassetteInfo  
 End Function
 
 '------------------------------------------------------------------
 
 Function OnClick_btnRefillBottom( Reason )
  Dim Cassette
  Cassette = 1
  LogAdd "Refill Cassette : Bottom"
  Command_Prepare_RefillStart Cassette, &hFF
  GetCassetteInfo  
 End Function
 
'------------------------------------------------------------------

Function OnClick_btnRefillStop ( Reason )
  Command_Prepare_QuitRefillPos
  System.Delay(1000)
  GetCassetteInfo
End Function

'------------------------------------------------------------------

Function OnClick_btnMoveLevel( Reason )
 
  Command_Debug_MoveLevel Visual.Select("optMoveLevel").SelectedItemAttribute("Value"),Visual.Select("optMoveLevel").SelectedItemName

End Function

'------------------------------------------------------------------
Function OnClick_btnReset ( Reason )
  Dim CanSendArg,CanReadArg,CANConfig
  Dim Reply
  Dim encodersel
  Set CanSendArg = CreateObject("ICAN.CanSendArg")
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  Reply = 1
  
  If Memory.CANConfig.Config = 1 Then
    Reply = MsgBox("This will reset the FCU! Do you wish to continue?", 1 , "Confirm Reset")
  End If
  
  If Reply = 1 AND Memory.Exists( "CanManager" ) Then
    Memory.Get "CANConfig",CANConfig
    CanSendArg.CanId = CANConfig.CANIDcmd
    CanSendArg.Data(0) = &h06
    CanSendArg.Length = 1
    Memory.CanManager.Send CanSendArg
    LogAdd "Resetting Tesla!" 
  End if
End Function

'------------------------------------------------------------------

Function OnClick_btnGetApp ( Reason )
  Dim Result, FeederID
  Result = GetFirmwareInfo
  If Result = True Then
    Result = GetCassetteInfo
  End If
  
  If Result = True Then
    GetFeederID(FeederID)
  Else
    FeederID = "????????????"
  End If  
  
  ValidateFeederID FeederID
End Function

'------------------------------------------------------------------

Function OnClick_btnAssignCANID( Reason )
  Dim CanReadArg,CanID
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  
  CanID = CLng("&h" & Visual.Select("inputCANID").Value)
  'InitCAN CanID
  LogAdd "Assign CANID"
  CANID_Assign CanID
  System.Delay(100)
  If Command_GetNumOfSlots = True Then
    GetFirmwareInfo
    GetCassetteInfo
  End If
End Function
'------------------------------------------------------------------

Function OnBlur_inputCANID ( Reason )
  Dim CANID   
  CANID = CLng("&h" & Visual.Select("inputCANID").Value)
  If CANID_Validate (CANID) = True Then  
    DebugMessage "Changed CAN ID:" & String.Format("%3X",CANID)
    CANID_Set CANID
    Memory.CANConfig.CANIDvalid = 1
  Else
    Memory.CANConfig.CANIDvalid = 0
  End If
  
End Function

'------------------------------------------------------------------

Function OnClick_btnPositive ( Reason )
  Dim SignedVal
  SignedVal = -Visual.Select("SelPosControlStep").SelectedItemAttribute("Value")
  LogAdd "Move Up :" & SignedVal
  DebugMessage "Move Up " & String.Format ("%02x %02x",Lang.GetByte(SignedVal,0),Lang.GetByte(SignedVal,1))
  
  Command_Debug_MoveOffset SignedVal
End Function 

'------------------------------------------------------------------

Function OnClick_btnNegative( Reason )
  Dim SignedVal
  
  SignedVal =  Visual.Select("SelPosControlStep").SelectedItemAttribute("Value")
  SignedVal = Math.Cast2Short (SignedVal)
  LogAdd "Move Down :" & SignedVal
  DebugMessage "Move Down " & String.Format ("%02x %02x",Lang.GetByte(SignedVal,0),Lang.GetByte(SignedVal,1))
  Command_Debug_MoveOffset SignedVal  
  
End Function 

'------------------------------------------------------------------
Function OnClick_btnMoveTransport ( Reason )
  LogAdd "Move to Transport Position"
  Command_Prepare_Transport
End Function 

'------------------------------------------------------------------

Function OnClick_btnDoorOpen ( Reason )
  LogAdd "Door Open"
  Command_Debug_DoorFunction 0
  System.Delay(100)
  ReadIO
End Function

'------------------------------------------------------------------

Function OnClick_btnDoorClose ( Reason )
  LogAdd "Door Lock"
  Command_Debug_DoorFunction 1
  System.Delay(100)
  LogAdd "Door Hold"
  Command_Debug_DoorFunction 2
  ReadIO
End Function


'------------------------------------------------------------------
' Supporting Functions
'------------------------------------------------------------------
Function GetFirmwareInfo ( )
  Dim AppMaj,AppMin,Timeout
  Timeout = 0
  If Command_GetFW($(PARAM_DL_ZIEL_APPL),AppMaj,AppMin) = 1 Then
    Visual.Select("textAppVersion").Value = String.Format("%02X.%02X", AppMaj,AppMin)
  Else
    Timeout = 1
    Visual.Select("textAppVersion").Value = "??.??"
  End If
  
  If Timeout = 0 Then
    If AppMin < eSWVersionMin OR AppMaj < eSWVersionMaj Then
      LogAdd ("Warning: eSW version is lower than V" & String.Format("%02X.%02X", eSWVersionMaj,eSWVersionMin) & " Not all functions will work properly with CACCIA module!")
    Else
      LogAdd ("Read Firmware")
    End If
    If Command_GetFW($(PARAM_DL_ZIEL_BIOS),AppMaj,AppMin) = 1 Then
      Visual.Select("textBiosVersion").Value = String.Format("%02X.%02X", AppMaj,AppMin)
    Else
      Visual.Select("textBiosVersion").Value = "??.??"
    End If
  Else
    Visual.Select("textBiosVersion").Value = "??.??"
  End If 

  If Timeout = 1 Then
    GetFirmwareInfo = False
  Else
    GetFirmwareInfo = True  
  End If
End Function
'------------------------------------------------------------------

Function GetCassetteInfo ( )
  If Command_GetCassette = True Then
    GetCassetteInfo = True
    CassetteInfoDisplay Memory.CANData.Data(3),"inputCasInfoTop","sel_cassette_top"
    CassetteInfoDisplay Memory.CANData.Data(2),"inputCasInfoBottom","sel_cassette_bottom"
  Else
    GetCassetteInfo = False
    DebugMessage "Read Cassette Info Failed"
  End If  
End Function

'------------------------------------------------------------------

Sub CassetteInfoDisplay( CasType, CasDisplay, CasSelect )
  If Visual.Exists(CasDisplay) Then
    Select Case CasType
    Case &h00 : 
      Visual.Select(CasDisplay).Value = "None"
      Visual.Select(CasSelect).SelectedIndex = "2"
    Case &hFF : 
      Visual.Select(CasDisplay).Value = "RFID Err"    
      Visual.Select(CasSelect).SelectedIndex = "2"
    Case &h07 : 
      Visual.Select(CasDisplay).Value = "7 Level"
      Visual.Select(CasSelect).SelectedIndex = "1"
    Case &h09 : 
      Visual.Select(CasDisplay).Value = "9 Level"
      Visual.Select(CasSelect).SelectedIndex = "0"
    Case Else Visual.Select(CasDisplay).Value = "-"
    End Select
  End If
End Sub

'------------------------------------------------------------------

Function ValidateFeederID( FeederID )
  Visual.Select("inputFeederID").Value = FeederID  
  Visual.Select("inputFeederID").style.backgroundColor = "white"
  If Len(FeederID) < 12 or FeederID = "????????????" Then
    Visual.Select("inputFeederID").style.backgroundColor = "red"
  Elseif Visual.Select("inputFeederID").Value = "79ASMDH09999" Then
    Visual.Select("inputFeederID").style.backgroundColor = "red"
    LogAdd "No FeederID programmed!"
    MsgBox "No FeederID programmed!"
  End If  
End Function
'------------------------------------------------------------------

Function ValidateAcc ( Value  )
  If Value > 255 OR Value < 0 Then
    ValidateAcc = 1
  Else
    ValidateAcc = 0
  End If
End Function

Function UpdateCycleTime ( Value )
  
  If Memory.Exists("StartTime") Then
    If Memory.Endurance_InProgress = 0 Then
      LogAdd "CycleTime :" & (Value - Memory.StartTime)/10000      
    End If
    DebugMessage "CycleTime :" & (Value - Memory.StartTime)/10000
    Visual.Select("textTEx_current").Value = (Value - Memory.StartTime)/10000
    Memory.Free "StartTime"
  End If
End Function
