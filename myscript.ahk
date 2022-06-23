;Notes: #==win !==Alt  ^==Ctr  +==shift
; 快速启动微信      Ctrl + k
; 文件的全路径      CTRL+Alt+鼠标左键
; 获取当前鼠标颜色  Alt + 鼠标左键
; 当前目录打开终端  Ctrl+鼠标右键 
; 快速创建文件      Alt + 鼠标右键

F11::exitapp

; 获取鼠标位置窗口ahk_class
getClassName(){
    MouseGetPos, , , id, control
    WinGetClass, class, ahk_id %id%
    MsgBox,"%class%".
    return class
}

; 快速启动微信
^k::
Run, C:\Program Files (x86)\Tencent\WeChat\WeChat.exe
Return

; 微信轰炸
#IfWinActive ahk_exe C:\Program Files (x86)\Tencent\WeChat\WeChat.exe
^l::
InputBox, OutputVar,确认提示,您希望把剪切板的内容发送的次数是多少?,,230,150
; 遇到问题则 ErrorLevel 被设置为 1, 否则为 0.
if ErrorLevel
  Return
  ; MsgBox, CANCEL was true.
else
Send,{Enter up}
Loop %OutputVar%
{
  KeyWait Enter,U
  SendInput, ^v
  Sleep,100
  Send,{Enter}
}
Return

#IfWinActive

; 添加内容到剪切板
^p::
Clipboard =<div class="row"></div>;
Send ^v
Return


; 打开网页
^m::
Run,https://fanyi.youdao.com/
ToolTip,测试打开网页
Sleep, 3000
ToolTip,
Return

; 按下CTRL+Alt+鼠标左键就可以拿到文件的全路径了
^!LButton::
Send ^c
Sleep,200
Clipboard=%clipboard%
ToolTip,路径已复制：%clipboard%
sleep,500
ToolTip,
return

; 获取鼠标颜色
!LButton::
; 获得鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
MouseGetPos, mouseX, mouseY
; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
PixelGetColor, color, %mouseX%, %mouseY%, RGB
; 截取 color（第二个 color）右边的6个字符，因为获得的值是这样的：0x02213D，一般我们只需要 02213D 部分。把截取到的值再赋给 color（第一个 color）。
StringRight color,color,6
; 把 color 的值发送到剪贴板
Clipboard = #%color%
ToolTip,已复制当前鼠标的十六进制的颜色
Sleep,500
ToolTip,
return


; Ctrl+鼠标右键 在当前目录打开cmd
^RButton::
Process,Exist,explorer.exe
if (%ErrorLevel% != 0){
    if WinActive("ahk_class CabinetWClass"){
        path := getExplorerPath()
        Run ,PowerShell -noexit -command Set-Location -literalPath %path%
        ; MsgBox, 成功打开%path%,的终端
        return
    }
    ; 桌面
    if (WinActive("ahk_class WorkerW") or WinActive("ahk_class Progman") ){
        Run ,PowerShell -noexit -command Set-Location -literalPath %A_Desktop%
        return
    }
}

;  Alt +鼠标右键快速创建文件
!RButton::
Process,Exist,explorer.exe
if (%ErrorLevel% != 0){
    if WinActive("ahk_class CabinetWClass"){
        path := getExplorerPath()
        InputBox, OutputVar,确认提示,您想在%path%下新建的文件名称为?,,265,150
        if (%ErrorLevel% == 0){
          FileAppend, , %path%\%OutputVar%
        }
        return
    }
    ; 桌面
    if (WinActive("ahk_class WorkerW") or WinActive("ahk_class Progman") ){
        InputBox, OutputVar,确认提示,您想在桌面下新建的文件名称为?,,265,150
        if (%ErrorLevel% == 0){
          FileAppend, , %A_Desktop%\%OutputVar%
        }
        return
    }
}

; 获取当前路径的函数
getExplorerPath(){
    IfWinExist, ahk_class CabinetWClass
    {
        ControlGetText,address,ToolbarWindow323,ahk_class CabinetWClass
        StringLen, length, address
        StringRight, path, address, length-4
        return path
    }
    return
}