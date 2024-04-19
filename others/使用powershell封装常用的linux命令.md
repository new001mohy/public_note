# 使用powershell定义你的命令

对于一些经常使用 Linux 的朋友来说，Windows 的 PowerShell 使用起来十分地不方便。当习惯性地敲击命令后发行 PowerShell 中并没有这个命令导致报错，这让人十分恼火。
又或者一些工具的命令很繁琐，你希望可以给这一长串的命令起一个简单的名字。
我们就可以使用一些简单的 PowerShell 配置去封装我们常用的 Linux 命令来提高我们的效率。

这里的封装，指的是使用 PowerShell 去自定义命令的别名。

## 步骤

1. 通过 `$profile` 找到 PowerShell 的 profile的位置，但是这个文件不一定存在，可以使用命令 `Test-Path $profile` 进行测试，如果结果为 false，证明没有这个文件，需要创建。
2. 通过命令 `New-Item -path $profile -itemtype file -Force` 创建文件。
3. 找到这个文件，在里面写函数即可，一般位置为 `C:\Users\用户名\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`。
4. 在文件中定义函数。然后管理员执行 `Set-ExecutionPolicy RemoteSigned`。

```powershell
# 无参
function nrs {
    npm run serve
}

#带参
function touch {
    New-Item $args
}

```

## 常用的命令

### touch

我们经常使用 `touch` 创建文件。

```powershell
function touch {
    [CmdletBinding()]
    param()
    $FileNames = $args
    foreach ($fileName in $FileNames) {
        New-Item $fileName -ItemType File -Force | Out-Null
    }
}
```
