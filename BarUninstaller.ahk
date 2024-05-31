; Script     BarUninstaller.ahk
; License:   MIT License
; Author:    Bence Markiel (bceenaeiklmr)
; Github:    https://github.com/bceenaeiklmr/BarUninstaller
; Date       31.05.2024
; Version    0.1.0
#Requires AutoHotkey >=2.0
#Warn All

; Disclaimer:
; this script is not affiliated with or endorsed by Microsoft.
; It is provided "as is" without any warranties, express or implied. Use at your own risk.

Remover := AppxPackageRemover("Microsoft.XboxGameOverlay", "Microsoft.XboxGamingOverlay")

; Execute a PowerShell command and return its output
shellExecCommand(cmd) {
    return ComObject("WScript.Shell").Exec("powershell.exe -c " cmd).StdOut.ReadAll()
}

; Restart the script with admin privileges if not already running as admin
runAsAdmin() {
    local path, params := ""
    ; Get the command line arguments
    loop A_Args.Length
        params .= A_Space A_Args[A_Index]
    ; Get the full command line
    cmd := DllCall("GetCommandLine", "str")
    ; /restart is used to prevent infinite loop
    if !A_IsAdmin || !RegExMatch(cmd, " /restart") {
        ; Path and parameters are different for compiled scripts
        path := A_IsCompiled ? A_ScriptFullPath : (params := '"' A_ScriptFullPath '"' params, A_AhkPath)
        DllCall("shell32\ShellExecute", "UInt", 0, "str", "RunAs", "str", path, "str", '/restart ' params, "str", A_WorkingDir, "int", 1)
        ExitApp()
    }
}

; Removal can only be done in elevated mode, this function makes sure quitting the script will kill the process.
exitFn(*) {
    Run(A_ComSpec " /c taskkill /PID " WinGetPID(A_ScriptHwnd) " /F ",, "Hide")
}

/** 
  * Template class for removing AppX packages.
  * @class AppxPackageRemover
  */
class AppxPackageRemover {

    ; The URL of the Microsoft Store page of the AppX package.
    static storeURL := "ms-windows-store://pdp/?productid=9NZKPSTSNW4P"

    ; Open the Microsoft Store page of the AppX package.
    install(*) => Run(%this.__Class%.storeURL)

    ; Check if the AppX packages are installed, shellExecCommand returns an empty string if not.
    check(*) {
        for p in this.packageName
            this.packageInfo[A_Index] := shellExecCommand("Get-AppxPackage *" p "*"),
            this.package[A_Index].value := this.packageName[A_Index] "`t" .
                                          (this.packageInfo[A_Index] ? "Installed" : "Not installed")
    }

    ; Remove the AppX packages, and check if the removal was successful.
    remove(*) {
        for p in this.packageName {
            if this.packageInfo[A_Index]
                shellExecCommand("Get-AppxPackage *" p "* | Remove-AppxPackage")
        }
        this.check()
        for p in this.packageInfo
            if p
                throw Error("Failed to remove the following AppXPackage: " p)
        MsgBox("AppXPackages have been succesfully removed.", 'BarUninstaller', "0x40 T1500")
    }

    ; Show the package info on mouse hover.
    showPackageInfo(i,*) {
        if !this.packageInfo[i]
            return
        while getKeyState("Lbutton", "P") {
            if !IsSet(displayed) {
                displayed := true
                ToolTip(this.packageInfo[i])
            }
            Sleep(20)
        }
        ToolTip()
    }

    /**
     * @param {variadic} packageName: The AppX package names to be removed.  
     * Usage: AppxPackageRemover(Name1, Name2, ...)
     */
    __New(packageName*) {
        
        ; Elevate the script if needed
        runAsAdmin()
        
        ; Initialize the class variables
        this.btn := [], this.package := [], this.packageInfo := []
        ; Set the GUI parameters
        btnWidth := 70, txtWidth := 250, guiY := A_ScreenHeight // 2 - 300     
        ; Create the GUI
        this.gui := Gui("+AlwaysOnTop", SubStr(A_ScriptName, 1, -4))        

        ; Create the buttons
        btns := ["Check", "Remove", "Install"]
        if not %this.__Class%.storeURL
            btns.Pop()
        for v in btns {
            this.btn.Push(this.gui.AddButton("w" btnWidth (A_Index > 1 ? " ys" : ""), v))
            this.btn[A_Index].OnEvent("Click", ObjBindMethod(this, v))
        }
        ; Display the package names and their status
        this.gui.AddText("xs", "Installed AppXPackages:")        
        for p in (this.packageName := packageName) {
            this.package.Push(this.gui.AddText("w" txtWidth, p))
            this.package[A_Index].OnEvent("Click", ObjBindMethod(this, "showPackageInfo", A_Index))
            this.packageInfo.Push("")
        }
        ; Show the GUI, set the exit function
        this.gui.Show("w" txtWidth + 5 " y" guiY)
        onExit(exitFn)
    }
}
