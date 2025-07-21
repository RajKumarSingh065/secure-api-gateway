# Debug script for secure-api-gateway (PowerShell)

Write-Host "🔍 Starting Debug Process..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

Write-Host "1. Checking Docker status..." -ForegroundColor Yellow
docker --version
docker-compose --version

Write-Host ""
Write-Host "2. Checking if Docker daemon is running..." -ForegroundColor Yellow
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker is running" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
        Write-Host "   On Windows: Start Docker Desktop application" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Stopping any existing containers..." -ForegroundColor Yellow
docker-compose down

Write-Host ""
Write-Host "4. Building and starting services..." -ForegroundColor Yellow
docker-compose up -d --build

Write-Host ""
Write-Host "5. Checking service status..." -ForegroundColor Yellow
Start-Sleep 10
docker-compose ps

Write-Host ""
Write-Host "6. Checking logs for any errors..." -ForegroundColor Yellow
Write-Host "Kong logs:" -ForegroundColor Cyan
docker-compose logs kong --tail=20

Write-Host ""
Write-Host "Backend API logs:" -ForegroundColor Cyan
docker-compose logs backend-api --tail=20

Write-Host ""
Write-Host "7. Testing endpoints..." -ForegroundColor Yellow

Write-Host "Testing Kong Admin API:" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8001/status" -Method Get
    Write-Host "✅ Kong Admin API: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "❌ Kong Admin not responding: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Testing Backend API directly:" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get
    Write-Host "✅ Backend API: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "❌ Backend API not responding: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "Testing through Kong proxy:" -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8000/public" -Method Get
    Write-Host "✅ Kong Proxy: $($response | ConvertTo-Json)" -ForegroundColor Green
} catch {
    Write-Host "❌ Kong proxy not responding: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 Debug complete! Check the output above for any issues." -ForegroundColor Green
