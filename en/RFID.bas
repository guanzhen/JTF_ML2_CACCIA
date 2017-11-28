
Function RFID_Read 
  Dim CanReadArg
  Dim counter,datacounter
  Dim DataArray
  Dim LoopRun,LoopError
  Dim LoopValue
  Dim ResultString
  Set DataArray = CreateObject("Math.ByteArray")
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  If RFID_Start = 1 Then
    DebugMessage "RFID Start"
    LoopRun = 1
    LoopError = 0
    datacounter = 0
    DataArray.RemoveAll
    Do While LoopRun = 1
      'If RFID_Line returns 0 or 2 : end of data or error.
      LoopValue = RFID_Line(CanReadArg)
      If  LoopValue = 2 Then
        LoopRun = 0
        DebugMessage "RFID End of Data Reached"
      Elseif LoopValue = 0 Then
        LoopError = 1
        LoopRun = 0
        DebugMessage "RFID Error read"
      End If
      
      If LoopError = 0 Then
        For counter = 2 To CanReadArg.Length - 1
          DataArray.Add(CanReadArg.Data(counter))
          'ResultString = ResultString & " " & CanReadArg.Data(counter)
          'DebugMessage "DataCount:" & datacounter & " Byte count:" & counter & "Content:" & String.Format("%02x",CanReadArg.Data(counter))
          datacounter = datacounter+1
        Next
      End If
    Loop
    
    RFID_End
    DebugMessage "RFID End"
    DebugMessage "Size: "&DataArray.Size
    'DebugMessage DataArray.ExtractString(0,datacounter-1)
    Visual.Select("testrfid").Value = ResultString
    Memory.Set "RFID_Array",DataArray
    RFID_Read = LoopError
  Else
    LogAdd "Read RFID Start Error"
    RFID_End
  End If

End Function

Const RFID_PARAM_VER = &h00
Const RFID_PARAM_STARTADDR = &h01
Const RFID_PARAM_SERIAL = &h02
Const RFID_PARAM_DEVTYPE = &h03
Const RFID_PARAM_VARIENT = &h04
Const RFID_PARAM_PARTNO = &h05
Const RFID_PARAM_HWVER = &h06
Const RFID_PARAM_HWREV = &h07
Const RFID_PARAM_YEAR = &h08
Const RFID_PARAM_MONTH = &h09
Const RFID_PARAM_DATE = &h0A
Const RFID_PARAM_MFG = &h0B

Function RFID_Param_GetLength ( Param )

  Select Case Param 
  Case RFID_PARAM_VER:          RFID_Param_GetLength = 1
  Case RFID_PARAM_STARTADDR :   RFID_Param_GetLength = 1
  Case RFID_PARAM_SERIAL :      RFID_Param_GetLength = 2
  Case RFID_PARAM_DEVTYPE :     RFID_Param_GetLength = 2
  Case RFID_PARAM_VARIENT :     RFID_Param_GetLength = 2
  Case RFID_PARAM_PARTNO :      RFID_Param_GetLength = 4
  Case RFID_PARAM_HWVER :       RFID_Param_GetLength = 1
  Case RFID_PARAM_HWREV :       RFID_Param_GetLength = 1
  Case RFID_PARAM_YEAR :        RFID_Param_GetLength = 1
  Case RFID_PARAM_MONTH :       RFID_Param_GetLength = 1
  Case RFID_PARAM_DATE :        RFID_Param_GetLength = 1
  Case RFID_PARAM_MFG :         RFID_Param_GetLength = 3
  Case Else  RFID_Param_GetLength = -1
  End Select

End Function 

Function RFID_Param_GetAddr ( Param )

  Select Case Param 
  Case RFID_PARAM_VER:          RFID_Param_GetAddr = &h00
  Case RFID_PARAM_STARTADDR :   RFID_Param_GetAddr = &h01
  Case RFID_PARAM_SERIAL :      RFID_Param_GetAddr = &h02
  Case RFID_PARAM_DEVTYPE :     RFID_Param_GetAddr = &h04
  Case RFID_PARAM_VARIENT :     RFID_Param_GetAddr = &h06
  Case RFID_PARAM_PARTNO :      RFID_Param_GetAddr = &h08
  Case RFID_PARAM_HWVER :       RFID_Param_GetAddr = &h0C
  Case RFID_PARAM_HWREV :       RFID_Param_GetAddr = &h0D
  Case RFID_PARAM_YEAR :        RFID_Param_GetAddr = &h0E
  Case RFID_PARAM_MONTH :       RFID_Param_GetAddr = &h0F
  Case RFID_PARAM_DATE :        RFID_Param_GetAddr = &h10
  Case RFID_PARAM_MFG :         RFID_Param_GetAddr = &h11
  Case Else  RFID_Param_GetLength = -1
  End Select
  
End Function 

Function RFID_ParseInfo( Cassette, Parameter, ByRef OutputString, Format )
  Dim RFID_Array,counter
  Dim GetDataType,GetAddress,GetLength
  Memory.Get "RFID_Array",RFID_Array
  
  GetAddress = RFID_Param_GetAddr(Parameter)+(Cassette*20)
  GetLength = RFID_Param_GetLength(Parameter)
  
  DebugMessage "Addr " &GetAddress& " Len " & GetLength
  
  If Format = "s" Then
    For counter = GetAddress to GetAddress+GetLength-1
      OutputString = RFID_Array.Data(counter)
    Next
  Else
  OutputString = RFID_Array.Format(GetAddress,GetLength,Format)
  End If
  RFID_ParseInfo = OutputString
  
End Function


Function RFID_Start
  If Command_GetRFID(0) Then    
    RFID_Start = 1
  Else
    RFID_Start = 0
  End If
End Function

'Return 0 = OK
'Return 2 = OK_EOL

Function RFID_Line ( ByRef CanReadArg )
  Dim CanSendArg,CANConfig
  Set CanSendArg = CreateObject("ICAN.CanSendArg")

  If Command_GetRFID(1) Then    
    If Memory.CANData(1) = $(ACK_NO_MORE_DATA) Then 
      RFID_Line = 2
    Elseif Memory.CANData(1) = 0 Then
      RFID_Line = 1
    Else
    RFID_Line = 0
    End If
  Else
  'Error
  End if
End Function


Function RFID_End
  If Command_GetRFID(2) Then   
    RFID_End = 1
  Else
    RFID_End = 0
  End If
End Function 