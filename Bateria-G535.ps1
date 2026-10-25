Add-Type -AssemblyName System.Windows.Forms,System.Drawing
Add-Type 'using System; using System.Runtime.InteropServices; public class IconNative { [DllImport("user32.dll")] public static extern bool DestroyIcon(IntPtr h); }'
$mutex=[Threading.Mutex]::new($false,'Local\G535BatteryTray')
if(-not $mutex.WaitOne(0)){exit}
function Read-GHub($path) {
 $ws=[Net.WebSockets.ClientWebSocket]::new();$ws.Options.AddSubProtocol('json');$ct=[Threading.CancellationTokenSource]::new(4000)
 try {
  $null=$ws.ConnectAsync([uri]'ws://127.0.0.1:9010',$ct.Token).GetAwaiter().GetResult()
  $data=[Text.Encoding]::UTF8.GetBytes((@{path=$path;verb='GET'}|ConvertTo-Json -Compress))
  $null=$ws.SendAsync([ArraySegment[byte]]::new($data),[Net.WebSockets.WebSocketMessageType]::Text,$true,$ct.Token).GetAwaiter().GetResult()
  $buffer=New-Object byte[] 65536
  while($true){
   $ms=[IO.MemoryStream]::new()
   do{$r=$ws.ReceiveAsync([ArraySegment[byte]]::new($buffer),$ct.Token).GetAwaiter().GetResult();if($r.MessageType -eq 'Close'){throw 'Conexao encerrada'};$ms.Write($buffer,0,$r.Count)}while(-not $r.EndOfMessage)
   $msg=[Text.Encoding]::UTF8.GetString($ms.ToArray())|ConvertFrom-Json;$ms.Dispose()
   if($msg.path -eq $path -and $msg.verb -eq 'GET'){if($msg.result.code -ne 'SUCCESS'){throw 'Sem leitura'};return $msg.payload}
  }
 }finally{$ws.Dispose();$ct.Dispose()}
}
$tray=[Windows.Forms.NotifyIcon]::new()
$menu=[Windows.Forms.ContextMenuStrip]::new()
$status=$menu.Items.Add('Conectando...');$status.Enabled=$false
$update=$menu.Items.Add('Atualizar agora');$open=$menu.Items.Add('Abrir Logitech G Hub');$quit=$menu.Items.Add('Sair')
$tray.ContextMenuStrip=$menu
function Draw-Icon([int]$percentage,[bool]$charging=$false,[bool]$full=$false){
 $bmp=[Drawing.Bitmap]::new(32,32);$g=[Drawing.Graphics]::FromImage($bmp);$g.Clear([Drawing.Color]::Transparent)
 $known=$percentage -ge 0
 $color=if(-not $known){'Gray'}elseif($percentage -le 30 -and -not $full){'Tomato'}elseif($charging){'DeepSkyBlue'}elseif($full -or $percentage -ge 100){'PaleGreen'}else{'WhiteSmoke'}
 $brush=[Drawing.SolidBrush]::new([Drawing.Color]::FromName($color))
 $outline=[Drawing.Pen]::new([Drawing.Color]::FromArgb(220,25,25,25),4)
 $edge=[Drawing.Pen]::new([Drawing.Color]::FromName('Black'),2)
 $g.DrawRectangle($outline,7,5,18,25);$g.DrawRectangle($edge,7,5,18,25);$g.FillRectangle([Drawing.Brushes]::Black,12,1,8,3)
 if($known){
  if($full -or $percentage -ge 100){$g.FillRectangle($brush,10,8,12,19)}elseif(-not $charging){
   $bars=if($percentage -le 30){1}elseif($percentage -le 60){2}else{3}
   for($i=0;$i -lt $bars;$i++){$g.FillRectangle($brush,10,(22-7*$i),12,5)}
  }
 }else{$g.FillRectangle($brush,12,17,8,2)}
 if($charging -and -not $full -and $percentage -lt 100){
  $g.SmoothingMode='AntiAlias'
  $points=[Drawing.Point[]]@([Drawing.Point]::new(18,8),[Drawing.Point]::new(11,19),[Drawing.Point]::new(16,19),[Drawing.Point]::new(14,27),[Drawing.Point]::new(22,15),[Drawing.Point]::new(17,15))
  $boltEdge=[Drawing.Pen]::new([Drawing.Color]::FromArgb(255,20,20,20),2)
  $g.FillPolygon([Drawing.Brushes]::LightSkyBlue,$points);$g.DrawPolygon($boltEdge,$points);$boltEdge.Dispose()
 }
 $handle=$bmp.GetHicon();$icon=[Drawing.Icon]::FromHandle($handle);$copy=$icon.Clone();$icon.Dispose();[void][IconNative]::DestroyIcon($handle)
 $old=$tray.Icon;$tray.Icon=$copy;if($old){$old.Dispose()}
 $outline.Dispose();$edge.Dispose();$brush.Dispose();$g.Dispose();$bmp.Dispose()
}
function Update-Battery {
 try {
  $list=Read-GHub '/devices/list';$d=$list.deviceInfos|Where-Object {$_.deviceModel -eq 'g535' -and $_.deviceType -eq 'HEADSET'}|Select-Object -First 1
  if(-not $d -or $d.state -ne 'ACTIVE'){throw 'G535 desconectado'}
  $b=Read-GHub ('/battery/'+$d.id+'/state')
  if($null -eq $b.percentage -or $b.isBatteryRemoved){throw 'Sem bateria'}
  $p=[int]$b.percentage;if($p -lt 0 -or $p -gt 100){throw 'Leitura invalida'}
  $full=[bool]$b.fullyCharged -or $p -eq 100
  Draw-Icon $p ([bool]$b.charging) $full
  $charge=if($full){'carga completa'}elseif($b.charging){'carregando'}else{'em uso'}
  $text=('G535: {0}% - {1} - ~{2:N1} h (G Hub)' -f $p,$charge,$b.mileage)
  $tray.Text=$text.Substring(0,[Math]::Min(63,$text.Length));$status.Text=$text
 }catch{
  Draw-Icon -1;$tray.Text='G535: sem leitura do G Hub';$status.Text='Sem leitura: confira o G Hub e o headset'
 }
}
$update.Add_Click({Update-Battery});$open.Add_Click({Start-Process (Join-Path $env:ProgramFiles 'LGHUB\lghub.exe')});$tray.Add_DoubleClick({Start-Process (Join-Path $env:ProgramFiles 'LGHUB\lghub.exe')})
$quit.Add_Click({[Windows.Forms.Application]::ExitThread()})
$timer=[Windows.Forms.Timer]::new();$timer.Interval=30000;$timer.Add_Tick({Update-Battery});$timer.Start()
try{Update-Battery;$tray.Visible=$true;[Windows.Forms.Application]::Run()}finally{$timer.Dispose();$tray.Visible=$false;if($tray.Icon){$tray.Icon.Dispose()};$tray.Dispose();$menu.Dispose();$mutex.ReleaseMutex();$mutex.Dispose()}




