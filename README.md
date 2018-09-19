# Dynamics 365 Release Automation Tools
Tools for automation of Dynamics 365 solution deployment

![Usage](https://media.giphy.com/media/dtBYOo7T6APTEHXOno/giphy.gif)



## Installation
To get started clone the repository and run:

```powershell
Import-Module .\module\dynamics365-release-automation-tools
```

**OR**

Module is available in [PowerShell Gallery](https://www.powershellgallery.com/packages/dynamics365-release-automation-tools)

Install the latest version:

```powershell
Install-Module dynamics365-release-automation-tools
```

## Functions

### 1. Update Custom Workflow Steps to the Latest Version

This cmdlet will replace all custom assembly references in the solution ZIP file with the highest build number of the assembly referenced in the solution. NOTE: You have to include the latest Assembly component in the solution! 

```powershell
Update-AssemblyUsageToLatestVersion ..\samples\solutions\test.zip
```

#### Assembly Filter
```powershell
Update-AssemblyUsageToLatestVersion -ZipFileName ..\samples\solutions\test.zip -AssemblyName TNTGTools
```

### 2. Remove Missing Dependencies From solution.xml

There may be a situation when you have all the components in place and solution import should proceed without issues but the solution import wizard throws this error:

*The import of the solution XYZ failed. The following components are missing in your system and are not included in the solution. Import the managed solutions that contain these components (Active) and then try importing this solution again.*

The import wizard does not perform any check whether the component is actually present in the environment.

You can remove it with this cmdlet:

```powershell
Remove-MissingDependencies ..\samples\solutions\test.zip
```

### 3. Replace dependency version with version from specific DLL
```powershell
Update-AssemblyUsageToAssemblyVersion -ZipFileName ..\samples\solutions\test.zip -AssemblyPath ..\samples\assemblies\assembly.dll
```
Alternatively you can use following command to specify the assembly version without the DLL:
```powershell
Update-AssemblyUsageToVersion -ZipFileName ..\samples\solutions\test.zip -AssemblyName Test -AssemblyVersion "1.0.0.0" -AssemblyFQN "TestAssembly.Test, version=1.0.0.0, 
Culture=neutral, PublicKeyToken=123a4b567890c123"
```

## Known Users
If you are using this library and would like to be listed here, please let us know!
- [TheNetworg](https://blog.thenetw.org)

## Contributing
We accept contributions via [Pull Requests on Github](https://github.com/TheNetworg/dynamics365-release-automation-tools).

## Credits
- [Tomas Prokop](https://github.com/TomProkop) ([TheNetw.org](https://thenetw.org))
- [All Contributors](https://github.com/TheNetworg/dynamics365-release-automation-tools/contributors)

## Support
If you find a bug or encounter any issue or have a problem/question with this library please create a [new issue](https://github.com/TheNetworg/dynamics365-release-automation-tools/issues).

## License
The MIT License (MIT). Please see [License File](https://github.com/TheNetworg/dynamics365-release-automation-tools/blob/master/LICENSE) for more information.
