Param(
  [int]$U1, [int]$S1, [int]$S2, [int]$S3, [int]$S4, [int]$S5, [int]$S6
)

# Hyöty minuutteina / vko
$hyotyMin = $S1 * $S2 * ($S3/100) * $U1

# Hyöty pisteinä
if     ($hyotyMin -lt 30)               { $Hyoty = 1 }
elseif ($hyotyMin -lt 60)               { $Hyoty = 2 }
elseif ($hyotyMin -lt 120)              { $Hyoty = 3 }
elseif ($hyotyMin -lt 240)              { $Hyoty = 4 }
else                                    { $Hyoty = 5 }

# Vaiva pisteinä ajasta S5 (h)
if     ($S5 -le 1) { $Vaiva = 5 }
elseif ($S5 -le 3) { $Vaiva = 4 }
elseif ($S5 -le 7) { $Vaiva = 3 }
elseif ($S5 -le 15){ $Vaiva = 2 }
else               { $Vaiva = 1 }
if ($S6 -eq 1 -and $Vaiva -gt 1) { $Vaiva-- }  # lisäoikeuksista -1 pykälä

# Data pisteinä
$Data = if ($S4 -ge 1) { 3 } else { 1 }  # 1 sample = 3; tarkempi asteikko lisätään myöhemmin

# Kokonais
$Kokonais = [math]::Round(0.5*$Hyoty + 0.3*$Data + 0.2*$Vaiva,1)
$GoNoGo   = if ($Kokonais -ge 3.6 -or ($Hyoty -ge 4 -and $Vaiva -ge 3)) { "Go" } else { "No-go" }

$blk = @"
## Laskelma — Sheets Auto Report
Syötteet: U1=$U1, S1=$S1, S2=$S2, S3=$S3%, S4=$S4, S5=${S5}h, S6=$S6
Hyöty_min/vko = $hyotyMin
Hyöty/5 = $Hyoty
Vaiva/5 = $Vaiva
Data/5 = $Data
Kokonais = $Kokonais
Go/No-go = $GoNoGo
"@

Add-Content .\docs\idea.md $blk
