#cs
 *                    _ooOoo_
 *                   o8888888o
 *                   88" . "88
 *                   (| -_- |)
 *                    O\ = /O
 *                ____/`---'\____
 *              .   ' \\| |// `.
 *               / \\||| : |||// \
 *             / _||||| -:- |||||- \
 *               | | \\\ - /// | |
 *             | \_| ''\---/'' | |
 *              \ .-\__ `-` ___/-. /
 *           ___`. .' /--.--\ `. . __
 *        ."" '< `.___\_<|>_/___.' >'"".
 *       | | : `- \`.;`\ _ /`;.`/ - ` : | |
 *         \ \ `-. \_ __\ /__ _/ .-` / /
 * ======`-.____`-.___\_____/___.-`____.-'======
 *                    `=---='
 *
 * .............................................
 *          佛祖保佑             永无BUG
 
 FlyRandom 随机数生成器 函数库文件
 2019-2021 Copyright Powered by HenryJiu , under GPL-3.0 License.
 GitHub:https://github.com/FlyRandom/FlyRandom/
 WebSite:https://flr.thanker.top/
#ce


;Add Function
Func Flr_Ini_Read()
	$IniFile = FileOpenDialog("选择列表文件", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "文本文档 (*.txt)", BitOR(1, 8))
	If $IniFile = "" Then
		MsgBox(262160, "错误 FlyRandom", "您并未选择文件！", 10)
		Return
	EndIf

	$IniFileOpen = FileOpen($IniFile)
	Global $FileArray
	$FileArray = FileReadToArray($IniFileOpen)
	Global $WriteIniNun = UBound($FileArray, $UBOUND_ROWS)
	If IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", "FlrNoFound") == "FlrNoFound" Then
		FileDelete(@ScriptDir & "\Flr_Info.flr")
	Else
		$Get_pwd = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", "FlrNoFound")
		FileDelete(@ScriptDir & "\Flr_Info.flr")
		IniWrite(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", $Get_pwd)
	EndIf
	For $WriteIniNun = UBound($FileArray, $UBOUND_ROWS) To 1 Step -1
		IniWrite(@ScriptDir & "\Flr_Info.flr", "Flr_List", $WriteIniNun, _ArrayPop($FileArray))
	Next
	Global $WriteIniNun = UBound($FileArray, $UBOUND_ROWS)
	MsgBox(262208, "信息 FlyRandom", "已执行配置文件导入工作！" & @CRLF & "文件已经导入与程序同目录下的Flr_Info.flr文件中" & @CRLF & "此配置一直有效，如果您想要恢复输出数字或更改配置文件，请您重新导入或直接删除该配置文件", 10)
	Return
EndFunc   ;==>Flr_Ini_Read

Func Flr_ErrorLog()
	If Not @error = 0 Then
		$FlieError = _FileWriteLog(@ScriptDir & "\" & "Flr_Log.log", "[Error] " & "出现未知错误！")
	EndIf
EndFunc   ;==>Flr_ErrorLog
AdlibRegister("Flr_ErrorLog")

Func _GDIPlus_GraphicsGetDPIRatio($iDPIDef = 96)
	_GDIPlus_Startup()
	Global $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If @error Then Return SetError(1, @extended, 0)
	Global $aResult
	#forcedef $__g_hGDIPDll, $ghGDIPDll

	$aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)

	If @error Then Return SetError(2, @extended, 0)
	Global $iDPI = $aResult[2]
	Global $aresults[2] = [$iDPIDef / $iDPI, $iDPI / $iDPIDef]
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_Shutdown()
	Return $aresults
EndFunc   ;==>_GDIPlus_GraphicsGetDPIRatio

Func FlrRandomNum()
	For $ForRandom = 0 To 1 Step 0
		$Random = Random($iLitNun, $iBigNun, 1)
		$StringInStr = StringInStr($NoNunNo, $Random)
		If $StringInStr = 0 Then
			ExitLoop
		EndIf
	Next
	$NoNunNo = $NoNunNo & " " & $Random
	$CheakIni = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_List", 1, "NoFound")
	If $CheakIni = "NoFound" Then
		_ArrayAdd($aNun, $Random)
	Else
		$NameRead = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_List", $Random, "NoFound")
		If $NameRead = "NoFound" Then
			FlrRandomNum()
			Return
		EndIf
		$LogIni = $LogIni & " " & $NameRead
		_ArrayAdd($aNun, $NameRead)
		Return

	EndIf
EndFunc   ;==>FlrRandomNum

Func Flr_Setting()
	If IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", "FlrNoFound") == "FlrNoFound" Then
		$Set_pwd = InputBox("FlyRandom 设置管理员密码", "请输入新的管理员密码", "", "*")
		$Set_pwd_ag = InputBox("FlyRandom 设置管理员密码", "请再次输入新的管理员密码", "", "*")
		If $Set_pwd == $Set_pwd_ag Then
			$Write_New_pwd = IniWrite(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", _Crypt_HashData($Set_pwd_ag, $CALG_SHA_512))
			If $Write_New_pwd == 1 Then
				MsgBox(262208, "FlyRandom 成功！", "成功写入密码！", 0)
				Return 0
			EndIf
		Else
			MsgBox(16, "FlyRandom 错误！", "两次输入的密码不相同！请重新尝试", 0)
			Return 0
		EndIf
	Else
		$Unlock_Setting = InputBox("FlyRandom 解锁管理员设置", "请输入管理员密码", "", "*")
		If _Crypt_HashData($Unlock_Setting, $CALG_SHA_512) == IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", "NoFound") Then

		ElseIf _Crypt_HashData($Unlock_Setting, $CALG_SHA_512) <> IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", "NoFound") Then
			MsgBox(262160, "FlyRandom 错误！", "密码错误！请检查并重新输入！", 0)
			Return 0
		EndIf
	EndIf
	$Setting_GUI = GUICreate("FlyRandom 设置", 738, 141, -1, -1, -1, -1)
	GUISetBkColor(0xf7f7f7, $Setting_GUI)
	$Setting_GUI_Button1 = GUICtrlCreateButton("加载抽查名单", 31, 30, 193, 70, -1, -1)
	GUICtrlSetFont(-1, 12, 400, 0, "微软雅黑 Light")
	$Setting_GUI_Button2 = GUICtrlCreateButton("设置管理员密码", 272, 30, 193, 70, -1, -1)
	GUICtrlSetFont(-1, 12, 400, 0, "微软雅黑 Light")
	$Setting_GUI_Button3 = GUICtrlCreateButton("设置远程服务器", 515, 30, 193, 70, -1, -1)
	GUICtrlSetFont(-1, 12, 400, 0, "微软雅黑 Light")
	GUISetState(@SW_SHOW, $Setting_GUI)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Setting_GUI)
				Return 0
			Case $Setting_GUI_Button1
				Flr_Ini_Read()
			Case $Setting_GUI_Button2
				$Set_pwd = ""
				$Set_pwd = InputBox("FlyRandom 设置管理员密码", "请输入新的管理员密码", "", "*")
				$Set_pwd_ag = InputBox("FlyRandom 设置管理员密码", "请再次输入新的管理员密码", "", "*")
				If $Set_pwd == $Set_pwd_ag Then
					$Write_New_pwd = IniWrite(@ScriptDir & "\Flr_Info.flr", "Flr_Setting", "pwd", _Crypt_HashData($Set_pwd_ag, $CALG_SHA_512))
					If $Write_New_pwd == 1 Then
						If $Set_pwd_ag == "" Then
							MsgBox(262208, "FlyRandom 成功！", "成功写入空密码！", 0)
							Return 0
						Else
							MsgBox(262208, "FlyRandom 成功！", "成功写入密码！", 0)
							Return 0
						EndIf
					EndIf
				Else
					MsgBox(16, "FlyRandom 错误！", "两次输入的密码不相同！请重新尝试", 0)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>Flr_Setting

Func Flr_OneRun()
	$Random_GUI = GUICreate("FlyRandom 生成", 576, 248, -1, -1, $WS_POPUP, -1)
	GUISetBkColor(0x000000, $Random_GUI)
	$Random_GUI_Graphic = GUICtrlCreateGraphic(0, 33, 743, 5, -1)
	GUICtrlSetColor(-1, "0xffe99c")
	GUICtrlSetBkColor(-1, "0xffe99c")
	$Random_GUI_Label1 = GUICtrlCreateLabel("FlyRandom 生成", 10, 0, 500, 35, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, 13, 450, 0, "微软雅黑")
	GUICtrlSetColor(-1, "0xffe99c")
	GUICtrlSetBkColor(-1, "-2")
	$Random_GUI_Label2 = GUICtrlCreateLabel("x", 547, -14, 24, 46, -1, -1)
	GUICtrlSetFont(-1, 25, 400, 0, "微软雅黑")
	GUICtrlSetColor(-1, "0xffe99c")
	GUICtrlSetBkColor(-1, "-2")
	Global $Random_GUI_Label3 = GUICtrlCreateLabel("随机数", 64, 52, 507, 155, -1, -1)
	GUICtrlSetFont(-1, 67, 400, 0, "微软雅黑")
	GUICtrlSetColor(-1, "0xffe99c")
	GUICtrlSetBkColor(-1, "-2")
	GUISetState(@SW_SHOW, $Random_GUI)
	AdlibRegister("Flr_OneRunCore", 50)
	Sleep(6000)
	AdlibUnRegister("Flr_OneRunCore")
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $Random_GUI_Label2
				GUIDelete()
				Return 0
		EndSwitch
	WEnd
EndFunc   ;==>Flr_OneRun

Func Flr_OneRunCore()
	$Random = Random($iLitNun, $iBigNun, 1)
	$CheakIni = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_List", 1, "NoFound")
	If $CheakIni = "NoFound" Then
		GUICtrlSetData($Random_GUI_Label3, $Random)
		Return 0
	Else
		$NameRead = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_List", $Random, "NoFound")
		If $NameRead = "NoFound" Then
			Return
		EndIf
		GUICtrlSetData($Random_GUI_Label3, $NameRead)
		Return
	EndIf
EndFunc   ;==>Flr_OneRunCore

;~ Func Flr_Update()
;~ 	Local $dData = InetRead("https://cdn.jsdelivr.net/gh/FlyRandom/update@latest/update.json", $INET_FORCERELOAD +  $INET_FORCEBYPASS )
;~ 	$dDataOut = BinaryToString($dData)
;~ 	If $dDataOut = "3.0.0" Then
;~ 		Return 0
;~ 	ElseIf $dDataOut == "" Then 
;~ 		Return 0
;~ 	Else
;~ 		MsgBox(48 + 262144, "FlyRandom 更新检测", "有新版本需要更新！" & @CRLF & "当前版本号：" & "3.0.0" & @CRLF & "最新版本号：" & $dDataOut & @CRLF & "请注意比较版本号大小，避免向后更新！" & @CRLF & "请前往官网https://flr.thanker.top/获取最新版！" & @CRLF & "按确定键继续使用")
;~ 		Return
;~ 	EndIf
;~ EndFunc
