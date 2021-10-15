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

 FlyRandom 随机数生成器 主程序文件
 2019-2021 Copyright Powered by HenryJiu , under GPL-3.0 License.
 GitHub:https://github.com/FlyRandom/FlyRandom/
 WebSite:https://flr.thanker.top/
#ce

;引入各类函数库
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <FontConstants.au3>
#include <File.au3>
#include <Process.au3>
#include <Excel.au3>
#include <FileConstants.au3>
#include <AutoItConstants.au3>
#include <InetConstants.au3>
#include <Array.au3>
#include <Crypt.au3>
#include "GuiFlatButton.au3"
#include "FlyRandom_UDF.au3" ;引入FlyRandom的函数库
DllCall("user32.dll", "BOOL", "SetProcessDPIAware") ;适配Win10的高DPI
;Flr_Update() ;调用更新检测函数

;注销这堆无用的鬼东西
Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)
Opt("TrayAutoPause", 0)

FileInstall("Flr_Log.log", @ScriptDir & "\" & "Flr_Log.log") ;包含Log

;Script Start
;创建GUI
$Form1 = GUICreate("FlyRandom", 556, 338, -1, -1, $WS_POPUP)
GUISetFont(14 * _GDIPlus_GraphicsGetDPIRatio()[0], 400, 0, "微软雅黑")
GuiFlatButton_SetDefaultColors(0x000000, 0xffe99c, 0xffe99c)
GUISetBkColor(0x000000)
$Label6 = GUICtrlCreateLabel("x", 528, -15, 21, 47)
GUICtrlSetFont(-1, 25, 400, 0, "微软雅黑")
GUICtrlSetColor(-1, 0xffe99c)
$Label7 = GUICtrlCreateLabel("-", 496, -15, 18, 47)
GUICtrlSetFont(-1, 25, 400, 0, "微软雅黑")
GUICtrlSetColor(-1, 0xffe99c)
GUICtrlCreateGraphic(0, 33, 687, 5, -1)
GUICtrlSetColor(-1, "0xffe99c")
GUICtrlSetBkColor(-1, "0xffe99c")
GUICtrlCreateLabel("FlyRandom", 10, 0, 664, 35, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetFont(-1, 16 * _GDIPlus_GraphicsGetDPIRatio()[0], 450, 0, "微软雅黑")
GUICtrlSetColor(-1, "0xffe99c")
GUICtrlSetBkColor(-1, "-2")
GUISetFont(14 * _GDIPlus_GraphicsGetDPIRatio()[0], 400, 0, "微软雅黑")
$Input3 = GUICtrlCreateInput("1", 32, 48 + 38, 185, 30)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, "0xffe99c")
$Label1 = GUICtrlCreateLabel("最小值：", 8, 8 + 38, 100, 26)
GUICtrlSetColor(-1, 0xffe99c)
$Input2 = GUICtrlCreateInput("50", 336, 48 + 38, 185, 30)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, "0xffe99c")
$Button1 = GuiFlatButton_Create("生成", 400, 208 + 38, 121, 65)
GUICtrlSetColor(-1, 0xffe99c)
$Label2 = GUICtrlCreateLabel("最大值：", 272, 8 + 38, 100, 26)
GUICtrlSetColor(-1, 0xffe99c)
$Label3 = GUICtrlCreateLabel("欢迎使用FlyRandom！请先阅读帮助文档再使用！", 80, 88 + 38, -1, 26)
GUICtrlSetColor(-1, 0xffe99c)
$Input4 = GUICtrlCreateInput("5", 320, 240 + 38, 65, 30)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetColor(-1, "0xffe99c")
$Label5 = GUICtrlCreateLabel("数字个数", 305, 208 + 38, -1, -1)
GUICtrlSetColor(-1, 0xffe99c)
$Button2 = GuiFlatButton_Create("更多设置", 32, 130 + 38, 121, -1)
$Button3 = GuiFlatButton_Create("关于程序", 400, 130 + 38, 121, -1)
GUISetState(@SW_SHOW)

;开始响应GUI事件
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Label7, $gui_event_minimize ;最小化窗口
			DllCall("User32.dll", "BOOL", "CloseWindow", "hWnd", $form_main) ;调用DLL
		Case $Button2
			Flr_Setting() ;进入设置函数
		Case $Button3 ;弹出关于消息框
			MsgBox(262208, "关于FlyRandom", "FlyRandom 随机数生成器" & @CRLF & "Copyright 2019-2021 Powered by HenryJiu . All rights reserved." & @CRLF & "GitHub主页：https://github.com/FlyRandom/FlyRandom/", 0)
		Case $GUI_EVENT_CLOSE, $Label6 ;关闭程序
			Exit
		Case $Button1
			$iBigNun = GUICtrlRead($Input2) ;最大值
			$iBigNunS = StringIsDigit($iBigNun) ;最大值数字检测
			$iLitNun = GUICtrlRead($Input3) ;最小值
			$iLitNunS = StringIsDigit($iLitNun) ;最小值数字检测
			Global $iExecutionNun = GUICtrlRead($Input4) ;Input4是要生成的个数
			$iExecutionNunS = StringIsDigit($iExecutionNun)
			;开始苦逼的数据错误判断弹窗
			If Not $iBigNunS = 1 Then
				MsgBox(16, "错误", "您输入了非数字！" & @CRLF & "请保证您输入的最大值是阿拉伯数字" & @CRLF & "比如50，而不是五十！", 10)
				ContinueCase
			EndIf
			If Not $iLitNunS = 1 Then
				MsgBox(16, "错误", "您输入了非数字！" & @CRLF & "请保证您输入的最小值是阿拉伯数字" & @CRLF & "比如50，而不是五十！", 10)
				ContinueCase
			EndIf
			If Not $iExecutionNunS = 1 Then
				MsgBox(16, "错误", "您输入了非数字！" & @CRLF & "请保证您输入的抽查个数是阿拉伯数字" & @CRLF & "比如50，而不是五十！", 10)
				ContinueCase
			EndIf
			If $iBigNun < $iLitNun Or $iBigNun = $iLitNun Then
				MsgBox(16, "错误！", "您输入的最大值小于或等于最小值！无法运算！", 0)
				ContinueCase
			EndIf
			If $iBigNun - $iLitNun < $iExecutionNun Then
				MsgBox(16, "错误！", "您输入的抽查个数大于最大值减最小值！无法抽查！", 0)
				ContinueCase
			EndIf
			;当抽查个数是1时，进入滚动抽查模式
			If $iExecutionNun == 1 Then
				Flr_OneRun()
				ContinueCase
			EndIf
			;开始循环
			$iExecutionNun = $iExecutionNun - 1
			Global $aNun[0]
			Global $NoNunNo = ""
			Global $LogIni = ""
			For $iExecutionNun = $iExecutionNun To 0 Step -1
				FlrRandomNum();进入函数
			Next
			$OutPutNunN = GUICtrlRead($Input4) ;重新读取，避免问题
;~ 			$ReadService = IniRead(@ScriptDir & "\Flr_Info.flr", "Flr_Info", "ServiceUrl", "https://0.0.0.0")
;~ 			$InetRead = BinaryToString(InetRead($ReadService & "/api/Get/?Service=FlrClient_ServiceConnect", 1))
;~ 			If $InetRead = "FlrService_ConsentConnect" Then
;~ 				$InetReadPost = BinaryToString(InetRead($ReadService & "/api/Post/?Log=计算机名称：" & @ComputerName & " 输出结果：" & $LogIni))
;~ 				If $InetReadPost = "Flr_ServiceWriteError" Then
;~ 					MsgBox(262160, "错误！", "服务器写入日志失败！", 5)
;~ 				EndIf
;~ 			Else
;~ 				MsgBox(262160, "错误！", "无法连服务器！将直接显示结果", 5)
;~ 			EndIf
			_ArrayAdd($aNun, "输出结果！数字个数：" & $OutPutNunN) ;添加输出的最后一行
			_FileWriteLog(@ScriptDir & "\" & "Flr_Log.log", "[Info] " & "此次生成： " & $LogIni) ;写入Log
			_ArrayDisplay($aNun, "FlyRandom", "", 8 + 64) ;弹出输出窗口
	EndSwitch
WEnd
