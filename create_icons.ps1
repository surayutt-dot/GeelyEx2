Add-Type -AssemblyName System.Drawing

$srcPath = "c:\Users\com\Desktop\antigravityPC\GeelyEx2\car.jpg"
$src = [System.Drawing.Image]::FromFile($srcPath)

function Create-BeigeSquareIcon([int]$size, [string]$outPath) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

    # 1. Warm Luxurious Beige Background
    # Gradient from soft cream ivory (#FAF6F0) to warm sand beige (#E8DFD3)
    $topColor = [System.Drawing.Color]::FromArgb(255, 250, 246, 240)
    $bottomColor = [System.Drawing.Color]::FromArgb(255, 232, 223, 211)
    $gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.Point(0, 0)),
        (New-Object System.Drawing.Point(0, $size)),
        $topColor,
        $bottomColor
    )
    $g.FillRectangle($gradBrush, 0, 0, $size, $size)
    $gradBrush.Dispose()

    # 2. Subtle warm circular radial highlight in center for depth
    $centerCircleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, 255, 255, 255))
    $circleSize = [int]($size * 0.85)
    $circleX = [int](($size - $circleSize) / 2)
    $circleY = [int](($size - $circleSize) / 2)
    $g.FillEllipse($centerCircleBrush, $circleX, $circleY, $circleSize, $circleSize)
    $centerCircleBrush.Dispose()

    # 3. Draw Beige Geely E2 EV car
    # Original image: 1376 x 768
    $cropX = 60
    $cropY = 110
    $cropW = 1256
    $cropH = 590

    $targetW = [int]($size * 0.94)
    $targetH = [int]($targetW * ($cropH / $cropW))
    $destX = [int](($size - $targetW) / 2)
    # Position slightly lower to give room for the chic badge
    $destY = [int](($size - $targetH) / 2) + [int]($size * 0.035)

    $srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)
    $destRect = New-Object System.Drawing.Rectangle($destX, $destY, $targetW, $targetH)

    $g.DrawImage($src, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

    # 4. Chic Warm Beige / Mocha Badge: "Geely E2 EV"
    $fontSize = [float]($size * 0.065)
    if ($fontSize -ge 8) {
        $font = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
        $badgeText = "Geely E2 EV"
        $textSize = $g.MeasureString($badgeText, $font)
        
        $badgeY = [int]($size * 0.058)
        $badgeX = [int](($size - $textSize.Width) / 2)
        
        # Pill background: Elegant warm mocha / hazelnut beige (#7D6652)
        $pillRect = New-Object System.Drawing.Rectangle(
            [int]($badgeX - ($size * 0.032)),
            [int]($badgeY - ($size * 0.012)),
            [int]($textSize.Width + ($size * 0.064)),
            [int]($textSize.Height + ($size * 0.024))
        )
        
        # Soft pill shadow
        $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 0, 0, 0))
        $shadowRect = New-Object System.Drawing.Rectangle(
            [int]($pillRect.X + 1),
            [int]($pillRect.Y + 2),
            $pillRect.Width,
            $pillRect.Height
        )
        $g.FillRectangle($shadowBrush, $shadowRect)
        $shadowBrush.Dispose()

        $pillBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 125, 102, 82))
        $g.FillRectangle($pillBrush, $pillRect)
        $pillBrush.Dispose()
        
        # Pill border
        $pillPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 255, 255, 255), 1.5)
        $g.DrawRectangle($pillPen, $pillRect)
        $pillPen.Dispose()
        
        # Badge Text (Crisp cream-white)
        $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 253, 248))
        $g.DrawString($badgeText, $font, $textBrush, [float]$badgeX, [float]$badgeY)
        $textBrush.Dispose()
        $font.Dispose()
    }

    # 5. Clean warm border
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(45, 125, 102, 82), 2)
    $g.DrawRectangle($pen, 1, 1, $size - 2, $size - 2)
    $pen.Dispose()

    $g.Dispose()
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

$dirs = @("c:\Users\com\Desktop\antigravityPC\GeelyEx2\", "c:\Users\com\Desktop\antigravityPC\GeelyEx2\public\")

foreach ($dir in $dirs) {
    Create-BeigeSquareIcon 512 ($dir + "icon-512.png")
    Create-BeigeSquareIcon 192 ($dir + "icon-192.png")
    Create-BeigeSquareIcon 180 ($dir + "apple-touch-icon.png")
    Create-BeigeSquareIcon 64  ($dir + "favicon.png")
}

$src.Dispose()
Write-Host "Beige Geely E2 EV icons successfully generated in root and public directories!"
