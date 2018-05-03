
@echo off
setlocal enabledelayedexpansion

echo.
echo      *************************************************************************************************************
echo      *                                                                                                           *
echo      *    �˹�������Ϊ����ȫ���� HMSAgent ���룬��������ѡ��ɾ������Ҫ�Ĵ���                                     *
echo      *    This tool is: from the full amount of hmsagent code, according to your choice to delete unwanted code  *
echo      *    Ŀǰȫ���������  ��Ϸ��֧������Ϊ�ʺš��罻��push                                                     *
echo      *    Current full code includes game, pay, hwid, sns, push                                                  *
echo      *                                                                                                           *
echo      *    1���������pc�������⵼�½ű�ִ�в��ɹ��������ı��򿪽ű������ű�ע���ֶ�ɾ����ش���                  *
echo      *       If script execution is unsuccessful due to PC environment problems, open the script with text,      *
echo      *       and manually delete the related code by script comment                                              *
echo      *                                                                                                           *
echo      *    2����ȷ�����ű�����·���������ո�                                                                      *
echo      *       Make sure the path to this script does not contain spaces                                           *
echo      *                                                                                                           *
echo      *    3��������Ϸʱ�������֧��                                                                              *
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

CALL :IF_EXIST java.exe || echo ���ĵ��Բ�֧��java���������java����binĿ¼��ӵ�����������PATH�У�&& echo Your computer does not support Java commands, please download Java and add the bin directory to the path of the environment variable!  && pause>nul && exit

set CURPATH=%~dp0

if exist "%CURPATH%copysrc" rd /s /q "%CURPATH%copysrc"
xcopy "%CURPATH%hmsagents\src\main\java\*.*"  "%CURPATH%copysrc\java\" /s /e  /q>nul
xcopy "%CURPATH%app\src\main\AndroidManifest.xml"  "%CURPATH%copysrc\"  /q>nul

echo ������Ӧ�õİ���:
set /p PACKAGE_NAME= Please enter the package name of the application:
if not [%PACKAGE_NAME%] == [] (
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8  "%CURPATH%copysrc\AndroidManifest.xml"  "${PACKAGE_NAME}"  "%PACKAGE_NAME%"
)
echo.
echo ������appid����Դ�ڿ��������ˣ�http://developer.huawei.com/consumer/cn��������Ӧ�÷����appid:
set /p APPID=Please input AppID from the Developer Consortium (http://developer.huawei.com/consumer/cn) for application assignment AppID:
if not [%APPID%] == [] (
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8  "%CURPATH%copysrc\AndroidManifest.xml"  "${APPID}"  "%APPID%"
)
echo.
echo ������cpid����Դ�ڿ��������ˣ�http://developer.huawei.com/consumer/cn��������Ӧ�÷����cpid �� ֧��id:
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
java -jar "%CURPATH%tool/tools.jar" -m replace  -codeformat utf-8 "%CURPATH%copysrc\AndroidManifest.xml"  "android:name=\"com.huawei.hmsagent.HuaweiPushRevicer\""  "android:name=\"${�뽫�˴�˫�����ڵ������滻����������PushReceiver��(Replace the contents of the double quotes here with the PushReceiver class you created)}\""

echo.
echo ����Ӧ���Ƿ��� ����Ϸ�� ��1��ʾ�ǣ� 0��ʾ�񣩣�
set /p NEEDGAME= Your application is "game" ��1 means yes, 0 indicates no ����
@rem ����Ҫ������Ϸ�� No integration games are required��
if  %NEEDGAME% == 0 (
@rem ɾ��com/huawei/android/hms/agent/game �ļ��м�����  Delete com/huawei/android/hms/agent/game folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/game"

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� .game. ����  Delete a line in com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Game."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".game."

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� HuaweiGame.GAME_API ����  Delete rows containing "Huaweigame.game_api" in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiGame.GAME_API"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java������Ϊ Game ����  Delete class with Name "Game" in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Game"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java�а��� .game. ����  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Game."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java" ".game."
)  else (
set NEEDPAY=1
set NEEDHWID=0
)


if [%NEEDPAY%] == [] (
echo ���Ƿ���Ҫ���� ��֧���� ��1��ʾ��Ҫ�� 0��ʾ����Ҫ��:
set /p NEEDPAY=Do you need to integrate "pay" ��1 for required, 0 for No ��  ��
)

@rem ����Ҫ����֧����  No integration payments are required��
if  %NEEDPAY% == 0 (
@rem ɾ��com/huawei/android/hms/agent/pay �ļ��м�����  Delete "Com/huawei/android/hms/agent/pay" folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/pay"

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� .pay. ����  Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Pay."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".pay."

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� HuaweiPay.PAY_API ����  Delete rows containing Huaweipay.pay_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPay.PAY_API"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java������Ϊ Pay ����  Delete class with name Pay in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Pay"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java�а��� .pay. ����  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Pay."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".pay."

@rem  ֻ�м�����Ϸ��֧������cpid  Only integrated games or payments have cpid
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "cpid"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "pay"
)

if [%NEEDHWID%] == [] (
echo ���Ƿ���Ҫ���� ����Ϊ�ʺš� ��1��ʾ��Ҫ�� 0��ʾ����Ҫ����
set /p NEEDHWID=Do you need to integrate "Huawei Account" ��1 for required, 0 means not required ����
)

@rem ����Ҫ���ɻ�Ϊ�ʺ���  No need to integrate Huawei account��
if  %NEEDHWID% == 0  (
@rem ɾ��com/huawei/android/hms/agent/hwid �ļ��м�����  Delete com/huawei/android/hms/agent/hwid folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/hwid"

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� .hwid. ����  Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Hwid."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".hwid."

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� HuaweiId ����  Delete rows containing huaweiid in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiId"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java������Ϊ Hwid ����  Delete class with name Hwid in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Hwid"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java�а��� .hwid. ����  Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Hwid."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".hwid."

@rem ɾ��manifest�ļ���Ϊ�ʺ����� Delete manifest file hwid configuration
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "account"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "HMSSignInAgentActivity"
)

if [%NEEDSNS%] == [] (
echo ���Ƿ���Ҫ���� ���罻�� ��1��ʾ��Ҫ�� 0��ʾ����Ҫ����
set /p NEEDSNS=Do you need to integrate "SNS" ��1 for need, 0 for No �� ��
)

@rem ����Ҫ�����罻��  No need to integrate sns��
if  %NEEDSNS% == 0 (
@rem ɾ��com/huawei/android/hms/agent/sns �ļ��м�����  Delete com/huawei/android/hms/agent/sns folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/sns"

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� .sns. ����  Delete the line in the com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Sns."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".sns."

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� HuaweiSns.API ����  Delete rows containing Huaweisns.api in com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiSns.API"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java������Ϊ Sns ����  Delete a class named Sns in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Sns"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java�а��� .sns. ����  Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Sns."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".sns."
)

if [%NEEDPUSH%] == [] (
echo ���Ƿ���Ҫ���� ��Push�� ��1��ʾ��Ҫ�� 0��ʾ����Ҫ����
set /p NEEDPUSH=Do you need to integrate "Push" ��1 for required, 0 for No �� ��
)

@rem ����Ҫ����Push��  No integration push is required��
if  %NEEDPUSH% == 0 (
@rem ɾ��com/huawei/android/hms/agent/push �ļ��м�����  Delete Com/huawei/android/hms/agent/push folder and content
java -jar "%CURPATH%tool/tools.jar"  -m delFile "%CURPATH%copysrc/java/com/huawei/android/hms/agent/push"

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� .push. ����  Delete the line in the Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Push."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".push."

@rem ɾ��com/huawei/android/hms/agent/common/ApiClientMgr.java�а��� HuaweiPush.PUSH_API ����  Delete rows containing Huaweipush.push_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPush.PUSH_API"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java������Ϊ Push ����  Delete class with name Push in Com/huawei/android/hms/agent/hmsagent.java
java -jar "%CURPATH%tool/tools.jar" -m delBlock "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Push"

@rem ɾ��com/huawei/android/hms/agent/HMSAgent.java�а��� .push. ����   Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Push."
java -jar "%CURPATH%tool/tools.jar" -m delLine "%CURPATH%copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".push."

@rem ɾ��manifest�ļ�push���� Delete manifest file push configuration
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "PUSH"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "push"
java -jar "%CURPATH%tool/tools.jar" -m delXmlBlock "%CURPATH%copysrc\AndroidManifest.xml"  "Push"
)

echo.
echo.
echo �ű�ͬ��Ŀ¼�µ� copysrc ���漴Ϊ��ȡ��Ĵ��룬�ɽ�����Ĵ��뿽�������Ĺ��̴�����
echo The "copysrc" folder in the script sibling directory is the extracted code, which copies the code in your engineering code
echo �����������&echo Press any key to end &pause>nul

:IF_EXIST
SETLOCAL&PATH %PATH%;%~dp0;%cd%
if "%~$PATH:1"=="" exit /b 1
exit /b 0