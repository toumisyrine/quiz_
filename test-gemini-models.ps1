$apiKey = "AIzaSyDRjSoMWQKu7htQMlG9TWTjOEU8Nc_EvGA"
$url = "https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey"

try {
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Available Models:"
    $models = $response.Content | ConvertFrom-Json
    foreach ($model in $models.models) {
        if ($model.supportedGenerationMethods -contains "generateContent") {
            Write-Host "✓ $($model.name) - $($model.displayName)"
        }
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}