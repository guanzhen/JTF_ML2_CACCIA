
Const TIMER_START = 1
Const TIMER_STOP = 0

Function Init_Window_Test()
  Visual.Select("input_end_xacc").Value = "255"
  Visual.Select("input_end_zacc").Value = "255" 
  Visual.Select("textDuration").Value = "60" 
  
  Visual.Select("input_end_xacc").SetValidation VALIDATE_INPUT_MASK_UI1,"OrangeRed",10
  Visual.Select("input_end_zacc").SetValidation VALIDATE_INPUT_MASK_UI1,"OrangeRed",10  
  Visual.Select("textDuration").SetValidation VALIDATE_INPUT_MASK_UI4,"OrangeRed",10

  End Function


'------------------------------------------------------------------
'Button Click Functions
'------------------------------------------------------------------
Function OnClick_btn_startendurance ( Reason )

  LogAdd "Endurance Run Start"
  'Check if duration selected is valid.
  If String.SafeParse(Visual.Select("textDuration").Value) = 0 OR String.SafeParse(Visual.Select("textDuration").Value) > 0 Then
     'If no trays selected, then do not start.
    If GetTrayList = True Then
      System.Start Monitor_EnduranceRun
    Else
      LogAdd "No Trays Selected!"      
    End If
  Else
    LogAdd "Invalid Duration!"
  End If  
 
End Function

'------------------------------------------------------------------
Function OnClick_btn_stopendurance ( Reason )
  LogAdd "Stopping Endurance Run..."
  Stop_EnduranceRun
End Function 
'------------------------------------------------------------------

Function OnClick_btn_endcheckall ( Reason )
  Dim string_chkbox_sel,lvl_counter

  For lvl_counter = 1 to 9
    string_chkbox_sel = "chk_lvlh_" & String.Format("%01d",lvl_counter)
    Visual.Select(string_chkbox_sel).Checked = True
  Next
  
  For lvl_counter = 1 to 9
    string_chkbox_sel = "chk_lvll_" & String.Format("%01d",lvl_counter)
    Visual.Select(string_chkbox_sel).Checked = True
  Next
End Function
'------------------------------------------------------------------

Function OnClick_btn_endclearall( Reason )
  Dim string_chkbox_sel,lvl_counter

  For lvl_counter = 1 to 9
    string_chkbox_sel = "chk_lvlh_" & String.Format("%01d",lvl_counter)
    Visual.Select(string_chkbox_sel).Checked = False
  Next
  
  For lvl_counter = 1 to 9
    string_chkbox_sel = "chk_lvll_" & String.Format("%01d",lvl_counter)
    Visual.Select(string_chkbox_sel).Checked = False
  Next

End Function

'------------------------------------------------------------------
Function Monitor_EnduranceRun ( )
  Dim sig_externalstop,sig_timerend
  Dim loop_enable
  Dim time_start,time_stop,time_elapsed
  Dim curr_tray,next_tray
  Dim Command_Error
  Dim Tray_Array
  Dim interval

  'detect if existing endurance run in progress
  If Not Memory.Exists("sig_externalstop") Then
    Set sig_externalstop = Signal.Create
    Set sig_timerend = Signal.Create
    
    Memory.Set "sig_externalstop", sig_externalstop
    Memory.Set "sig_timerend",sig_timerend
    
    time_start = Time
    Visual.Select("textERstarttime").Value = FormatTimeString(time_start)
    Visual.Select("textERstoptime").Value = ""
    Visual.Select("textERelapsedtime").Value = ""

    'Select Tray to prepare
    curr_tray = Memory.Tray_Array.Data(0)
    next_tray = Memory.Tray_Array.Data(0)
    
    'Disable cassette type selection to prevent user from adjusting.
    Visual.Select("sel_cassette_bottom").Disabled = True
    Visual.Select("sel_cassette_top").Disabled = True
    
    'Start timer for endurance run.
    interval = String.SafeParse(Visual.Select("textDuration").Value) * 60
    If interval > 0 Then
      'DebugMessage "Start Timer"
      Timer_Handler TIMER_START,interval
    End If

    loop_enable = 1
    '1. Get Next Tray 
    '2. Send command
    '3. Wait for Pub Start
    '4. Wait for Pub End
    '5. go to 1.
  
    DebugMessage "Endurance Loop Start"
    Memory.Endurance_InProgress = 1
  'Main loop
  Do while loop_enable = 1

    'Get next tray    
    'curr_tray = next_tray
    'Send command
    Command_Prepare_Tray curr_tray,String.SafeParse(Visual.Select("input_end_xacc").Value),String.SafeParse(Visual.Select("input_end_zacc").Value)
    
    'Get next tray to prepare
    If Visual.Select("chk_endurance_random").Checked Then
      'Random
      GetNextRandomTray curr_tray,next_tray
    Else
      'Sequential
      GetNextSequentialTray curr_tray,next_tray
    End If        
    DebugMessage "Current Tray "& curr_tray &" Next tray " & next_tray
    curr_tray = next_tray
    
    'Wait here while the Prepare Command is still in progress
    Do 
      'Display elapsed time
      time_elapsed = Time - time_start
      Visual.Select("textERelapsedtime").Value = FormatTimeString(time_elapsed)
      
      'Check Error Stop Condition
      If Memory.PrepCmd_Error = 1 Then
        DebugMessage "Endurance Run : Error"
        'Ignore the below errors for Endurance run. Stop on all other errors.
        Select Case Memory.CanErr
          Case $(PB_ERROR_JTF3_NO_TRAY): Command_Error = 0
          Case $(PB_ERROR_JTF3_NO_SUCH_TRAY): Command_Error = 0
          Case Else : 
            Command_Error = 1
            
        End Select
        
        If Command_Error = 1 Then
          loop_enable = 0            
          LogAdd "Endurance Run stopped due to error."
          Exit Do
        End If
      End If
      
      'Check Timer Stop Condition
      If sig_timerend.wait(50) Then
        DebugMessage "Timer Ended!"
        loop_enable = 0       
      End If
      
      'Check button stop condition.
      If sig_externalstop.wait(50) Then
        loop_enable = 0
      End If  
      
    'End Loop Do while Memory.PrepCmd_Inprogress = 1     
    Loop Until Memory.PrepCmd_Inprogress = 0
    
    'Previous tray prepare cycle is completed
    'DebugMessage "Tray Done"      
    'System.Delay(50)
  Loop
  
  time_stop = Time
  Visual.Select("textERstoptime").Value = FormatTimeString(time_stop)
  'DebugMessage "Exiting Loop"
  If Command_Error = 0 Then
    Command_Prepare_Unload
  End If
  If Memory.Exists("sig_timerend") Then
    Timer_Handler TIMER_STOP,0  
  End If
  
  LogAdd "Endurance Run Stopped. Total Time: "& FormatTimeString(time_elapsed)
  DebugMessage "Endurance Run Stopped. Total Time: "& FormatTimeString(time_elapsed)
  
  Memory.Free "sig_externalstop"
  Memory.Free "sig_timerend"
  Memory.Free "Tray_Array"
  Memory.Endurance_InProgress = 0
  
  Visual.Select("sel_cassette_bottom").Disabled = False
  Visual.Select("sel_cassette_top").Disabled = False
  'Else If Not Memory.Exists("sig_externalstop") Then
  Else
    LogAdd "Endurance Run already running!"
  'End If Not Memory.Exists("sig_externalstop") Then
  End If

End Function
'------------------------------------------------------------------
Function Stop_EnduranceRun( )
  If Memory.Exists("sig_externalstop") Then
    Memory.sig_externalstop.Set
  Else
    LogAdd "No Endurance run to stop."
  End If
  
  Timer_Handler TIMER_STOP,0 
End Function
'------------------------------------------------------------------
Function FormatTimeString( Var_Time )
  FormatTimeString = String.Format("%02d:%02d:%02d", Hour(Var_Time), Minute(Var_Time), Second(Var_Time))
End Function
'------------------------------------------------------------------
'Function to obtain a list with currently checked trays
Function GetTrayListOld (test)
  Dim lvl_counter
  Dim string_chkbox_sel
  Dim Tray_Array
  Set Tray_Array = CreateObject( "MATH.Array" )


  'determine which trays are selected. Trays 1 - 18
  For lvl_counter = 1 to 18
    string_chkbox_sel = "chk_lvl" & String.Format("%02d",lvl_counter)
    'DebugMessage string_chkbox_sel
    If Visual.Select(string_chkbox_sel).Checked Then
      Tray_Array.Add(lvl_counter)
      DebugMessage "Level "&lvl_counter &" is checked"
      'there is at least one selected tray
    End If
  Next
  
  'if there are no checked boxes, then set as invalid
  If Tray_Array.Size = 0 Then
    GetTrayList = False
    DebugMessage "No Trays Selected for Endurance Run"
  Else
    DebugMessage "Total Trays Selected: "&Tray_Array.Size
    GetTrayList = True
  End If
  
  Memory.Set "Tray_Array",Tray_Array

End Function


'------------------------------------------------------------------

Function OnChange_sel_cassette_bottom (Reason )
  'Allow change only if no endurance run in progress
  If Memory.Endurance_InProgress = 0 Then
    GetTrayList
  End If
End Function 

'------------------------------------------------------------------
Function OnChange_sel_cassette_top (Reason )
  'Allow change only if no endurance run in progress
   If Memory.Endurance_InProgress = 0 Then
    GetTrayList
  End If
End Function 

'------------------------------------------------------------------

Function GetTrayList ( )
  Dim lvl_counter  
  Dim Tray_Array
  Set Tray_Array = CreateObject( "MATH.Array" )
  Dim Loop_Cnt
  Dim stringtemp
  Dim Total_Level
  Dim TraySelectedMsg
 
 
  TraySelectedMsg = "Trays selected: " 
  'Bottom Cassette
  lvl_counter = String.SafeParse(Visual.Select("sel_cassette_bottom").SelectedItemAttribute("Value"))
  Total_Level = lvl_counter
  For Loop_Cnt = 1 to lvl_counter
    stringtemp = "chk_lvll_" & string.format("%01d",Loop_Cnt)
    Visual.Select(stringtemp).Value = Loop_Cnt
    'DebugMessage "level enable " & Loop_Cnt & " " & stringtemp & " " & Loop_Cnt
    If Visual.Select(stringtemp).Checked Then
      Tray_Array.Add(Loop_Cnt)
      TraySelectedMsg = TraySelectedMsg & Loop_Cnt &  " "
    End If
    stringtemp = "bottom_" & string.format("%01d",Loop_Cnt)    
    Visual.Select(stringtemp).Style.Display = "block"
  Next
  
  For Loop_Cnt = lvl_counter + 1 to 9
  stringtemp = "bottom_" & string.format("%01d",Loop_Cnt)
  Visual.Select(stringtemp).Style.Display = "None"
  'DebugMessage "level disabled" & Loop_Cnt & " " & stringtemp & " " & Loop_Cnt
  Next
  
  'Top Cassette
  lvl_counter = String.SafeParse(Visual.Select("sel_cassette_top").SelectedItemAttribute("Value"))

  For Loop_Cnt = 1 to lvl_counter
    stringtemp = "chk_lvlh_" & string.format("%01d",Loop_Cnt)
    Visual.Select(stringtemp).Value = Loop_Cnt + Total_Level   
    'DebugMessage "level enable " & Loop_Cnt & " " & stringtemp & " " & Loop_Cnt+Total_Level
    If Visual.Select(stringtemp).Checked Then
      Tray_Array.Add(Loop_Cnt+Total_Level)
      TraySelectedMsg = TraySelectedMsg & Loop_Cnt+Total_Level & " "
    End If
    stringtemp = "top_" & string.format("%01d",Loop_Cnt)    
    Visual.Select(stringtemp).Style.Display = "block"
  Next
  
  For Loop_Cnt = lvl_counter + 1 to 9
      stringtemp = "top_" & string.format("%01d",Loop_Cnt)
      Visual.Select(stringtemp).Style.Display = "None"
      'DebugMessage "level disabled" & Loop_Cnt & " " & stringtemp & " " & Loop_Cnt+Total_Level
  Next
    
  DebugMessage "Total Levels " & String.SafeParse(Visual.Select("sel_cassette_top").SelectedItemAttribute("Value")) + String.SafeParse(Visual.Select("sel_cassette_bottom").SelectedItemAttribute("Value"))
  DebugMessage TraySelectedMsg
    'if there are no checked boxes, then set as invalid
  If Tray_Array.Size = 0 Then
    GetTrayList = False
    'DebugMessage "No Trays Selected for Endurance Run"
  Else
    DebugMessage "Total Trays Selected: "&Tray_Array.Size
    GetTrayList = True
  End If
  Memory.Set "Tray_Array",Tray_Array
End Function

'------------------------------------------------------------------
Function FreeTrayList
  Dim Tray_Array
  Memory.Get "Tray_Array",Tray_Array
  Set Tray_Array = Nothing
  Memory.Free "Tray_Array"
  
End Function
'------------------------------------------------------------------
Function GetNextSequentialTray (ByVal CurrTray,ByRef NextTray)
  Dim Tray_Array 
  Dim tray_found
  Dim Loop_Exit
  Dim counter,element_processed
  Memory.Get "Tray_Array",Tray_Array

  tray_found = 0
  element_processed = 0
  Loop_Exit = 0
  'DebugMessage "CurrentTray"&CurrTray & " ArraySize" & Tray_Array.Size
'  For counter = 0 to Tray_Array.Size - 1
'    DebugMessage Tray_Array.Data(counter)
'  Next
  Do While Loop_Exit = 0
    For counter = 0 to Tray_Array.Size - 1
      If tray_found = 1 Then
        NextTray = Tray_Array.Data(counter)
        Loop_Exit = 1
        'DebugMessage "Next Tray:" & NextTray& ". Exiting Loop"
        Exit For
      'Tray found in previous loop
      Else
        'Search for current tray
        If Tray_Array.Data(counter) = CurrTray Then
        'Correct Tray is found
          tray_found = 1
          'DebugMessage "Tray "&CurrTray&" found at "&counter
        End If
      End If
    element_processed = element_processed + 1
    'End For Loop    
    Next
  'End While loop 
  If element_processed > Tray_Array.Size + 1 Then
    Loop_Exit = 1
    DebugMessage "Tray Not Found!!"
  End If

  Loop     
End Function

'-------------------------------------------------------

Function GetNextRandomTray( ByVal CurrTray, ByRef NextTray )
  Dim Tray_Array
  Dim NewTray
  Memory.Get "Tray_Array",Tray_Array

  NewTray = CurrTray
  
  Do 
    Randomize
    NewTray  = Int(Rnd * (Tray_Array.Size ))
  Loop Until Not Tray_Array.Data(NewTray) = CurrTray
  NextTray = Tray_Array.Data(NewTray)
  'DebugMessage "New Tray: " & NextTray

End Function

'-------------------------------------------------------

Function Timer_Handler ( StartStop , TimeOut )
	If StartStop = 1 Then
    If Not Memory.Exists("sig_TimerStop") Then
      'DebugMessage "Timer Start"		
		  System.Start "Timer", TimeOut
    Else
      DebugMessage "Timer already started"
      If Memory.Exists("sig_timerend") Then
        Memory.sig_timerend.Set
      End If
		End if
	Else
   
		If Memory.Exists("sig_TimerStop") Then
	  	Memory.sig_TimerStop.Set
      'DebugMessage "Timer Stop"
    Else
      DebugMessage "Timer already Stopped"
		End If
    
		Do While Memory.Exists("sig_TimerStop") = True
			System.Delay(100)
		Loop
	End If
End Function

'-------------------------------------------------------

Function Timer( TimeOut )
  Dim sig_TimerStop
  Dim ls_loopcont
  Dim count,start_time,stop_time,now_time

  Set sig_TimerStop = Signal.Create

  Memory.Set "sig_TimerStop", sig_TimerStop
  'DebugMessage "Timer Started"

  ls_loopcont = 1
  start_time = Time
  LogAdd "Timer:Start Time :" & FormatTimeString(start_time)
  DebugMessage "Timer:Start Time :" & FormatTimeString(start_time)
 
  Do while ls_loopcont = 1

    now_time = (Time - start_time)
    count = Hour(now_time)*3600 + Minute(now_time)*60 +Second(now_time)
    'Visual.Select("timer_elapsed").Value = count

    If sig_TimerStop.wait(50) Then
      ls_loopcont = 0
    End If

    If count >= TimeOut AND NOT TimeOut=0 Then
      ls_loopcont = 0
    End If
  Loop
  stop_time = Time
  DebugMessage "Timer:End Time :" & FormatTimeString(stop_time)
  'Visual.Select("timer_end").Value =  FormatTimeString(stop_time)

  If Memory.Exists("sig_timerend") Then
    Memory.sig_timerend.Set
    'DebugMessage "Memory Set sig_timerend"
  End If

  If Memory.Exists("sig_TimerStop") Then
    Memory.Free "sig_TimerStop"
    'DebugMessage "Memory Free sig_TimerStop"
  End If

End Function

'-------------------------------------------------------

Function Handle_TrayExchangeTiming ( NewTiming )

  Visual.Select("textTEx_current").Value = NewTiming
  If NewTiming < Visual.Select("textTEx_min").Value Then
    Visual.Select("textTEx_min").Value = NewTiming
  End If
  If NewTiming > Visual.Select("textTEx_max").Value Then
    Visual.Select("textTEx_max").Value = NewTiming
  End If

  If NewTiming <= 4750 Then
    Visual.Select("textTEx_cntlow").Value = Visual.Select("textTEx_cntlow").Value + 1
  End If

  If NewTiming > 4750 Then
    Visual.Select("textTEx_cnthigh").Value =  Visual.Select("textTEx_cnthigh").Value + 1
  End If
End Function