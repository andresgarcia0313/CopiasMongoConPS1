# Cargar las variables desde el archivo .env
$envFilePath = Join-Path -Path $PSScriptRoot -ChildPath ".env"
if (Test-Path $envFilePath) {
    Write-Host "Cargando variables desde el archivo .env..."
    Get-Content $envFilePath | ForEach-Object {
        if ($_ -match "(.*?)=(.*)") {
            $envVarName = $Matches[1].Trim()
            $envVarValue = $Matches[2].Trim()
            Set-Variable -Name $envVarName -Value $envVarValue -Scope Global
        }
    }
} else {
    Write-Host "El archivo .env no se encontró en la ubicación especificada."
    exit
}

# Resto del script
$date = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
$folder = "$out\$cliente\$database\$date"
Write-Host "Creando carpeta $folder"
New-Item -Path $folder -ItemType Directory -Force
$uri = "mongodb+srv://${user}:${pass}@${server}/${database}?authSource=admin&replicaSet=atlas-nu6ng9-shard-0&readPreference=primary&ssl=true"
mongodump --uri $uri --out $folder
