Add-type -assemblyName System.Windows.Forms
Add-type -assemblyName System.Drawing

function DoSomething($btnOpt) {
  if (!$btnOpt.text) {
    if ($script:strActivePlayer -eq 'o') {
      $btnopt.ForeColor = "Red"
      $btnopt.text = 'o'
      $script:strActivePlayer = 'x'
    } else {
      $btnopt.ForeColor = "Green"
      $btnopt.text = 'x'
      $script:strActivePlayer = 'o'
    }

    $script:frmTTT.controls[0].text = "player $strActivePlayer's turn"
    TestVictory
  }
}

function TestVictory {
  $aVictoryConditions = @(
    "1,2,3",
    "4,5,6",
    "7,8,9",
    "1,4,7",
    "2,5,8",
    "3,6,9",
    "1,5,9",
    "3,5,7"
  )

  foreach ($strCond in $aVictoryConditions) {
    $aFields = $strCond.Split(",")
    [int[]]$aFieldsInt = $aFields
    if (($script:frmTTT.controls[$aFieldsInt[0]].text -eq "x") -and ($script:frmTTT.controls[$aFieldsInt[1]].text -eq "x") -and ($script:frmTTT.controls[$aFieldsInt[2]].text -eq "x")) {
      $script:frmTTT.controls[0].ForeColor = "Green"
      $script:frmTTT.controls[0].text = "PLAYER X WINS"
      ToggleButtons
    } elseif (($script:frmTTT.controls[$aFieldsInt[0]].text -eq "o") -and ($script:frmTTT.controls[$aFieldsInt[1]].text -eq "o") -and ($script:frmTTT.controls[$aFieldsInt[2]].text -eq "o")) {
      $script:frmTTT.controls[0].ForeColor = "Red"
      $script:frmTTT.controls[0].text = "PLAYER O WINS"
      ToggleButtons
    }
  }
}

function ToggleButtons {
  if ($script:bButtonsEnabled) {
    for ($i=1;$i -lt 10;$i++) {
      $script:frmTTT.controls[$i].Enabled = $false
    }
    $script:bButtonsEnabled = $false
  } else {
    for ($i=1;$i -lt 10;$i++) {
      $script:frmTTT.controls[$i].Enabled = $true
    }
    $script:bButtonsEnabled = $true
  }
}

function Reset {
  for ($i=1;$i -lt 10;$i++) {
    $script:frmTTT.controls[$i].text = ""
  }
  if ($script:bButtonsEnabled -eq $false) {
    ToggleButtons
  }

  $script:frmTTT.controls[0].ForeColor = "Black"
  $script:frmTTT.controls[0].Text = "player $strActivePlayer's turn"
}

$strActivePlayer = 'o'
$strLabelPlayer = "player $strActivePlayer's turn"
$bButtonsEnabled = $true

$frmTTT = New-Object system.windows.forms.form
$frmTTT.Width = 600
$frmTTT.Height = 700

$lblActivePlayer = New-Object system.windows.forms.label
$lblActivePlayer.Text = $strLabelPlayer
$lblActivePlayer.TextAlign = "MiddleCenter"
$lblActivePlayer.Font = New-Object System.drawing.font("times new roman",20)
$lblActivePlayer.Width = 400
$lblActivePlayer.Height = 100

$frmTTT.Controls.Add($lblActiveplayer)
$intDrawingX = 0
$intDrawingY = 100
$btnOpts = @(1)

for ($i=1;$i -lt 10;$i++) {
  $btnOpts += @($i)

  $btnOpts[$i] = New-Object system.windows.forms.button
  $btnOpts[$i].Width = 200
  $btnOpts[$i].height = 200
  $btnOpts[$i].Font = New-Object System.drawing.font("times new roman",40)
  $btnOpts[$i].Add_click({DoSomething($this)})
  $btnOpts[$i].location = New-Object system.drawing.point($intDrawingX,$intDrawingY)

  $frmTTT.Controls.add($btnOpts[$i])
  if ($i/3 -is [int]) {
    $intDrawingY += 200
    $intDrawingX = 0
  } else {
    $intDrawingX += 200
  }
}

$btnReset = New-Object system.windows.forms.button
$btnReset.width = 200
$btnReset.height = 100
$btnReset.text = "Reset"
$btnReset.Add_click({Reset})
$btnReset.Location = New-Object System.Drawing.Point(400,0)

$frmTTT.Controls.add($btnReset)
$frmTTT.ShowDialog()
