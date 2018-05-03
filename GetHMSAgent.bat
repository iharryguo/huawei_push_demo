
@echo off
setlocal enabledelayedexpansion

echo.
echo      *************************************************************************************************************
echo      *                                                                                                           *
echo      *    此工具作用为：从全量的 HMSAgent 代码，根据您的选择删除不需要的代码                                     *
echo      *    This tool is: from the full amount of hmsagent code, according to your choice to delete unwanted code  *
echo      *    目前全量代码包括  游戏、支付、华为帐号、社交、push                                                     *
echo      *    Current full code includes game, pay, hwid, sns, push                                                  *
echo      *                                                                                                           *
echo      *    1、如果由于pc环境问题导致脚本执行不成功，请用文本打开脚本，按脚本注释手动删除相关代码                  *
echo      *       If script execution is unsuccessful due to PC environment problems, open the script with text,      *
echo      *       and manually delete the related code by script comment                                              *
echo      *                                                                                                           *
echo      *    2、请确保本脚本所在路径不包含空格                                                                      *
echo      *       Make sure the path to this script does not contain spaces                                           *
echo      *                                                                                                           *
echo      *    3、接入游戏时必须接入支付                                                                              *
echo      *       Access to the game must be connected to pay                                                         *
echo      *                                                                                                           *
echo      *************************************************************************************************************
echo.

if defined JAVA_HOME (
 set JAVA_HOME=!JAVA_HOME:"=!
 set JAVA_PATH=!JAVA_HOME!/bin
 set JAVA_PATH=!JAVA_PATH:\/=/!
 set JAVA_PATH=!JAVA_PATH://=/!
 set PATH=!PATH!;!JAVA_PATH!
)

CALL :IF_EXIST java.exe || echo 您的电脑不支持java命令，请下载java并将bin目录添加到环境变量的PATH中！&& echo Your computer does not support Java commands, please download Java and add the bin directory to the path of the environment variable!  && pause>nul && exit

set CURPATH=%~dp0

if exist "%CURPATH%copysrc" rd /s /q "%CURPATH%copysrc"
xcopy "%CURPATH%hmsagents\src\main\java\*.*"  "%CURPATH%copysrc\java\" /s /e  /q>nul
xcopy "%CURPATH%app\src\main\AndroidManifest.xml"  "%CURPATH%copysrc\"  /q>nul

echo 请输入应用的包名:
set /p PACKAGE_NAME= Please enter the package name of the application:
if not [%PACKAGE_NAME%] == [] (
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8  "%CURPATH%copysrc\AndroidManifest.xml"  "${PACKAGE_NAME}"  "%PACKAGE_NAME%"
)
echo.
echo 请输入appid，来源于开发者联盟（http://developer.huawei.com/consumer/cn）上申请应用分配的appid:
set /p APPID=Please input AppID from the Developer Consortium (http://developer.huawei.com/consumer/cn) for application assignment AppID:
if not [%APPID%] == [] (
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8  "%CURPATH%copysrc\AndroidManifest.xml"  "${APPID}"  "%APPID%"
)
echo.
echo 请输入cpid，来源于开发者联盟（http://developer.huawei.com/consumer/cn）上申请应用分配的cpid 或 支付id:
set /p CPID=Please enter cpid, from the cpid or payid for application assignment from the Developer Federation (http://developer.huawei.com/consumer/cn):
if not [%CPID%] == [] (
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8 "%CURPATH%copysrc\AndroidManifest.xml"  "${CPID}"  "%CPID%"
)


java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc\AndroidManifest.xml"  "MyApplication"
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc\AndroidManifest.xml"  "drawable/ic_launcher"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "GameActivity"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "PayActivity"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "HwIDActivity"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "SnsActivity"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "PushActivity"
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8 "%CURPATH%copysrc\AndroidManifest.xml"  "package=\"com.huawei.hmsagent\""  ""
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8 "%CURPATH%copysrc\AndroidManifest.xml"  "android:name=\"com.huawei.hmsagent.HuaweiPushRevicer\""  "android:name=\"${请将此处双引号内的内容替换成您创建的PushReceiver类(Replace the contents of the double quotes here with the PushReceiver class you created)}\""

echo.
echo 您的应用是否是 “游戏” （1表示是， 0表示否）：
set /p NEEDGAME= Your application is "game" （1 means yes, 0 indicates no ）：
@rem 不需要集成游戏则 No integration games are required：
if  %NEEDGAME% == 0 (
@rem 删除com/huawei/android/hms/agent/game 文件夹及内容  Delete com/huawei/android/hms/agent/game folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/game"

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .game. 的行  Delete a line in com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Game."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".game."

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiGame.GAME_API 的行  Delete rows containing "Huaweigame.game_api" in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiGame.GAME_API"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Game 的类  Delete class with Name "Game" in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Game"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .game. 的行  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Game."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java" ".game."
)  else (
set NEEDPAY=1
set NEEDHWID=0
)


if [%NEEDPAY%] == [] (
echo 您是否需要集成 “支付” （1表示需要， 0表示不需要）:
set /p NEEDPAY=Do you need to integrate "pay" （1 for required, 0 for No ）  ：
)

@rem 不需要集成支付则  No integration payments are required：
if  %NEEDPAY% == 0 (
@rem 删除com/huawei/android/hms/agent/pay 文件夹及内容  Delete "Com/huawei/android/hms/agent/pay" folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/pay"

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .pay. 的行  Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Pay."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".pay."

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiPay.PAY_API 的行  Delete rows containing Huaweipay.pay_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPay.PAY_API"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Pay 的类  Delete class with name Pay in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Pay"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .pay. 的行  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Pay."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".pay."

@rem  只有集成游戏或支付才有cpid  Only integrated games or payments have cpid
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "cpid"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "pay"
)

if [%NEEDHWID%] == [] (
echo 您是否需要集成 “华为帐号” （1表示需要， 0表示不需要）：
set /p NEEDHWID=Do you need to integrate "Huawei Account" （1 for required, 0 means not required ）：
)

@rem 不需要集成华为帐号则  No need to integrate Huawei account：
if  %NEEDHWID% == 0  (
@rem 删除com/huawei/android/hms/agent/hwid 文件夹及内容  Delete com/huawei/android/hms/agent/hwid folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/hwid"

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .hwid. 的行  Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Hwid."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".hwid."

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiId 的行  Delete rows containing huaweiid in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiId"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Hwid 的类  Delete class with name Hwid in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Hwid"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .hwid. 的行  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Hwid."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".hwid."

@rem 删除manifest文件华为帐号配置 Delete manifest file hwid configuration
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "account"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "HMSSignInAgentActivity"
)

if [%NEEDSNS%] == [] (
echo 您是否需要集成 “社交” （1表示需要， 0表示不需要）：
set /p NEEDSNS=Do you need to integrate "SNS" （1 for need, 0 for No ） ：
)

@rem 不需要集成社交则  No need to integrate sns：
if  %NEEDSNS% == 0 (
@rem 删除com/huawei/android/hms/agent/sns 文件夹及内容  Delete com/huawei/android/hms/agent/sns folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/sns"

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .sns. 的行  Delete the line in the com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Sns."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".sns."

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiSns.API 的行  Delete rows containing Huaweisns.api in com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiSns.API"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Sns 的类  Delete a class named Sns in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Sns"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .sns. 的行  Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Sns."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".sns."
)

if [%NEEDPUSH%] == [] (
echo 您是否需要集成 “Push” （1表示需要， 0表示不需要）：
set /p NEEDPUSH=Do you need to integrate "Push" （1 for required, 0 for No ） ：
)

@rem 不需要集成Push则  No integration push is required：
if  %NEEDPUSH% == 0 (
@rem 删除com/huawei/android/hms/agent/push 文件夹及内容  Delete Com/huawei/android/hms/agent/push folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/push"

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .push. 的行  Delete the line in the Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Push."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".push."

@rem 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiPush.PUSH_API 的行  Delete rows containing Huaweipush.push_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPush.PUSH_API"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Push 的类  Delete class with name Push in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Push"

@rem 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .push. 的行   Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Push."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".push."

@rem 删除manifest文件push配置 Delete manifest file push configuration
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "PUSH"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "push"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "Push"
)

echo.
echo.
echo 脚本同级目录下的 copysrc 里面即为抽取后的代码，可将里面的代码拷贝的您的工程代码中
echo The "copysrc" folder in the script sibling directory is the extracted code, which copies the code in your engineering code
echo 按任意键结束&echo Press any key to end &pause>nul

:IF_EXIST
SETLOCAL&PATH %PATH%;%~dp0;%cd%
if "%~$PATH:1"=="" exit /b 1
exit /b 0