function Test-IPRange {
    param([string]$IPRange)

    $Regex = "(\d{1,3}\.\d{1,3}\.\d{1,3}\.)(\d{1,3})-(\d{1,3})"

    if ($IPRange -notmatch $Regex) {
        Write-Host "Formato de IP no válido. Por favor introduce un rango válido (ej: 192.168.1.1-10)"
        return
    }

    $IPPrefix = $matches[1]
    $StartRange = [int]$matches[2]
    $EndRange = [int]$matches[3]

    $ActiveIPs = @()
    $TotalIPs = $EndRange - $StartRange + 1
    $Count = 0

    for ($i = $StartRange; $i -le $EndRange; $i++) {
        $IP = $IPPrefix + $i
        $Count++
        Write-Progress -Activity "Analizando IP" -Status "Progreso:" -PercentComplete ($Count / $TotalIPs * 100)
        $Reply = Test-Connection -ComputerName $IP -Count 1 -Quiet

        if ($Reply) {
            $ActiveIPs += $IP
            Write-Host "Equipo $IP activo"
        }
    }

    Write-Host "Número de IPs activas encontradas: $($ActiveIPs.Count)"
}

$IPRange = Read-Host "Introduce el rango de IP a analizar (ej: 192.168.1.1-10)"
Test-IPRange $IPRange

