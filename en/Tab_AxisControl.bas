
' Default Lift Encoder Values for Door and Index position
Const ELVT_DEFAULT_DOOR =  &hfffe9e40
Const ELVT_DEFAULT_INDEX = &hfffe6b80

'------------------------------------------------------------------
'Window Init Function
'------------------------------------------------------------------
Function Init_Window_AxisControl
  Visual.Select("input_KickerOutPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  Visual.Select("input_pusherpickupPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  Visual.Select("input_pshrtrayinPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  Visual.Select("input_pshrtraytouchPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  Visual.Select("input_clprstandbyPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  Visual.Select("input_clprclampPos").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10
  OnChange_Command_AxisMoveList 0
  OnChange_Command_AxisMoveList2 0
End Function

'------------------------------------------------------------------
'Button Click Functions
'------------------------------------------------------------------
Function OnClick_btnReadEncPos ( Reason )
  Dim CANData
  Memory.Get "CANData",CANData
  
  Command_GetEncPosCnt $(PARAM_LVLPOS_KIKR),1
  Memory.SignalArray.Data(MotorEncoderPosKirkOut) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      
  
  Command_GetEncPosCnt $(PARAM_LVLPOS_PSHR),1
  Memory.SignalArray.Data(MotorEncoderPosPshrPickup) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      
  
  Command_GetEncPosCnt $(PARAM_LVLPOS_PSHR),2
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      
  
  Command_GetEncPosCnt $(PARAM_LVLPOS_PSHR),3
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      

  Command_GetEncPosCnt $(PARAM_LVLPOS_CLPR),1
  Memory.SignalArray.Data(MotorEncoderPosClprStandby) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      

  Command_GetEncPosCnt $(PARAM_LVLPOS_CLPR),2
  Memory.SignalArray.Data(MotorEncoderPosClprClamping) =  Lang.MakeLong4(CANData(2),CANData(3),CANData(4),CANData(5))      
  
End Function

'------------------------------------------------------------------
Function OnClick_btnSetMidIndexPos( Reason ) 
  Dim CurrEncValue
  LogAdd "Set current Elevator position as Index Position"
  Command_Debug_SaveOffset (1)
End Function
'------------------------------------------------------------------

Function OnClick_btnSetDoorPos( Reason ) 
  Dim CurrEncValue
  LogAdd "Set current Elevator position as Door Position"
  Command_Debug_SaveOffset (2)
End Function
'------------------------------------------------------------------

Function OnClick_btnMoveBtmCass ( Reason )
Command_Debug_MoveLevel 5, "Bottom Cassette Position"

End Function
'------------------------------------------------------------------

Function OnClick_btnMoveTopCass ( Reason )
Command_Debug_MoveLevel 6, "Top Cassette Position"

End Function
'------------------------------------------------------------------

Function OnClick_btnMovetoMidIndexPos ( Reason )
Command_Debug_MoveLevel 2, "Mid Index Position"

End Function
'------------------------------------------------------------------
Function OnClick_btnSetMidIndexPosDefault ( Reason )
 Command_SetIndexOffset ELVT_DEFAULT_INDEX

End Function
'------------------------------------------------------------------
Function OnClick_btnMovetoDoorPos ( Reason )
Command_Debug_MoveLevel 6, "Cassette Loading Position"


End Function
'------------------------------------------------------------------
Function OnClick_btnSetDoorPosDefault ( Reason )
 Command_SetDoorOffset ELVT_DEFAULT_DOOR

End Function
'------------------------------------------------------------------


Function OnClick_btnclrusrerr ( Reason )
  Command_Prepare_ClearErr
End Function 

'------------------------------------------------------------------
Function OnClick_btnGetRefInfo ( Reason )
  Dim CANData, Result
  Memory.Get "CANData",CANData
  
  LogAdd "Get Reference and Tray Info"
  Result = GetRefRun(REF_ALL)
  If Result = True Then
  Result = GetRefRun(REF_ELVT)
  End If
  If Result = True Then  
  Result = GetRefRun(REF_KIKR)
  End If
  If Result = True Then
  Result = GetRefRun(REF_CNVY)
  End If
  If Result = True Then
  Result = GetRefRun(REF_PSHR)
  End If
  If Result = True Then
  Result = GetRefRun(REF_CLPR)
  End If

  If Result = True Then  
    Memory.CANData(0) = $(JTF_DBG_LIFTPOS)
    If CANSendTACMD($(CMD_GET_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,1) = True Then
      Result = True
      Visual.Select("refpos_lift").Value = String.Format("0x%08X", Lang.MakeLong4(CANData.Data(2),CANData.Data(3),CANData.Data(4),CANData.Data(5)))
    End If
  End If
  
  If Result = True Then  
    Memory.CANData(0) = $(JTF_DBG_DOORPOS)
    If CANSendTACMD($(CMD_GET_DATA),$(MC_TEST_PRODUCTION),SLOT_NO,1,1) = True Then
      Result = True
      Visual.Select("refpos_door").Value = String.Format("0x%08X", Lang.MakeLong4(CANData.Data(2),CANData.Data(3),CANData.Data(4),CANData.Data(5)))
    End If
  End If
  If Result = True Then  
    Command_GetCnvyTrayInfo
  End If
End Function 
'------------------------------------------------------------------
Function OnClick_btnencoderset0 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_KickerOutPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderKicker)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_KIKR),1,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosKirkOut) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
  
End Function 
'------------------------------------------------------------------
Function OnClick_btnencoderset1 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_pusherpickupPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderPusher)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_PSHR),1,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosPshrPickup) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
End Function 

'------------------------------------------------------------------
Function OnClick_btnencoderset2 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_pshrtrayinPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderPusher)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_PSHR),2,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
End Function 

'------------------------------------------------------------------
Function OnClick_btnencoderset3 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_pshrtraytouchPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderPusher)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_PSHR),3,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
End Function 

'------------------------------------------------------------------
Function OnClick_btnencoderset4 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_clprstandbyPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderClamper)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_CLPR),1,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosClprStandby) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
End Function 

'------------------------------------------------------------------
Function OnClick_btnencoderset5 ( Reason )
  Dim NewEncoderVal
  NewEncoderVal = String.SafeParse(Visual.Select("input_clprclampPos").Value,0)
  If Visual.Select("check_newpossrc").Checked = True Then  
    NewEncoderVal = Memory.SignalArray.Data(MotorEncoderClamper)
  End If
  
  Command_SetEncPosCnt $(PARAM_LVLPOS_CLPR),2,NewEncoderVal
  Memory.SignalArray.Data(MotorEncoderPosClprClamping) =  NewEncoderVal  
  DebugMessage "New Encoder Value: "& NewEncoderVal
  LogAdd "New Encoder Value: "& String.Format("0x%08x",NewEncoderVal)
End Function 


'------------------------------------------------------------------

Function OnClick_btn_elvtbrakeon ( Reason )
  Command_Debug_AxisBrake 1,1
End Function

Function OnClick_btn_elvtbrakeoff ( Reason )
  Command_Debug_AxisBrake 1,0
End Function
 
'------------------------------------------------------------------
' Supporting Functions
'------------------------------------------------------------------

Function GetRefRun ( Axis )
  Dim refrun_sel

  Select Case Axis
  Case REF_ALL : refrun_sel = OperationAllRefRun
  Case REF_ELVT:  refrun_sel = OperationLiftRefRun
  Case REF_PSHR:  refrun_sel = OperationPusherRefRun
  Case REF_CLPR:  refrun_sel = OperationClamperRefRun
  Case REF_KIKR:  refrun_sel = OperationKickerRefRun
  Case REF_CNVY:  refrun_sel = OperationConveyorRefRun
  End Select

  If Command_GetData_GetRefRun(Axis) = 1 Then
    If Memory.CANData(2) = 0 Then
      Memory.SignalArray.Data(refrun_sel) =  "Need Reference"
      GetRefRun = False
    Else
      Memory.SignalArray.Data(refrun_sel) =  "Referenced"
      GetRefRun = True
    End If
  End If
 End Function

'------------------------------------------------------------------
Function ChangeAxisMoveList( source , item )
  Visual.Select(item).RemoveAll  
  If Visual.Select(source).SelectedItemAttribute("Value") = 2 Then
    Visual.Select(item).addItem "Step In", 0
    Visual.Select(item).addItem "Step Out", 1
  Elseif Visual.Select(source).SelectedItemAttribute("Value") = 3 Then  
    Visual.Select(item).addItem "Retract", 0
    Visual.Select(item).addItem "Kick", 1
  Elseif Visual.Select(source).SelectedItemAttribute("Value") = 4 Then
    Visual.Select(item).addItem "Home", 0
    Visual.Select(item).addItem "Forward", 1  
    Visual.Select(item).addItem "Backward", 2
  Elseif Visual.Select(source).SelectedItemAttribute("Value") = 5 Then
    Visual.Select(item).addItem "Home", 0
    Visual.Select(item).addItem "Standby", 1  
    Visual.Select(item).addItem "Clamp", 2
  End If

End Function

'------------------------------------------------------------------

Function OnChange_Command_AxisMoveList ( Reason )
  ChangeAxisMoveList "Command_AxisMoveList","Command_AxisMoveLevel"
End Function

'------------------------------------------------------------------

Function OnChange_Command_AxisMoveList2 ( Reason )
  ChangeAxisMoveList "Command_AxisMoveList2","Command_AxisMoveLevel2"
End Function

'------------------------------------------------------------------

Function OnClick_btnMoveAxis ( Reason )
  If GetRefRun(REF_ALL) Then
  Command_Debug_MoveAxis Visual.Select("Command_AxisMoveList").SelectedItemAttribute("Value"),Visual.Select("Command_AxisMoveLevel").SelectedItemAttribute("Value"),Visual.Select("Command_AxisMoveLevel").SelectedItemName
  Else
    LogAdd "Please Reference Tesla First"
  End If
End Function

'------------------------------------------------------------------

Function OnClick_btnMoveAxis2 ( Reason )
  If GetRefRun(REF_ALL) Then
  Command_Debug_MoveAxis Visual.Select("Command_AxisMoveList2").SelectedItemAttribute("Value"),Visual.Select("Command_AxisMoveLevel2").SelectedItemAttribute("Value"),Visual.Select("Command_AxisMoveLevel").SelectedItemName
  Else
    LogAdd "Please Reference Tesla First"
  End If
End Function

'------------------------------------------------------------------

Function OnClick_btnIndividualRefRun2(Reason)
  Dim Axis 
    'Read IO and check if sensor is active
    ReadIO
    If Memory.SignalArray.Data(MotorPwrOff) = 1 Then
      Axis = Visual.Select("Command_AxisRefRunList2").SelectedItemAttribute("value")
      DebugMessage "Reference Run Axis: " & Axis
    
      If Axis = 1 Then
        Command_Debug_AxisBrake 1,0
        System.Delay(100)
      End If
      
      Command_Debug_AxisRefRun Axis    
        
      If Axis = 1 Then
        LogAdd "Waiting 30 seconds to enable Lift brake..."
        System.Delay(30000)
        Command_Debug_AxisBrake 1,1      
      End If      
     Else
      LogAdd "No power to motors. Please lock Tesla door/close the safety loop"     
     End If
   
End Function

'------------------------------------------------------------------

Function OnClick_btnIndividualRefRun(Reason)
  Dim Axis 
    'Read IO and check if sensor is active
    ReadIO
    If Memory.SignalArray.Data(MotorPwrOff) = 1 Then
      Axis = Visual.Select("Command_AxisRefRunList").SelectedItemAttribute("value")
      DebugMessage "Reference Run Axis: " & Axis
    
      If Axis = 1 Then
        Command_Debug_AxisBrake 1,0
        System.Delay(100)
      End If
      
      Command_Debug_AxisRefRun Axis    
        
      If Axis = 1 Then
        LogAdd "Waiting 30 seconds to enable Lift brake..."
        System.Delay(30000)
        Command_Debug_AxisBrake 1,1      
      End If      
     Else
      LogAdd "No power to motors. Please lock Tesla door/close the safety loop"     
     End If
   
End Function
