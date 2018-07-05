# Dynamics 365 Release Automation Tools
Tools for automation of Dynamics 365 solutions deployment

## Installation

```
Import-Module .\dynamics365-release-automation-tools.psm1
```

## Usage

### Update Custom Workflow Steps to the Latest Version

This cmdlet will replace all references in the solution ZIP file with the highest build number of the assembly referenced in the solution.

```
Update-AssemblyUsageToLatestVersion ..\samples\solutions\test.zip
```

Assembly Filter
```
Update-AssemblyUsageToLatestVersion -ZipFileName ..\samples\solutions\test.zip -AssemblyName TNTGTools
```

## Known users
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