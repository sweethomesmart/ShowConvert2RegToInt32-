!----Lese KSEM Kostal Version 1.0.0.0 ---------------------------
! Hier alle was man verändern kann/muss
! Voraussetzung: Kostal Plenticore Wechselrichter Modbus aktiviert
! Datei modbus.tcl und modbus_interface.tcl in Verzeichnis /usr/local/addons/modbus/modbus kopiert und Dateifreigabe 711
! Systemvariable in der CCU anlegen
! KSEM_GridPowerTotal = Verbrauch oder Überschuss aus/ins Netz
! KSEM_HomeConsumption = Hausverbrauch
! KSEM_HomeConsumptionFromPV = Hausverbrauch aus PV
! KSEM_HomeConsumptionFromBattery = Hausverbrauch aus Battery
! KSEM_HomeConsumptionFromGrid = Hausverbrauch aus Netz
! KSEM_WallboxConsumption = Wallboxverbrauch gesamt
! KSEM_WallboxConsumptionFromPV = Wallboxverbrauch aus PV
! KSEM_WallboxConsumptionFromBattery = Wallboxverbrauch aus Battery
! KSEM_WallboxConsumptionFromGrid = Wallboxverbrauch aus Netz
! KSEM_BatterySOC = Ladezustand Battery = Wallboxverbrauch aus Battery
! KSEM_BatteryChargeDischarge = Laden oder Entladen Battery
!------------------------------------------------------------------------------
!string DeviceIP = "192.168.178.156"; !IP des Kostal KSEM
string DeviceIP = "KSEM";
string DeviceID = "1"; !Device ID siehe Webportal des KSEM Modbus Einstellung
string DevicePort = "502"; !Port siehe Webportal des KSEM Modbus Einstellung
string cmd = "tclsh /usr/local/addons/modbus/modbus_interface.tcl"; !Verzeichnis inkl. Dateiaufruf
string RdHoldRg = "03"; !03 Function read holding registers
string Adr_N_GridPowerTotal = "40972 2";
string Adr_N_HomeConsumption = "40982 2";
string Adr_N_HomeConsumptionFromPV = "40988 2";
string Adr_N_HomeConsumptionFromBattery = "40990 2";
string Adr_N_HomeConsumptionFromGrid = "40992 2";
string Adr_N_WallboxConsumption = "40996 2";
string Adr_N_WallboxConsumptionFromPV = "40998 2";
string Adr_N_WallboxConsumptionFromBattery = "41000 2";
string Adr_N_WallboxConsumptionFromGrid = "41002 2";
string Adr_N_BatterySOC = "40986 1";
string Adr_N_BatteryChargeDischarge = "40984 2";
!-----------------------------------------------------------------------------
! Ab hier muss man nichts mehr beachten
!-----------------------------------------------------------------------------
string SetCmd = cmd + " " + DeviceIP + " " + DevicePort + " " + DeviceID + " " + RdHoldRg + " ";
string lGetOut = "";
string lGetErr = "";
real Value;
integer hword;
integer lword;
integer space_pos;
!-----------------------------------------------------------------------------
! Grid power Total
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_GridPowerTotal,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");		 !WriteLine(lGetOut);WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();        !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();        !WriteLine(lword);
Value = hword*65536;   	!WriteLine(Value);  !Convert 2 Register to integer
Value = Value|lword;
var GridPowerTotal=dom.GetObject("KSEM_GridPowerTotal");
GridPowerTotal.State(Value);
WriteLine("Grid power Total int32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Home consumption
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_HomeConsumption,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();	!WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();    !WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var HomeConsumption=dom.GetObject("KSEM_HomeConsumption");
HomeConsumption.State(Value);
WriteLine("Home consumption int32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Home consumption from PV
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_HomeConsumptionFromPV,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	   		 	!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();    !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();    !WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var HomeConsumptionFromPV=dom.GetObject("KSEM_HomeConsumptionFromPV");
HomeConsumptionFromPV.State(Value);
WriteLine("Home consumption from PV uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Home consumption from PV
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_HomeConsumptionFromBattery,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();    !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();	!WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var HomeConsumptionFromBattery=dom.GetObject("KSEM_HomeConsumptionFromBattery");
HomeConsumptionFromBattery.State(Value);
WriteLine("Home consumption from battery uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Home consumption from grid
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_HomeConsumptionFromGrid,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    !WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();	!WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();	!WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var HomeConsumptionFromGrid=dom.GetObject("KSEM_HomeConsumptionFromGrid");
HomeConsumptionFromGrid.State(Value);
WriteLine("Home consumption from grid uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Wallbox consumption
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_WallboxConsumption,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();    !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();	!WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var WallboxConsumption=dom.GetObject("KSEM_WallboxConsumption");
WallboxConsumption.State(Value);
WriteLine("Wallbox consumption uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Wallbox consumption from PV
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_WallboxConsumptionFromPV,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();	!WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();    !WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var WallboxConsumptionFromPV=dom.GetObject("KSEM_WallboxConsumptionFromPV");
WallboxConsumptionFromPV.State(Value);
WriteLine("Wallbox consumption from PV uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Wallbox consumption from PV
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_WallboxConsumptionFromBattery,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();    !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();    !WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var WallboxConsumptionFromBattery=dom.GetObject("KSEM_WallboxConsumptionFromBattery");
WallboxConsumptionFromBattery.State(Value);
WriteLine("Wallbox consumption from battery uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Wallbox consumption from grid
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_WallboxConsumptionFromGrid,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();	!WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();	!WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var WallboxConsumptionFromGrid=dom.GetObject("KSEM_WallboxConsumptionFromGrid");
WallboxConsumptionFromGrid.State(Value);
WriteLine("Wallbox consumption from grid uint32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! Sum battery charge / discharge DC
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_BatteryChargeDischarge,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
space_pos = lGetOut.Find(" ");        	    		!WriteLine(space_pos);
hword = lGetOut.Substr(0,space_pos).ToInteger();    !WriteLine(hword);
lword = lGetOut.Substr(space_pos+1).ToInteger();    !WriteLine(lword);
Value = hword*65536;   !WriteLine(Value);   !Convert 2 Register to integer
Value = Value|lword;                        		!WriteLine(Value);
var BatteryChargeDischarge=dom.GetObject("KSEM_BatteryChargeDischarge");
BatteryChargeDischarge.State(Value);
WriteLine("Sum battery charge / discharge DC int32 [W]:  " + Value);
!-----------------------------------------------------------------------------
! System state of charge
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_BatterySOC,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
lword = lGetOut.ToInteger();   !WriteLine(lword);
var Battery_SOC=dom.GetObject("KSEM_BatterySOC");
Battery_SOC.State(lword);
WriteLine("System state of charge uint16 [%]:  " + lword);





