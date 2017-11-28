
Function OnClick_debug_getLED ( Reason )


End Function


'------------------------------------------------------------------
Function OnClick_btnPositive2 ( Reason )
  Dim SignedVal
  SignedVal = -Visual.Select("SelPosControlStep2").SelectedItemAttribute("Value")
  LogAdd "Move Up :" & SignedVal
  DebugMessage "Move Up " & String.Format ("%02x %02x",Lang.GetByte(SignedVal,0),Lang.GetByte(SignedVal,1))
  
  Command_Debug_MoveOffset SignedVal
End Function 
'------------------------------------------------------------------

Function OnClick_btnNegative2( Reason )
  Dim SignedVal
  
  SignedVal =  Visual.Select("SelPosControlStep2").SelectedItemAttribute("Value")
  SignedVal = Math.Cast2Short (SignedVal)
  LogAdd "Move Down :" & SignedVal
  DebugMessage "Move Down " & String.Format ("%02x %02x",Lang.GetByte(SignedVal,0),Lang.GetByte(SignedVal,1))
  Command_Debug_MoveOffset SignedVal  
  
End Function 
'------------------------------------------------------------------
Function OnClick_debug_ResetFlashErrorCnt( Reason ) 

  Command_SetFlsCRCCnt(0)
  System.Delay(100)
  Command_SetFlsSavIncompleteCnt(0)
  System.Delay(100)
  Command_SetEraseFlashPage(0)
  System.Delay(100)
  Command_SetEraseFlashPage(1)
  System.Delay(100)
  Command_SetEraseFlashPage(2)
  System.Delay(100)
  Command_SetEraseFlashPage(3)
  
  LogAdd "Reset Flash CRC Count to 0"
End Function