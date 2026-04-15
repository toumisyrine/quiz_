# Kids Game Sound Downloader
# This script downloads free sound effects for the kids game

Write-Host "🔊 Kids Game Sound Downloader" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$soundsDir = "src/assets/sounds"

# Create sounds directory if it doesn't exist
if (-not (Test-Path $soundsDir)) {
    New-Item -ItemType Directory -Path $soundsDir -Force | Out-Null
}

Write-Host "Downloading free sound effects..." -ForegroundColor Yellow
Write-Host ""

# Download sounds from Mixkit (free, no attribution required)
try {
    # Correct sound (success chime)
    Write-Host "📥 Downloading correct.mp3..." -ForegroundColor Green
    Invoke-WebRequest -Uri "https://assets.mixkit.co/active_storage/sfx/2018/2018-preview.mp3" -OutFile "$soundsDir/correct.mp3"
    Write-Host "✅ correct.mp3 downloaded!" -ForegroundColor Green
    
    # Wrong sound (error buzzer)
    Write-Host "📥 Downloading wrong.mp3..." -ForegroundColor Red
    Invoke-WebRequest -Uri "https://assets.mixkit.co/active_storage/sfx/2955/2955-preview.mp3" -OutFile "$soundsDir/wrong.mp3"
    Write-Host "✅ wrong.mp3 downloaded!" -ForegroundColor Green
    
    # Click sound (button click)
    Write-Host "📥 Downloading click.mp3..." -ForegroundColor Blue
    Invoke-WebRequest -Uri "https://assets.mixkit.co/active_storage/sfx/2568/2568-preview.mp3" -OutFile "$soundsDir/click.mp3"
    Write-Host "✅ click.mp3 downloaded!" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🎉 All sounds downloaded successfully!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Restart your Angular dev server (npm start)" -ForegroundColor White
    Write-Host "2. Go to http://localhost:4200/kids" -ForegroundColor White
    Write-Host "3. Play the game and enjoy the sounds! 🎮" -ForegroundColor White
    
} catch {
    Write-Host ""
    Write-Host "❌ Error downloading sounds: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative method:" -ForegroundColor Yellow
    Write-Host "1. Open src/assets/sounds/generate-sounds.html in your browser" -ForegroundColor White
    Write-Host "2. Click the buttons to generate sounds" -ForegroundColor White
    Write-Host "3. Save the files in src/assets/sounds/" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
