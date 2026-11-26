# Instala a equipe de especialistas no Claude Code e prepara os arquivos do MausBot.
# Uso: powershell -ExecutionPolicy Bypass -File .\install.ps1 -Nome "SeuNome"
param(
    [Parameter(Mandatory = $true)][string]$Nome,
    [string]$ClaudeDir = (Join-Path $HOME '.claude'),
    [string]$ToolsDir = (Join-Path $HOME 'tools'),
    [string]$MausbotDir = '',
    [switch]$SemTerceiros
)
$ErrorActionPreference = 'Stop'
$Raiz = $PSScriptRoot
$Saida = Join-Path $Raiz 'saida\mausbot'
if (-not $MausbotDir) { $MausbotDir = $Saida }
$Utf8 = New-Object System.Text.UTF8Encoding($false)

function Converter-Texto([string]$Texto) {
    $Texto.Replace('{{NOME}}', $Nome).Replace('{{CLAUDE_DIR}}', $ClaudeDir).Replace('{{TOOLS_DIR}}', $ToolsDir).Replace('{{MAUSBOT_DIR}}', $MausbotDir)
}
function Copiar-Convertendo([string]$De, [string]$Para) {
    New-Item -ItemType Directory -Force (Split-Path $Para) | Out-Null
    $t = [System.IO.File]::ReadAllText($De, $Utf8)
    [System.IO.File]::WriteAllText($Para, (Converter-Texto $t), $Utf8)
}
function Copiar-Pasta([string]$De, [string]$Para) {
    Get-ChildItem -LiteralPath $De -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($De.Length).TrimStart('\')
        Copiar-Convertendo $_.FullName (Join-Path $Para $rel)
    }
}

# 1. Skills de terceiros
if (-not $SemTerceiros) {
    $Vendor = Join-Path $ClaudeDir 'skills\vendor'
    New-Item -ItemType Directory -Force $Vendor | Out-Null
    $Repos = @(
        @{ Pasta = 'obra_superpowers'; Url = 'https://github.com/obra/superpowers.git'; Commit = '22f0b463e7a5e579904dd6211a520321035526f7' },
        @{ Pasta = 'mattpocock_skills'; Url = 'https://github.com/mattpocock/skills.git'; Commit = '6f7f7831a625f040a8e06a0e7954826b87ce775a' },
        @{ Pasta = 'trailofbits_skills'; Url = 'https://github.com/trailofbits/skills.git'; Commit = '149d7b21f4067765b82e67029730b42d228ef4b4' },
        @{ Pasta = 'deanpeters_Product-Manager-Skills'; Url = 'https://github.com/deanpeters/Product-Manager-Skills.git'; Commit = '476ae12917b8e77609eb956bcc2203a4e4ec857d' },
        @{ Pasta = 'K-Dense-AI_scientific-agent-skills'; Url = 'https://github.com/K-Dense-AI/scientific-agent-skills.git'; Commit = 'c21d13b3cc2894680229ba9959a53281acb9200e' }
    )
    foreach ($r in $Repos) {
        $dest = Join-Path $Vendor $r.Pasta
        if (Test-Path $dest) { Write-Host "ja existe: $($r.Pasta)"; continue }
        Write-Host "baixando $($r.Url)"
        git clone --quiet --filter=blob:none $r.Url $dest
        if ($LASTEXITCODE -ne 0) { throw "falhou ao clonar $($r.Url)" }
        git -C $dest checkout --quiet $r.Commit
        if ($LASTEXITCODE -ne 0) { Write-Warning "commit testado nao encontrado em $($r.Pasta); ficou a versao mais nova" }
    }
    $Pacotes = @(
        @('heygen-com/hyperframes', 'hyperframes,hyperframes-cli,hyperframes-registry'),
        @('remotion-dev/skills', '*'),
        @('Leonxlnx/earshot', '*'),
        @('kajisho5/ffmpeg-skill', '*'),
        @('coreyhaines31/marketingskills', 'video,ad-creative'),
        @('morluto/rea', 'reverse-engineer-anything')
    )
    foreach ($p in $Pacotes) {
        Write-Host "instalando skills de $($p[0])"
        npx -y skills add $p[0] -g -a claude-code -s $p[1] -y --copy
        if ($LASTEXITCODE -ne 0) { Write-Warning "nao instalou $($p[0]); rode depois: npx skills add $($p[0]) -g" }
    }
}

# 2. Claude Code: agentes e skill do protocolo
Get-ChildItem (Join-Path $Raiz 'claude-code\agents') -Filter *.md | ForEach-Object {
    Copiar-Convertendo $_.FullName (Join-Path $ClaudeDir "agents\$($_.Name)")
}
Copiar-Pasta (Join-Path $Raiz 'claude-code\skills\equipe') (Join-Path $ClaudeDir 'skills\equipe')
Write-Host "agentes instalados em $(Join-Path $ClaudeDir 'agents')"

# 3. MausBot: instrucoes finais, skill do lider e ciclo de aprendizado
Copiar-Pasta (Join-Path $Raiz 'mausbot\bots') (Join-Path $Saida 'bots')
Copiar-Pasta (Join-Path $Raiz 'mausbot\skills') (Join-Path $Saida 'skills')
$Equipe = Join-Path $MausbotDir 'equipe'
foreach ($f in 'registro.md', 'licoes.md') {
    $dest = Join-Path $Equipe $f
    if (Test-Path $dest) { Write-Host "mantido (ja existia): $dest" } else { Copiar-Convertendo (Join-Path $Raiz "mausbot\equipe\$f") $dest }
}
New-Item -ItemType Directory -Force (Join-Path $Equipe 'propostas') | Out-Null
Write-Host "arquivos do MausBot em $Saida"
Write-Host 'pronto. Veja o README para ligar as ferramentas (MCP) e criar os bots no MausBot.'
