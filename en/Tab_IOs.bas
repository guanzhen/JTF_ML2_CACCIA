
'------------------------------------------------------------------
'Constants
'------------------------------------------------------------------

Const SensorDoorSwitch   = 0
Const SensorDoorLock     = 1
Const SensorLiftHome     = 2
Const SensorTrayHome     = 3
Const SensorGapSensor    = 4
Const SafetyLoop         = 5
Const SensorKickerHome   = 6
Const SensorTopLimit     = 7
Const SensorFwSlowDown   = 8
Const SensorRvSlowDown   = 9
Const SensorPusherHome   = 10
Const SensorClamperHome  = 11
Const LiftBrake          = 12
Const MotorPwrOff        = 13
Const StopAtEnd          = 14
Const SensorMax          = 15

Const MotorEncoderGrpBegin        = 21
Const MotorEncoderLift            = 22
Const MotorEncoderKicker          = 23
Const MotorEncoderConveyor        = 24
Const MotorEncoderPusher          = 25
Const MotorEncoderClamper         = 26
Const MotorEncoderPosKirkOut      = 27
Const MotorEncoderPosPshrPickup   = 28
Const MotorEncoderPosPshrTrayIn   = 29
Const MotorEncoderPosPshrTrayTouch= 30
Const MotorEncoderPosClprStandby  = 31
Const MotorEncoderPosClprClamping = 32
Const MotorEncoderGrpEnd          = 33

Const OperationGrpBegin           = 34
Const OperationAllRefRun          = 35
Const OperationLiftRefRun         = 36
Const OperationKickerRefRun       = 37
Const OperationConveyorRefRun     = 38
Const OperationPusherRefRun       = 39
Const OperationClamperRefRun      = 40
Const OperationLiftTrayIoContRun  = 41
Const OperationLiftContRun        = 42
Const OperationKickerContRun      = 43
Const OperationConveyorContRun    = 44
Const OperationPusherContRun      = 45
Const OperationClamperContRun     = 46
Const OperationGrpEnd             = 47
Const ArrayMaxNum                 = 48

Const AXIS_Elvt = 1
Const AXIS_Pshr = 2
Const AXIS_Clpr = 3
Const AXIS_Kikr = 4
Const AXIS_Cnvy = 5

Const REF_ALL = &h00
Const REF_ELVT = &h01
Const REF_CNVY = &h02
Const REF_KIKR = &h03
Const REF_PSHR = &h04
Const REF_CLPR = &h05

'------------------------------------------------------------------
'Window Init
'------------------------------------------------------------------
Sub Init_Window_IO
  Dim SignalArray
  Dim i
  Set SignalArray = CreateObject( "MATH.Array" )
  Memory.Set "SignalArray",SignalArray

  For i = 1  To ArrayMaxNum
  	SignalArray.Add(0)
  Next
  
  Layer_IO_ChgLedStatus "DoorSwitchLed",Memory.SignalArray.Data(SensorDoorSwitch)
  Layer_IO_ChgLedStatus "DoorLockLed",  Memory.SignalArray.Data(SensorDoorLock)
  Layer_IO_ChgLedStatus "BottomLed",    Memory.SignalArray.Data(SensorLiftHome)
  Layer_IO_ChgLedStatus "TrayLed",      Memory.SignalArray.Data(SensorTrayHome)
  Layer_IO_ChgLedStatus "GapLed",       Memory.SignalArray.Data(SensorGapSensor)
  Layer_IO_ChgLedStatus "SafetyLoopLED",     Memory.SignalArray.Data(SafetyLoop)
  Layer_IO_ChgLedStatus "KickerHmLed",  Memory.SignalArray.Data(SensorKickerHome)
  Layer_IO_ChgLedStatus "FwSdLed",      Memory.SignalArray.Data(SensorFwSlowDown)
  Layer_IO_ChgLedStatus "RwSdLed",      Memory.SignalArray.Data(SensorRvSlowDown)
  Layer_IO_ChgLedStatus "PusherHmLed",  Memory.SignalArray.Data(SensorPusherHome)
  Layer_IO_ChgLedStatus "ClamperHmLed", Memory.SignalArray.Data(SensorClamperHome)
  Layer_IO_ChgLedStatus "LiftBrakeLed", Memory.SignalArray.Data(LiftBrake)
  Layer_IO_ChgLedStatus "MtrPowerOff",  Memory.SignalArray.Data(MotorPwrOff)
  Layer_IO_ChgLedStatus "EndSensor",    Memory.SignalArray.Data(StopAtEnd)
  
	Layer_IO_ChgMotorEncoderValue "LiftMotorEncoder",      Memory.SignalArray.Data(MotorEncoderLift)
	Layer_IO_ChgMotorEncoderValue "KickerMotorEncoder",    Memory.SignalArray.Data(MotorEncoderKicker)
	Layer_IO_ChgMotorEncoderValue "ConveyorMotorEncoder",  Memory.SignalArray.Data(MotorEncoderConveyor)
	Layer_IO_ChgMotorEncoderValue "PusherMotorEncoder",    Memory.SignalArray.Data(MotorEncoderPusher)
	Layer_IO_ChgMotorEncoderValue "ClamperMotorEncoder",   Memory.SignalArray.Data(MotorEncoderClamper)

  Memory.SignalArray.Data(OperationLiftRefRun) = "-"
  Memory.SignalArray.Data(OperationKickerRefRun)= "-"
  Memory.SignalArray.Data(OperationConveyorRefRun) = "-"
  Memory.SignalArray.Data(OperationPusherRefRun) = "-"
  Memory.SignalArray.Data(OperationClamperRefRun) = "-"
  Memory.SignalArray.Data(OperationAllRefRun) = "-"
  
  Visual.Select("OverAllRefRun").Value = Memory.SignalArray.Data(OperationAllRefRun)
  Visual.Select("LiftMotorRefRun").Value = Memory.SignalArray.Data(OperationLiftRefRun)
  Visual.Select("KickerMotorRefRun").Value = Memory.SignalArray.Data(OperationKickerRefRun)
  Visual.Select("ConveyorMotorRefRun").Value = Memory.SignalArray.Data(OperationConveyorRefRun)
  Visual.Select("PusherMotorRefRun").Value = Memory.SignalArray.Data(OperationPusherRefRun)
  Visual.Select("ClamperMotorRefRun").Value = Memory.SignalArray.Data(OperationClamperRefRun)
  
  Memory.SignalArray.Data(MotorEncoderPosKirkOut) = 0
  Memory.SignalArray.Data(MotorEncoderPosPshrPickup)= 0
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn) = 0
  Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch) = 0
  Memory.SignalArray.Data(MotorEncoderPosClprStandby) = 0
  Memory.SignalArray.Data(MotorEncoderPosClprClamping) = 0
  
  Visual.Select("input_kikroutcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosKirkOut)
  Visual.Select("input_pusherpickupcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrPickup)
  Visual.Select("input_pshrtrayincurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn)
  Visual.Select("input_pshrtraytouchcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch)
  Visual.Select("input_clprstandbycurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosClprStandby)
  Visual.Select("input_clprclampcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosClprClamping)
  
  'hide the hidden frame
  Visual.Select("IOframe_hidden").style.display = "none"
	StartIOThread 1
End Sub

'------------------------------------------------------------------
'Button Click Functions
'------------------------------------------------------------------
Function OnClick_btnReadIO ( Reason )
  
		If Not Memory.Exists("signal_IOPollStop") Then
      Visual.Select("btnReadIO").value = "Stop IO Polling"
      LogAdd "IO Polling Started"
		  StartIOPolling 1
    Else
      Visual.Select("btnReadIO").value = "Start IO Polling"
      LogAdd "IO Polling Stopped"
		  StartIOPolling 0
		End if   
  
End Function

'------------------------------------------------------------------
Function OnClick_btnReadEnc ( Reason )

  ReadEncoderValue AXIS_Elvt
  ReadEncoderValue AXIS_Pshr
  ReadEncoderValue AXIS_Clpr
  ReadEncoderValue AXIS_Kikr
  ReadEncoderValue AXIS_Cnvy

End Function
'------------------------------------------------------------------
'Supporting Functions
'------------------------------------------------------------------

Function ReadIO( )
  Dim CANData
  Dim iByte, iBit, bitCount, exitLoop
  Memory.Get "CANData",CANData
  bitCount = 0
  exitLoop = 0
 
  If Command_GetIO  = True Then
    For iByte = 2 to 7
      'DebugMessage "Byte Content:" & CANData.Data(iByte)
      For iBit = 0 to 7
        'IO_setValue bitCount,Lang.Bit(CanReadArg.Data(iByte),iBit)
        'DebugMessage "BitCnt: " & bitCount & " Byte | Bit | Memory.CANData.Data: " & iByte & " " &iBit & " " & Lang.Bit(CANData.Data(iByte),iBit)
        
        Select Case bitCount
        Case SensorDoorSwitch : Memory.SignalArray.Data(SensorDoorSwitch) = Invert_IO(Lang.Bit(CANData.Data(iByte),iBit))
        Case SensorDoorLock   : Memory.SignalArray.Data(SensorDoorLock)   = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorLiftHome   : Memory.SignalArray.Data(SensorLiftHome)   = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorTrayHome   : Memory.SignalArray.Data(SensorTrayHome)   = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorGapSensor  : Memory.SignalArray.Data(SensorGapSensor)  = Lang.Bit(CANData.Data(iByte),iBit)
        Case SafetyLoop       : Memory.SignalArray.Data(SafetyLoop)       = Invert_IO(Lang.Bit(CANData.Data(iByte),iBit))
        Case SensorKickerHome : Memory.SignalArray.Data(SensorKickerHome) = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorFwSlowDown : Memory.SignalArray.Data(SensorFwSlowDown) = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorRvSlowDown : Memory.SignalArray.Data(SensorRvSlowDown) = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorPusherHome : Memory.SignalArray.Data(SensorPusherHome) = Lang.Bit(CANData.Data(iByte),iBit)
        Case SensorClamperHome: Memory.SignalArray.Data(SensorClamperHome)= Lang.Bit(CANData.Data(iByte),iBit)
        Case LiftBrake        : Memory.SignalArray.Data(LiftBrake)        = Invert_IO(Lang.Bit(CANData.Data(iByte),iBit))
        Case MotorPwrOff      : Memory.SignalArray.Data(MotorPwrOff)      = Invert_IO(Lang.Bit(CANData.Data(iByte),iBit))
        Case StopAtEnd        : Memory.SignalArray.Data(StopAtEnd)        = Lang.Bit(CANData.Data(iByte),iBit)
        Case Else :
        End Select
        'DebugMessage "BitCnt: " & bitCount & " Byte | Bit | Memory.CANData.Data: " & iByte & " " &iBit & " " & Lang.Bit(CANData.Data(iByte),iBit)
        bitCount = bitCount+1
        'stop at the maximum number of LEDs to update
        If bitCount >= SensorMax Then
          exitLoop = 1
          Exit For
        End If
      Next
      If exitLoop = 1 Then
        Exit For
      End If
    Next
  Else
    LogAdd "Read Sensor Error!" 
  End If
End Function

Function Invert_IO ( Value )

If Value = 1 Then
Invert_IO = Lang.Bit(&h0,0)
Else
Invert_IO = Lang.Bit(&h1,0)
End If
End Function
'------------------------------------------------------------------
Function Layer_IO_ChgLedStatus ( Var_ID , OnOff )
		If OnOff = 1 Then
  		Visual.Select(Var_ID).Src = "./Img/led_green.png"
		ElseIf OnOff = 0 Then
      Visual.Select(Var_ID).Src = "./Img/led_black.png"
    Else
      Visual.Select(Var_ID).Src = "./Img/led_black.png"
		End If
End Function

'------------------------------------------------------------------

Sub Layer_IO_ChgMotorEncoderValue(ID,Value)
  	Visual.Select(ID).Value =  String.Format("%d",Value)
End Sub

'------------------------------------------------------------------

Function StartIOPolling(Par1)
  
	If Par1 = 1 Then

		If Not Memory.Exists("signal_IOPollStop") Then
		  System.Start "Background_PollIO",1
		End if   
    
	Else
  
		If Memory.Exists("signal_IOPollStop") Then
	  	Memory.signal_IOPollStop.Set
		End if
    
		Do While Memory.Exists("signal_IOPollStop") = 1      
			System.Delay(100)      
		Loop
    
	End If
End Function

'------------------------------------------------------------------

Function Background_PollIO(Par1)
  Dim signal_IOPollStop
  Dim LoopContinue
  
  Set signal_IOPollStop = Signal.Create
  
  Memory.Set "signal_IOPollStop", signal_IOPollStop
  
  LoopContinue = 1
  
  Do while LoopContinue = 1
  
    ReadIO
    
    If signal_IOPollStop.wait(50) Then
      LoopContinue = 0
    End If
    
    System.Delay(150)    
  Loop
    
	Memory.Free "signal_IOPollStop"
End Function


'------------------------------------------------------------------
Function StartIOThread(Par1)
  
	If Par1 = 1 Then

		If Not Memory.Exists("evBkGrdRfStopSignal") Then
		  System.Start "BackgroundReFreshIO",1
		End if   
	Else

		If Memory.Exists("evBkGrdRfStopSignal") Then
	  	Memory.evBkGrdRfStopSignal.Set
		End if
    
		Do While Memory.Exists("evBkGrdRfStopSignal") = 1
      
			System.Delay(100)
      
		Loop

		'MsgBox "Thread Closed!"

	End If
End Function

'------------------------------------------------------------------

Function BackgroundReFreshIO(Par1)
  Dim BkGrdRfStopSignal
  Dim BkGrdRfUpdateSignal
	Dim LoopContinue

  Set BkGrdRfStopSignal = Signal.Create

  Memory.Set "evBkGrdRfStopSignal", BkGrdRfStopSignal

  LoopContinue = 1
	Do while LoopContinue = 1
    
    Layer_IO_ChgLedStatus "DoorSwitchLed",Memory.SignalArray.Data(SensorDoorSwitch)
    Layer_IO_ChgLedStatus "DoorSwitchLed2",Memory.SignalArray.Data(SensorDoorSwitch)
    Layer_IO_ChgLedStatus "DoorLockLed",  Memory.SignalArray.Data(SensorDoorLock)
    Layer_IO_ChgLedStatus "DoorLockLed2", Memory.SignalArray.Data(SensorDoorLock)
    Layer_IO_ChgLedStatus "BottomLed",    Memory.SignalArray.Data(SensorLiftHome)
    Layer_IO_ChgLedStatus "TrayLed",      Memory.SignalArray.Data(SensorTrayHome)
    Layer_IO_ChgLedStatus "GapLed",       Memory.SignalArray.Data(SensorGapSensor)
    Layer_IO_ChgLedStatus "SafetyLoopLED",     Memory.SignalArray.Data(SafetyLoop)
    Layer_IO_ChgLedStatus "KickerHmLed",  Memory.SignalArray.Data(SensorKickerHome)
    Layer_IO_ChgLedStatus "FwSdLed",      Memory.SignalArray.Data(SensorFwSlowDown)
    Layer_IO_ChgLedStatus "RwSdLed",      Memory.SignalArray.Data(SensorRvSlowDown)
    Layer_IO_ChgLedStatus "PusherHmLed",  Memory.SignalArray.Data(SensorPusherHome)
    Layer_IO_ChgLedStatus "ClamperHmLed", Memory.SignalArray.Data(SensorClamperHome)
    Layer_IO_ChgLedStatus "LiftBrakeLed", Memory.SignalArray.Data(LiftBrake)
    Layer_IO_ChgLedStatus "MtrPowerOff",  Memory.SignalArray.Data(MotorPwrOff)

		Layer_IO_ChgMotorEncoderValue "LiftMotorEncoder",      Memory.SignalArray.Data(MotorEncoderLift)
		Layer_IO_ChgMotorEncoderValue "KickerMotorEncoder",    Memory.SignalArray.Data(MotorEncoderKicker)
		Layer_IO_ChgMotorEncoderValue "ConveyorMotorEncoder",  Memory.SignalArray.Data(MotorEncoderConveyor)
		Layer_IO_ChgMotorEncoderValue "PusherMotorEncoder",    Memory.SignalArray.Data(MotorEncoderPusher)
		Layer_IO_ChgMotorEncoderValue "ClamperMotorEncoder",   Memory.SignalArray.Data(MotorEncoderClamper)

    Visual.Select("OverAllRefRun").Value = Memory.SignalArray.Data(OperationAllRefRun)
    Visual.Select("LiftMotorRefRun").Value = Memory.SignalArray.Data(OperationLiftRefRun)
    Visual.Select("KickerMotorRefRun").Value = Memory.SignalArray.Data(OperationKickerRefRun)
    Visual.Select("ConveyorMotorRefRun").Value = Memory.SignalArray.Data(OperationConveyorRefRun)
    Visual.Select("PusherMotorRefRun").Value = Memory.SignalArray.Data(OperationPusherRefRun)
    Visual.Select("ClamperMotorRefRun").Value = Memory.SignalArray.Data(OperationClamperRefRun)
    
    Layer_IO_ChgMotorEncoderValue "input_kikroutcurrPos",       Memory.SignalArray.Data(MotorEncoderPosKirkOut)
    Layer_IO_ChgMotorEncoderValue "input_pusherpickupcurrPos",  Memory.SignalArray.Data(MotorEncoderPosPshrPickup)
    Layer_IO_ChgMotorEncoderValue "input_pshrtrayincurrPos",    Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn)
    Layer_IO_ChgMotorEncoderValue "input_pshrtraytouchcurrPos", Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch)
    Layer_IO_ChgMotorEncoderValue "input_clprstandbycurrPos",   Memory.SignalArray.Data(MotorEncoderPosClprStandby)
    Layer_IO_ChgMotorEncoderValue "input_clprclampcurrPos",     Memory.SignalArray.Data(MotorEncoderPosClprClamping)
    
    'Visual.Select("input_kikroutcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosKirkOut)
    'Visual.Select("input_pusherpickupcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrPickup)
    'Visual.Select("input_pshrtrayincurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrTrayIn)
    'Visual.Select("input_pshrtraytouchcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosPshrTrayTouch)
    'Visual.Select("input_clprstandbycurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosClprStandby)
    'Visual.Select("input_clprclampcurrPos").Value = Memory.SignalArray.Data(MotorEncoderPosClprClamping)

	  If BkGrdRfStopSignal.wait(50) Then
	  	LoopContinue = 0
	  End If
	Loop
	Memory.Free "evBkGrdRfStopSignal"
End Function

'------------------------------------------------------------------

Function ReadEncoderValue( Encoder )
  
  Dim array_index,param_sel,CanReadArg,CANData
  Set CanReadArg = CreateObject("ICAN.CanReadArg")
  param_sel = 0
  Memory.Get "CANData",CANData
  Select Case Encoder
  Case AXIS_Elvt:  
    array_index = MotorEncoderLift
    param_sel = $(PARAM_ENCCNT_ELVT)
  Case AXIS_Pshr:  
    array_index = MotorEncoderPusher
    param_sel = $(PARAM_ENCCNT_PSHR)
  Case AXIS_Clpr:  
    array_index = MotorEncoderClamper
    param_sel = $(PARAM_ENCCNT_CLPR)
  Case AXIS_Kikr:  
    array_index = MotorEncoderKicker
    param_sel = $(PARAM_ENCCNT_KIKR)
  Case AXIS_Cnvy:  
    array_index = MotorEncoderConveyor
    param_sel = $(PARAM_ENCCNT_CNVY)
  End Select

  If Command_GetEncoderValue(param_sel) = True Then
    Memory.SignalArray.Data(array_index) =  Lang.MakeLong4(CANData.Data(2),CANData.Data(3),CANData.Data(4),CANData.Data(5))
  Else
    LogAdd "Read Encoder Error!"
  End If
  
End Function


