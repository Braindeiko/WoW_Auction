#NoEnv
SendMode Input
#SingleInstance Force
SetWorkingDir %A_ScriptDir% 

; #Include <Functions>
#Include %A_MyDocuments%\AHK_Library\Functions.ahk

CreateWindow()

;Variables —————————————————————————————————————————————————————————
;———————————————————————————————————————————————————————————————————
Auction := new Auction()
Auction.Init()
;Botones ———————————————————————————————————————————————————————————
;———————————————————————————————————————————————————————————————————

Numpad1:: Auction.Post("UseMacro") Return

Numpad2:: Auction.Post("UseClick") Return

Numpad3:: reload Return

NumpadDot:: exitapp

;Interfaz ——————————————————————————————————————————————————————————
;———————————————————————————————————————————————————————————————————

Class Auction
{
	
	Init()
	{
		This.nClicks := 0, This.ClicksRandom := 0, This.lastClick := 0
		This.Mode := "UseMacro"
		Loop
		{
			If(This.foundButton())
			{
				Loop
				{
					This.foundButton()
					If((A_TickCount - This.lastFound) >= 300)
						Break
					Else
						This.tapPost()
				}
			}
			Else If (This.lastClick == 0)
				Sleep(500)
			
			If (((A_TickCount - This.lastClick) >= 2000) And (This.lastClick	!= 0))
			{	
				Close()
				This.Init()
			}
		}
		
	}
	
	Post(Mode)
	{
		This.nClicks := 0, This.ClicksRandom := 0, This.lastClick := 0
		
		If(Mode != "")
		{
			This.Mode := Mode
			This.setCoor()
		}
		
		Loop
		{
			If(This.foundButton())
			{
				Loop
				{
					This.foundButton()
					If((A_TickCount - This.lastFound) >= 500)
						Break
					Else
						This.tapPost()
				}
			}
			Else If (This.lastClick == 0)
				Sleep(500)
			
			If (((A_TickCount - This.lastClick) >= 2000) And (This.lastClick	!= 0))
			{	
				Close()
				This.Post("")
			}
		}
		
	}
	
	foundButton()
	{

		If(Image(A, ["buttonPost", "buttonCancelar"], Window.W*70/320, Window.H*0.4, Window.W, Window.H))
		{
			This.lastFound := A_TickCount
			Return True
		}
		Else
			Return False
	}
	
	tapPost()
	{
		This.setTaps()
		This.setLastCoor()
		This.setSleep()
		
		Loop % This.nTaps
		{
			Sleep(0, 70)
			This.buttonTap()
		}
		
		Print("[Use button]")
		
		This.HumanMistake()
		This.nClicks++
		This.lastClick := A_TickCount
	}
	
	setTaps()
	{
		If(This.Mode == "UseMacro")
			This.nTaps := Rand(2, 5)
		Else If(This.Mode == "UseClick")
			This.nTaps := 1
	}
	
	setLastCoor()
	{	
		If(This.nClicks >=  This.ClicksRandom)
		{
			This.nClicks := 0, This.ClicksRandom := Rand(25, 50)
			
			If(This.Mode == "UseMacro")
			{
				This.lastCoorX := Rand(Window._X/2 + 50, Window._X - 50)
				This.lastCoorY := Rand(Window._Y/3, Window._Y*2/3 - 10)
			}
			Else
				If(This.Mode == "UseClick")
				{
					This.lastCoorX := This.X + Rand(-5, 5)
					This.lastCoorY := This.Y + Rand(1, 6)
				}
				
			Clear()
		}
	}
	
	setSleep()
	{
		If(This.Mode == "UseMacro")
			Sleep(10, 150)
		Else If(This.Mode == "UseClick")
			Sleep(130, 230)
	}
	
	buttonTap()
	{
		If(This.Mode == "UseMacro")
		{
			SendClick(This.lastCoorX, This.lastCoorY, "WU", False)
		}
		Else If(This.Mode == "UseClick")
		{
			Print("UseCursor")
			useCursor := True
			SendClick(This.lastCoorX, This.lastCoorY,, False)
			useCursor := False
		}
	}
	
	HumanMistake()
	{
		If(Rand(1, 100) == 1)
		{
			If Rand(0, 1)
				Sleep(100, 500)
			Else
				This.buttonTap()
		}
	}
	
	setCoor()
	{
		CoordMode, Mouse, Window
		MouseGetPos, X, Y
		This.X := X
		This.Y := Y
	}
}

;Metodos ——————————————————————————————————————————————————————————
;——————————————————————————————————————————————————————————————————


CreateWindow(titleWindow := False, dirWindow := False){
	
	global Window := new Window(titleWindow, dirWindow)
	Window.Open()
	Window.Wait()
	; Window.Activate()
	; Window.Get()
}
