@echo off
setlocal
@chcp 65001
REM 管理员
net.exe session 1>NUL 2>NUL && (
REM 没有
) || (
   echo 您未使用管理员身份运行！请右键文件并点击“以管理员身份运行”
   pause
   exit
)
REM 管理员

REM 添加HOSTS
for /f "tokens=*" %%i in ('curl -s http://mtbip.sincos.email') do set ip=%%i
REM 输出获取的 IP 地址
echo 成功获取到新的MTB服务器IP: %ip%

echo "请注意你的杀毒软件提示，一定要允许，因为此操作会修改hosts改变IP解析"
@echo  ########################################
@xcopy C:\Windows\system32\drivers\etc\hosts C:\Windows\system32\drivers\etc\hosts.mtbak\ /d /c /i /y 
@echo  ########################################
@echo  hosts文件备份完毕，开始修改hosts文件
@echo # MTB加速服务(https://starnetx.top) >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% launcher.mojang.com >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% launchermeta.mojang.com >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% piston-meta.mojang.com >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% resources.download.minecraft.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% libraries.minecraft.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% maven.minecraftforge.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% files.minecraftforge.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% maven.neoforged.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% maven.fabricmc.net >>C:\Windows\System32\drivers\etc\hosts
@echo %ip% maven.quiltmc.org >>C:\Windows\System32\drivers\etc\hosts


echo   "hosts文件修改完成 "
@ipconfig /flushdns
@echo   "刷新DNS完成

echo "下载根证书"
powershell Invoke-WebRequest -Uri "http://mtbip.sincos.email/TCA.cer" -OutFile "C:\TCA.cer"
certutil -addstore -f "Root" "C:\TCA.cer"
echo "系统根证书安装完毕"





pause
endlocal