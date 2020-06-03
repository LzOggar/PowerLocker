# PowerLocker
PowerLocker is a basic cryptolocker write in Powershell.

# Usage
Use the script Encryptor.ps1 to crypt data.
Use the script Decryptor.ps1 to decrypt data.

PowerLocker is used only for educational purposes.

# How it works ?
The script Encryptor.ps1 will find a list of files (see variable $Extensions) in specified folders (see variable $Folders) then it will start to encrypt these files with random symetric key. The symetric key is stored in datastream of the encrypted file.

The script Decryptor.ps1 will find all files with .PLOCK extensions in specified folders then it will decrypt all files found.

# Authors
**LzOggar**
