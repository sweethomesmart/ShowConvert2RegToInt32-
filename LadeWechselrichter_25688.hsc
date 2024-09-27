!----Lese Wechselrichter Plenticore Plus----------------------------------
! Hier alle was man verändern kann/muss
! Voraussetzung: Kostal Plenticore Wechselrichter Modbus aktiviert
! Datei modbus.tcl und modbus_interface.tcl in Verzeichnis /usr/local/addons/modbus/modbus kopiert und Dateifreigabe 711
! Systemvariable:
! PV_PowerPV = Aktuelle Leistung PV
! PV_Ueberschuss = Überschuss PV Anlage
! PV_VerbrauchAusBatterie = Hausverbrauch aus Batterie
! PV_VerbrauchAusNetz = Hausverbrauch aus Netz
! PV_VerbrauchAusPV = Hausverbrauch aus PV
! PV_Ueberschuss = Überschuss PV Anlage
! PV_Hausverbrauch = Aktueller Hausverbrauch
! PV_Battery_SOC = Ladezustand Battery
!-----------------------------------------------------------------------------
string DeviceIP = "192.168.178.138"; !IP des Kostal Plenticore Wechselrichters
string DeviceID = "71"; !Device ID siehe Webportal des Wechselrichter Modbus Einstellung
string DevicePort = "1502"; !Port siehe Webportal des Wechselrichter Modbus Einstellung
string cmd = "tclsh /usr/local/addons/modbus/modbus_interface.tcl"; !Verzeichnis inkl. Dateiaufruf
string RdHoldRg = "03"; !03 Function read holding registers
string Adr_N_Grid = "108 2"; !Adresse Register und Anzahl Word
string Adr_N_PV = "100 2"; !Adresse Register und Anzahl Word
string Adr_N_Battery = "106 2"; !Adresse Register und Anzahl Word
string Adr_N_PV_Consumotion = "116 2"; !Adresse Register und Anzahl Word
string Adr_N_PV_Battery_SOC = "514 1"; !Adresse Register und Anzahl Word
!-----------------------------------------------------------------------------
! Ab hier muss man nichts mehr beachten
!-----------------------------------------------------------------------------
string SetCmd = cmd + " " + DeviceIP + " " + DevicePort + " " + DeviceID + " " + RdHoldRg + " ";
string lGetOut = "";
string lGetErr = "";
var hword;
var lword;
integer space_pos;
integer hochzahl;
real mantisse;
!-----------------------------------------------------------------------------
! aktuelle Leistung aus PV
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_PV,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
hword = lGetOut;                        !WriteLine(hword);
space_pos = hword.Find(" ");        !WriteLine(space_pos);
lword = 0 + hword.Substr(0,space_pos);
if(lword < 0) {lword = lword + 32768;}      !WriteLine(lword);
hword = 0 + hword.Substr(space_pos);
if(hword < 0) {hword = hword + 32768;}      !WriteLine(hword);

hochzahl = hword / 128;             !WriteLine(hochzahl);
if( (hochzahl & 128) > 0) {hochzahl = 1 + (hochzahl & 127);} else {hochzahl = -128 + 1 + (hochzahl & 127);}

mantisse = 1.0;
if( (hword & 64) > 0)     {mantisse = mantisse + 0.5; }
if( (hword & 32) > 0)     {mantisse = mantisse + 0.25; }
if( (hword & 16) > 0)     {mantisse = mantisse + 0.125; }
if( (hword & 8 ) > 0)     {mantisse = mantisse + 0.0625; }
if( (hword & 4 ) > 0)     {mantisse = mantisse + 0.03125; }
if( (hword & 2 ) > 0)     {mantisse = mantisse + 0.015625; }
if( (hword & 1 ) > 0)     {mantisse = mantisse + 0.0078125; }

if( (lword & 32768) > 0)  {mantisse = mantisse + 0.00390625; }
if( (lword & 16384) > 0)  {mantisse = mantisse + 0.001953125; }
if( (lword & 8182 ) > 0)  {mantisse = mantisse + 0.0009765625; }
if( (lword & 4096 ) > 0)  {mantisse = mantisse + 0.00048828125; }
if( (lword & 2048 ) > 0)  {mantisse = mantisse + 0.000244140625; }
if( (lword & 1024 ) > 0)  {mantisse = mantisse + 0.0001220703125; }
if( (lword & 512  ) > 0)  {mantisse = mantisse + 0.0000610351562; }
if( (lword & 256  ) > 0)  {mantisse = mantisse + 0.0000305175781; }

if( (lword & 128) > 0)    {mantisse = mantisse + 0.0000152587890; }
if( (lword & 64 ) > 0)    {mantisse = mantisse + 0.0000076293945; }
if( (lword & 32 ) > 0)    {mantisse = mantisse + 0.0000038146972; }
if( (lword & 16 ) > 0)    {mantisse = mantisse + 0.0000019073486; }
if( (lword & 8  ) > 0)    {mantisse = mantisse + 0.0000009536743; }
if( (lword & 4  ) > 0)    {mantisse = mantisse + 0.0000004768371; }
if( (lword & 2  ) > 0)    {mantisse = mantisse + 0.0000002384185; }
if( (lword & 1  ) > 0)    {mantisse = mantisse + 0.0000001192092; }

mantisse = mantisse * hochzahl.Exp2();
if( (hword & 32768) > 0) {mantisse = (-1) * mantisse;}
var PV_Value=dom.GetObject("PV_PowerPV");
PV_Value.State(mantisse);
WriteLine("PV Leistung [W]:  " + mantisse);

!-----------------------------------------------------------------------------
! aktueller Hausverbrauch
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_PV_Consumotion,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
hword = lGetOut;                        !WriteLine(hword);
space_pos = hword.Find(" ");        !WriteLine(space_pos);
lword = 0 + hword.Substr(0,space_pos);
if(lword < 0) {lword = lword + 32768;}      !WriteLine(lword);
hword = 0 + hword.Substr(space_pos);
if(hword < 0) {hword = hword + 32768;}      !WriteLine(hword);

hochzahl = hword / 128;             !WriteLine(hochzahl);
if( (hochzahl & 128) > 0) {hochzahl = 1 + (hochzahl & 127);} else {hochzahl = -128 + 1 + (hochzahl & 127);}

mantisse = 1.0;
if( (hword & 64) > 0)     {mantisse = mantisse + 0.5; }
if( (hword & 32) > 0)     {mantisse = mantisse + 0.25; }
if( (hword & 16) > 0)     {mantisse = mantisse + 0.125; }
if( (hword & 8 ) > 0)     {mantisse = mantisse + 0.0625; }
if( (hword & 4 ) > 0)     {mantisse = mantisse + 0.03125; }
if( (hword & 2 ) > 0)     {mantisse = mantisse + 0.015625; }
if( (hword & 1 ) > 0)     {mantisse = mantisse + 0.0078125; }

if( (lword & 32768) > 0)  {mantisse = mantisse + 0.00390625; }
if( (lword & 16384) > 0)  {mantisse = mantisse + 0.001953125; }
if( (lword & 8182 ) > 0)  {mantisse = mantisse + 0.0009765625; }
if( (lword & 4096 ) > 0)  {mantisse = mantisse + 0.00048828125; }
if( (lword & 2048 ) > 0)  {mantisse = mantisse + 0.000244140625; }
if( (lword & 1024 ) > 0)  {mantisse = mantisse + 0.0001220703125; }
if( (lword & 512  ) > 0)  {mantisse = mantisse + 0.0000610351562; }
if( (lword & 256  ) > 0)  {mantisse = mantisse + 0.0000305175781; }

if( (lword & 128) > 0)    {mantisse = mantisse + 0.0000152587890; }
if( (lword & 64 ) > 0)    {mantisse = mantisse + 0.0000076293945; }
if( (lword & 32 ) > 0)    {mantisse = mantisse + 0.0000038146972; }
if( (lword & 16 ) > 0)    {mantisse = mantisse + 0.0000019073486; }
if( (lword & 8  ) > 0)    {mantisse = mantisse + 0.0000009536743; }
if( (lword & 4  ) > 0)    {mantisse = mantisse + 0.0000004768371; }
if( (lword & 2  ) > 0)    {mantisse = mantisse + 0.0000002384185; }
if( (lword & 1  ) > 0)    {mantisse = mantisse + 0.0000001192092; }

mantisse = mantisse * hochzahl.Exp2();
if( (hword & 32768) > 0) {mantisse = (-1) * mantisse;}
var From_PV=dom.GetObject("PV_VerbrauchAusPV");
From_PV.State(mantisse);
WriteLine("Verbrauch aus PV [W]:  " + mantisse);

!-----------------------------------------------------------------------------
! aktuelle Leistung aus Netzbezug
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_Grid,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
hword = lGetOut;                        !WriteLine(hword);
space_pos = hword.Find(" ");        !WriteLine(space_pos);
lword = 0 + hword.Substr(0,space_pos);
if(lword < 0) {lword = lword + 32768;}      !WriteLine(lword);
hword = 0 + hword.Substr(space_pos);
if(hword < 0) {hword = hword + 32768;}      !WriteLine(hword);

hochzahl = hword / 128;             !WriteLine(hochzahl);
if( (hochzahl & 128) > 0) {hochzahl = 1 + (hochzahl & 127);} else {hochzahl = -128 + 1 + (hochzahl & 127);}

mantisse = 1.0;
if( (hword & 64) > 0)     {mantisse = mantisse + 0.5; }
if( (hword & 32) > 0)     {mantisse = mantisse + 0.25; }
if( (hword & 16) > 0)     {mantisse = mantisse + 0.125; }
if( (hword & 8 ) > 0)     {mantisse = mantisse + 0.0625; }
if( (hword & 4 ) > 0)     {mantisse = mantisse + 0.03125; }
if( (hword & 2 ) > 0)     {mantisse = mantisse + 0.015625; }
if( (hword & 1 ) > 0)     {mantisse = mantisse + 0.0078125; }

if( (lword & 32768) > 0)  {mantisse = mantisse + 0.00390625; }
if( (lword & 16384) > 0)  {mantisse = mantisse + 0.001953125; }
if( (lword & 8182 ) > 0)  {mantisse = mantisse + 0.0009765625; }
if( (lword & 4096 ) > 0)  {mantisse = mantisse + 0.00048828125; }
if( (lword & 2048 ) > 0)  {mantisse = mantisse + 0.000244140625; }
if( (lword & 1024 ) > 0)  {mantisse = mantisse + 0.0001220703125; }
if( (lword & 512  ) > 0)  {mantisse = mantisse + 0.0000610351562; }
if( (lword & 256  ) > 0)  {mantisse = mantisse + 0.0000305175781; }

if( (lword & 128) > 0)    {mantisse = mantisse + 0.0000152587890; }
if( (lword & 64 ) > 0)    {mantisse = mantisse + 0.0000076293945; }
if( (lword & 32 ) > 0)    {mantisse = mantisse + 0.0000038146972; }
if( (lword & 16 ) > 0)    {mantisse = mantisse + 0.0000019073486; }
if( (lword & 8  ) > 0)    {mantisse = mantisse + 0.0000009536743; }
if( (lword & 4  ) > 0)    {mantisse = mantisse + 0.0000004768371; }
if( (lword & 2  ) > 0)    {mantisse = mantisse + 0.0000002384185; }
if( (lword & 1  ) > 0)    {mantisse = mantisse + 0.0000001192092; }

mantisse = mantisse * hochzahl.Exp2();
if( (hword & 32768) > 0) {mantisse = (-1) * mantisse;}
var From_Grid=dom.GetObject("PV_VerbrauchAusNetz");
From_Grid.State(mantisse);
WriteLine("Verbrauch aus Netz [W]:  " + mantisse);

!-----------------------------------------------------------------------------
! aktuelle Leistung aus Battery
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_Battery,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
hword = lGetOut;                        !WriteLine(hword);
space_pos = hword.Find(" ");        !WriteLine(space_pos);
lword = 0 + hword.Substr(0,space_pos);
if(lword < 0) {lword = lword + 32768;}      !WriteLine(lword);
hword = 0 + hword.Substr(space_pos);
if(hword < 0) {hword = hword + 32768;}      !WriteLine(hword);

hochzahl = hword / 128;             !WriteLine(hochzahl);
if( (hochzahl & 128) > 0) {hochzahl = 1 + (hochzahl & 127);} else {hochzahl = -128 + 1 + (hochzahl & 127);}

mantisse = 1.0;
if( (hword & 64) > 0)     {mantisse = mantisse + 0.5; }
if( (hword & 32) > 0)     {mantisse = mantisse + 0.25; }
if( (hword & 16) > 0)     {mantisse = mantisse + 0.125; }
if( (hword & 8 ) > 0)     {mantisse = mantisse + 0.0625; }
if( (hword & 4 ) > 0)     {mantisse = mantisse + 0.03125; }
if( (hword & 2 ) > 0)     {mantisse = mantisse + 0.015625; }
if( (hword & 1 ) > 0)     {mantisse = mantisse + 0.0078125; }

if( (lword & 32768) > 0)  {mantisse = mantisse + 0.00390625; }
if( (lword & 16384) > 0)  {mantisse = mantisse + 0.001953125; }
if( (lword & 8182 ) > 0)  {mantisse = mantisse + 0.0009765625; }
if( (lword & 4096 ) > 0)  {mantisse = mantisse + 0.00048828125; }
if( (lword & 2048 ) > 0)  {mantisse = mantisse + 0.000244140625; }
if( (lword & 1024 ) > 0)  {mantisse = mantisse + 0.0001220703125; }
if( (lword & 512  ) > 0)  {mantisse = mantisse + 0.0000610351562; }
if( (lword & 256  ) > 0)  {mantisse = mantisse + 0.0000305175781; }

if( (lword & 128) > 0)    {mantisse = mantisse + 0.0000152587890; }
if( (lword & 64 ) > 0)    {mantisse = mantisse + 0.0000076293945; }
if( (lword & 32 ) > 0)    {mantisse = mantisse + 0.0000038146972; }
if( (lword & 16 ) > 0)    {mantisse = mantisse + 0.0000019073486; }
if( (lword & 8  ) > 0)    {mantisse = mantisse + 0.0000009536743; }
if( (lword & 4  ) > 0)    {mantisse = mantisse + 0.0000004768371; }
if( (lword & 2  ) > 0)    {mantisse = mantisse + 0.0000002384185; }
if( (lword & 1  ) > 0)    {mantisse = mantisse + 0.0000001192092; }

mantisse = mantisse * hochzahl.Exp2();
if( (hword & 32768) > 0) {mantisse = (-1) * mantisse;}
var From_Battery=dom.GetObject("PV_VerbrauchAusBatterie");
From_Battery.State(mantisse);
WriteLine("Verbrauch aus Batterie [W]:  " + mantisse);

!-----------------------------------------------------------------------------
! aktueller Ladezustand Battery
!-----------------------------------------------------------------------------
system.Exec( SetCmd + Adr_N_PV_Battery_SOC,&lGetOut,&lGetErr);  !WriteLine(SetCmd + Adr_N_Grid);
var Battery_SOC=dom.GetObject("PV_Battery_SOC");
Battery_SOC.State(lGetOut);
WriteLine("Batterieladezustand [%]:  " + lGetOut);





var Diff =  PV_Value.State() - From_PV.State();
var Ueberschuss = dom.GetObject("PV_Ueberschuss");
Ueberschuss.State(Diff);
WriteLine("Überschuss [W]:  " + Diff);

var Verbrauch =  From_PV.State() + From_Battery.State() + From_Grid.State();
var Hausverbrauch = dom.GetObject("PV_Hausverbrauch");
Hausverbrauch.State(Verbrauch);
WriteLine("Hausverbrauch [W]:  " + Verbrauch);





