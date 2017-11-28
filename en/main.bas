'----------------------------------------------------------------------------
'--                                                                          --
'--     Project:        Caccia                                               --
'--                                                                          --
'--     Department:     Platform Motion Control & Tools                      --
'--                                                                          --
'--     Author:         Robert Steiner                                       --
'--                                                                          --
'--     Contact:        +49-(0)89-20800-58841                                --
'--                     SteinerRobert@asmpt.com                              --
'--                                                                          --
'------------------------------------------------------------------------------
'--                                                                          --
'--    This source file is protected by copyright law and international      --
'--   treaties. Unauthorized modification, reproduction or distribution,     --
'-- or any portion of it, may result in severe civil and criminal penalties, --
'--   and will be prosecuted to the maximum extent possible under the law.   --
'--                                                                          --
'------------------------------------------------------------------------------
'--                                                                          --
'--          If this code works, it was written by Robert Steiner.           --
'--                  If not, I don't know who wrote it ;-)                   --
'--                                                                          --
'------------------------------------------------------------------------------
'--                                                                          --
'-- Copyright (C) ASM Assembly Systems GmbH & Co. KG                         --
'-- Platform Motion Control & Tools 2000-2014 Munich. All Rights Reserved.   --
'--                                                                          --
'----------------------------------------------------------------------------*/

'Todo: Stop endurance run when error occured. Copy from Tesla Module.
Option Explicit
#include <Can.bas>
#include <PTKL_c.h>
#include <PTKL_be.h>
#include "Ptkl_jtf.h"
#include "Ptkl_f.h"
#include <SubCommon.bas>
#include <System.bas>
#include "can.bas"
#include "Commands.bas"
#include "DebugLog.bas"
#include "Tab_Commands.bas"
#include "Tab_AxisControl.bas"
#include "Tab_IOs.bas"
#include "Tab_Endurance.bas"
#include "Tab_Debug.bas"
'------------------------------------------------------------------
' Globals
'------------------------------------------------------------------

'------------------------------------------------------------------
' Constants
'------------------------------------------------------------------

Const APP_WIDTH = 800
Const APP_HEIGHT = 620
Const AppVersionMax = 00
Const AppVersionMin = 01
Const MAX_LOG_ROWS = 100


'------------------------------------------------------------------
' Window Init Functions
'------------------------------------------------------------------
Sub OnLoadFrame()

  Window.height = APP_HEIGHT
  Window.width = APP_WIDTH
  Init_Globals
  Init_Window_IO
  Init_Window_Command
  Init_Window_AxisControl
  Init_Window_Test

  'CreateDebugLogWindow
  Visual.Script("win").attachEvent "onClose" , Lang.GetRef( "btn_CanConnect" , 1)
  StartIOThread 0

End Sub
'------------------------------------------------------------------
Sub OnUnloadFrame()
  StartIOThread 0
  StartIOPolling 0 
  Stop_EnduranceRun
End Sub
'------------------------------------------------------------------

Sub OnReloadFrame()
  StartIOThread 0
  StartIOPolling 0 
  Stop_EnduranceRun
End Sub

'------------------------------------------------------------------
' Supporting functions
'------------------------------------------------------------------
Function LogAdd ( sMessage )
  Dim Gridobj
  Set Gridobj = Visual.Script("LogGrid")
  Dim MsgId
  MsgId = Gridobj.uid()
  If NOT(sMessage = "") Then
    Gridobj.addRow MsgId, ""& FormatDateTime(Date, vbShortDate) &","& FormatDateTime(Time, vbShortTime)&":"& String.Format("%02d ", Second(Time)) &","& sMessage,0
    If Gridobj.getRowsNum() > MAX_LOG_ROWS Then
      Gridobj.selectRow MAX_LOG_ROWS, FALSE, FALSE, FALSE
      Gridobj.deleteSelectedRows
    End If
    'Wish of SCM (automatically scroll to newest Msg)
    Gridobj.showRow( MsgId )
  End If  
  'DebugMessage sMessage
End Function

'------------------------------------------------------------------
Sub OnClick_ButtonGridClear( Reason )
  Visual.Script( "LogGrid").clearAll()
End Sub
'------------------------------------------------------------------

Function OnClick_ButtonDebugLog( Reason )
  If Memory.Exists("DebugLogWindow") Then
    DebugWindowClose
    Visual.Select("ButtonDebugLog").Value = "Open DebugLog"
    Visual.Script("tabbar").hideTab("main_tab5")
    Visual.Script("tabbar").setTabActive("main_tab1")
  Else 
    CreateDebugLogWindow
    Visual.Select("ButtonDebugLog").Value = "Close DebugLog"
    Visual.Script("tabbar").showTab("main_tab5")
    
  End If
End Function

Function Init_Globals
  Dim PrepCmd_Inprogress,PrepCmd_Error,PrepCmd_PrepID
  Dim Endurance_Inprogress
  PrepCmd_Inprogress = 0
  Endurance_Inprogress = 0
  PrepCmd_Error = 0
  PrepCmd_PrepID = 1
  Memory.Set "PrepCmd_Inprogress",PrepCmd_Inprogress
  Memory.Set "PrepCmd_Error",PrepCmd_Error
  Memory.Set "Endurance_Inprogress",Endurance_Inprogress
  Memory.Set "PrepCmd_PrepID",PrepCmd_PrepID


End Function
