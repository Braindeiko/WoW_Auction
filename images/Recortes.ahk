#Include %A_MyDocuments%\AHK_Library\Functions.ahk

Global Region := new Region()
SetWorkingDir %A_ScriptDir%

Class Region{
	
	
	setXY(Coor){
		CoordMode, Mouse, Relative
		MouseGetPos, X, Y, getID
		WinGetTitle, titleWindow, ahk_id %getID%
		
		This.Win := new Window(titleWindow, "")
		
		If(Coor == 1)
			This.X := X + This.Win.excessX, This.Y := Y + This.Win.excessY
		If(Coor == 2)
		{
			This._X := X + This.Win.excessX, This._Y := Y + This.Win.excessY
			Print("X:" This.X ", Y: " This.Y)
			Print("_X:" This._X ", _Y: " This._Y)
		}		
		; Print("Coor " Coor ": ")
		
	}
	
	shotCapture(){
			
		This.W := This._X - This.X
		This.H := This._Y - This.Y
		This.Win.Get()
		
		pToken := Gdip_Startup()
		ScreenShot := Gdip_BitmapFromCoor(This.Win.ID, This.X, This.Y, This._X, This._Y) ; pBitmapH
		
;	Guardar como{
		InputBox, NameImage, Guardar como, Nombre:,, 200, 125
		This.NameImage := NameImage
		This.Dir := A_WorkingDir "\" This.NameImage ".png"
		Gdip_SaveBitmapToFile(ScreenShot, This.Dir, 100)
;	}
		Gdip_DisposeImage(ScreenShot)
		Gdip_Shutdown(pToken)
		
		This.openCapture()
	}
	

	openCapture(){
		paint := "C:\Windows\system32\mspaint.exe"
		dir := This.Dir
		Run %paint% %dir%
	}
	
	SendFunction(){
		
		This.setSearchXY()
		
		SearchCoor := This.SearchX ", " This.SearchY ", " This.Search_X ", " This.Search_Y
		NameImage := This.NameImage
		
		Function = Image(I, "%NameImage%", "", %SearchCoor%)
		
		Send %Function%
	}

	setSearchXY(searchRange := 15){
	
		This.SearchX := This.X - searchRange
		This.SearchY := This.Y - searchRange
		This.Search_X := This._X + searchRange
		This.Search_Y := This._Y + searchRange
		
		If(This.SearchX < 0)
			This.SearchX := 0
		If(This.SearchY < 0)
			This.SearchY := 0
		If(This.Search_X > This.Win.W)
			This.Search_X := This.Win.W
		If(This.Search_Y > This.Win.H)
			This.Search_Y := This.Win.H
		
	}
	
}

Numpad0::
	Region.openCapture()
Return 

Numpad1::
	Region.setXY(1)
Return

Numpad2::
	Region.setXY(2)
Return

Numpad3::
	Region.shotCapture()
Return

NumpadEnter:: 
	Region.SendFunction()
Return

NumpadDot:: exitapp

