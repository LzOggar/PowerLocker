# PowerLocker
PowerLocker is a basic cryptolocker write in Powershell. It only used as educational purpose.

# Usage
[Warning]: You should use these scripts in Virtual Environment.

1. Use the script Encryptor.ps1 to crypt data.
2. Use the script Decryptor.ps1 to decrypt data.

# How it works ?
1. The script Encryptor.ps1 will find a list of files specified in $Extensions variable in specified folders defined in $Folders variable then it will start to encrypt these files with random symetric key. The symetric key is stored in datastream of the encrypted file.

2. The script Decryptor.ps1 will find all files with .PLOCK extensions in specified folders defined in $Folders variable then it will decrypt all files found.

# Authors
**LzOggar**
