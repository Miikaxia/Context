param(
    [string]$ServerIp = "127.0.0.1",
    [int]$ServerPort = 5000,
    [string]$DisplayName = "User"
)

$client = New-Object System.Net.Sockets.TcpClient($ServerIp, $ServerPort)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$reader = New-Object System.IO.StreamReader($stream)

Write-Host "Connected to $ServerIp`:$ServerPort as $DisplayName"
Write-Host "Type /letmeout to exit."
Write-Host ""

try {
    while ($true) {
        while ($stream.DataAvailable) {
            $line = $reader.ReadLine()
            if ($null -eq $line) {
                Write-Host "[Connection closed by server]"
                break
            }
            Write-Host $line
        }

        if (-not $client.Connected) {
            break
        }

        $msg = Read-Host "You"
        if ($msg -eq "/letmeout") {
            break
        }

        $lineToSend = "$DisplayName|$msg"
        $writer.WriteLine($lineToSend)

        Start-Sleep -Milliseconds 25
    }
}
finally {
    $reader.Dispose()
    $writer.Dispose()
    $stream.Dispose()
    $client.Close()
}