Function Get-AllFiles([System.Array] $Folders, [System.Array] $Extensions)
{
    $Files = @()
    Foreach($Folder in $Folders)
    {
        $Files += Get-ChildItem -Recurse -Path "$env:USERPROFILE\$Folder" -Include $Extensions -Force -ErrorAction Ignore | Select-Object -Property Name, DirectoryName
    }
    return $Files
}

Function Decrypt([System.Security.Cryptography.AesManaged] $Cryptor, [System.String] $OldFilePath)
{
	
    $StreamReader = New-Object System.IO.BinaryReader([System.IO.File]::Open($OldFilePath,[System.IO.FileMode]::Open,[System.IO.FileAccess]::Read),[System.Text.Encoding]::Unicode)

    $Length = $StreamReader.BaseStream.Length

    $In = $StreamReader.ReadBytes($Length)
    $StreamReader.Close()

    $Decryptor = $Cryptor.CreateDecryptor()
    $Out = $Decryptor.TransformFinalBlock($In,0,$Length)

    $StreamWriter = New-Object System.IO.BinaryWriter([System.IO.File]::Create($NewFilePath),[System.Text.Encoding]::Unicode)
    $StreamWriter.Write($Out,0,$Out.Length)
    $StreamWriter.Close()
}

#"Desktop","Documents","Pictures","Videos","Music","Downloads"

$Folders = @("Downloads")
$Files = Get-AllFiles $Folders "*.PLOCK"

$Files | % {
    $OldFilePath = $_.DirectoryName+"\"+$_.Name
    $NewFilePath = Get-Content -Path $OldFilePath -Stream "PLOCK.FilePath" -Force
    $Key = Get-Content -Path $OldFilePath -Stream "PLOCK.Key" -Encoding Byte -Force
    $IV = Get-Content -Path $OldFilePath -Stream "PLOCK.IV" -Encoding Byte -Force

    $Cryptor = New-Object System.Security.Cryptography.AesManaged
    $Cryptor.Key = $Key
    $Cryptor.IV = $IV

    Decrypt $Cryptor $OldFilePath $NewFilePath
    Remove-Item -Path $OldFilePath -Force
}