@echo off
chcp 65001
setlocal enabledelayedexpansion
echo 输入Java路径的请不要带\bin 当出现“是否信任此证书? [否]:”输入y 回车
:inputJavaPath
set "javapath="
set /p "javapath=请输入Java路径（或者直接按Enter键遍历检索）: "

if not "%javapath%"=="" (
    if exist "%javapath%\bin\java.exe" (
        echo Java路径已设置为：%javapath%
        goto end
    ) else (
        echo 输入的路径无效或java.exe不存在，请重试。
        goto inputJavaPath
    )
)

echo 开始遍历检索Java路径...

set "javapath_list="
set "index=0"
for /r "C:\" %%i in (java.exe) do (
    if exist "%%i" (
        set /a index+=1
        set "javapath_list=!javapath_list!%%~dpi..|"
        echo !index! - %%~dpi..
    )
)

if "%index%"=="0" (
    echo 未找到Java路径，请手动输入。
    goto inputJavaPath
)

:selectJavaPath
set "selection="
set /p "selection=请输入要使用的Java路径编号（1到%index%）: "

set "selectedPath="
for /l %%i in (1,1,%index%) do (
    if "!selection!"=="%%i" (
        for /f "tokens=1,* delims=|" %%k in ("!javapath_list!") do (
            if not defined selectedPath (
                set "selectedPath=%%~k"
                goto endSelection
            )
        )
    )
)

:endSelection
if defined selectedPath (
    set "javapath=%selectedPath%"
    goto end
) else (
    echo 输入无效，请重试。
    goto selectJavaPath
)

:end
echo 最终使用的Java路径是：%javapath% 即将使用powershell下载证书 请允许杀软使用powershell
powershell Invoke-WebRequest -Uri "http://mtbip.sincos.email/TCA.cer" -OutFile "C:\TCA.cer"
%javapath%\bin\keytool.exe -import -alias TCA -file "C:\TCA.cer" -keystore "%javapath%\lib\security\cacerts" -storepass changeit

rem 在这里添加你需要执行的其他命令，比如设置JAVA_HOME或运行Java程序
pause
