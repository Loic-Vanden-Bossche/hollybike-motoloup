param(
	[string]$EnvFile = ".env",
	[string]$ExePath = "build/native/nativeCompile/hollybike_server.exe",
	[string]$BindHost = "",
	[string]$Port = ""
)

$ErrorActionPreference = "Stop"

function Set-EnvFromDotenv {
	param([string]$Path)

	if (-not (Test-Path -LiteralPath $Path)) {
		throw "Env file not found: $Path"
	}

	Get-Content -LiteralPath $Path | ForEach-Object {
		$line = $_.Trim()
		if ($line.Length -eq 0) { return }
		if ($line.StartsWith("#")) { return }

		$eq = $line.IndexOf("=")
		if ($eq -lt 1) { return }

		$name = $line.Substring(0, $eq).Trim()
		$value = $line.Substring($eq + 1).Trim()

		if (($value.StartsWith('"') -and $value.EndsWith('"')) -or ($value.StartsWith("'") -and $value.EndsWith("'"))) {
			$value = $value.Substring(1, $value.Length - 2)
		}

		[Environment]::SetEnvironmentVariable($name, $value, "Process")
	}
}

Set-EnvFromDotenv -Path $EnvFile

if ($BindHost -ne "") {
	[Environment]::SetEnvironmentVariable("host", $BindHost, "Process")
}

if ($Port -ne "") {
	[Environment]::SetEnvironmentVariable("port", $Port, "Process")
}

if (-not (Test-Path -LiteralPath $ExePath)) {
	throw "Native executable not found: $ExePath"
}

Write-Host "Starting native backend with env file: $EnvFile"
Write-Host "Executable: $ExePath"

& $ExePath
