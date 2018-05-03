#!/bin/sh
echo      "**************************************************************************************************************"
echo      "*                                                                                                            *"
echo      "*    此工具作用为：从全量的 HMSAgent 代码，根据您的选择删除不需要的代码                                      *"
echo      "*    This tool is: from the full amount of hmsagent code, according to your choice to delete unwanted code   *"
echo      "*    目前全量代码包括  游戏、支付、华为帐号、社交、push                                                      *"
echo      "*    Current full code includes games, payments, Huawei accounts, social, push                               *"
echo      "*                                                                                                            *"
echo      "*    1、如果由于pc环境问题导致脚本执行不成功，请用文本打开脚本，按脚本注释手动删除相关代码                   *"
echo      "*          If script execution is unsuccessful due to PC environment problems, open the script with text,    *"
echo      "*          and manually delete the related code by script comment                                            *" 
echo      "*                                                                                                            *"
echo      "*    2、请确保本脚本所在路径不包含空格                                                                       *"
echo      "*           Make sure the path to this script does not contain spaces                                        *"
echo      "*                                                                                                            *"
echo      "*    3、接入游戏时必须接入支付                                                                               *"
echo      "*          Access to the game must be connected to pay                                                       *"
echo      "*                                                                                                            *"
echo      "**************************************************************************************************************"

function recursive_copy_file()
{
   dirlist=$(ls "$1")
   for name in ${dirlist[*]}
   do
       if [ -f "$1/$name" ]; then
           # 如果是文件，并且$2不存在该文件，则直接copy | If it is a file and the file does not exist in $ $, direct copy
            if [ ! -f "$2/$name" ]; then
                cp "$1/$name" "$2/$name"
            fi
        elif [ -d "$1/$name" ]; then
            # 如果是目录，并且$2不存在该目录，则先创建目录 | If it is a directory, and the catalog does not exist, create the directory first
            if [ ! -d "$2/$name" ]; then
                mkdir -p "$2/$name"
            fi
            # 递归拷贝 | Recursive copy
            recursive_copy_file "$1/$name" "$2/$name"
        fi
    done
}

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

echo ${JAVACMD} 


CURPATH="$( cd "$( dirname "$0"  )" && pwd)/"
echo "${CURPATH}hmsagents/src/main/java/"

rm -rf  "${CURPATH}copysrc"
mkdir "${CURPATH}copysrc/"
mkdir "${CURPATH}copysrc/java/" 
recursive_copy_file "${CURPATH}hmsagents/src/main/java/"  "${CURPATH}copysrc/java/" 
cp "${CURPATH}app/src/main/AndroidManifest.xml"  "${CURPATH}copysrc/AndroidManifest.xml" 

echo "请输入应用的包名:"
echo "Please enter the package name of the application:"
read PACKAGE_NAME
if  [ "$PACKAGE_NAME" != "" ] ; then
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m replace  -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/AndroidManifest.xml"  "\${PACKAGE_NAME}"  "${PACKAGE_NAME}"
fi
echo ""
echo "请输入appid，来源于开发者联盟（http://developer.huawei.com/consumer/cn）上申请应用分配的appid:"
echo "Please input AppID from the Developer Consortium (http://developer.huawei.com/consumer/cn) for application assignment AppID:"
read APPID
if  [ "$APPID" != "" ] ; then
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m replace  -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/AndroidManifest.xml"  "\${APPID}"  "${APPID}"
fi
echo ""
echo "请输入cpid，来源于开发者联盟（http://developer.huawei.com/consumer/cn）上申请应用分配的cpid 或 支付id:"
echo "Please enter cpid, from the cpid or payid for application assignment from the Developer Federation (http://developer.huawei.com/consumer/cn):"
read CPID
if  [ "$CPID" != "" ] ; then
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m replace    -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/AndroidManifest.xml"  "\${CPID}"  "${CPID}"
fi


"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine   -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "MyApplication"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine   -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/AndroidManifest.xml"  "drawable/ic_launcher"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "GameActivity"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "PayActivity"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "HwIDActivity"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "SnsActivity"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock   -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/AndroidManifest.xml"  "PushActivity"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m replace  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "package=\"com.huawei.hmsagent\""  ""
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m replace   -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "android:name=\"com.huawei.hmsagent.HuaweiPushRevicer\""  "android:name=\"\${请将此处双引号内的内容替换成您创建的Receiver类(Replace the contents of the double quotes here with the receiver class you created)}\""

NEEDGAME="";
NEEDPAY="";
NEEDHWID="";
NEEDSNS="";
NEEDPUSH="";

echo ""
if [ "$NEEDGAME" == "" ] ; then
echo "您的应用是否是 “游戏” （1表示是， 0表示否）："
echo "Do you need to integrate 'game' (1 for required, 0 for unwanted):"
read NEEDGAME
fi
# 不需要集成游戏则 | No integration games are required：
if  [ "$NEEDGAME" == "0" ] ; then
# 删除com/huawei/android/hms/agent/game 文件夹及内容 | Delete com/huawei/android/hms/agent/game folder and content
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar"  -m delFile -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/game"

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .game. 的行 | Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Game."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".game."

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiGame.GAME_API 的行 |  Delete rows containing Huaweigame.game_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiGame.GAME_API"

# 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Game 的类 | Delete class with name Game in Com/huawei/android/hms/agent/hmsagent.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delBlock -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Game"

# 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .game. 的行 | Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Game."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java" ".game."

else
	NEEDPAY="1";
	NEEDHWID="0";
fi


if [ "$NEEDPAY" == "" ] ; then
echo "您是否需要集成 “支付” （1表示需要， 0表示不需要）："
echo "Do you need to integrate 'pay' (1 for required, 0 for No):"
read NEEDPAY
fi
# 不需要集成支付则 | No integration payments are required：
if  [ "$NEEDPAY" == "0" ] ; then
# 删除com/huawei/android/hms/agent/pay 文件夹及内容 | Delete Com/huawei/android/hms/agent/pay folder and content
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar"  -m delFile -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/pay"

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .pay. 的行 | Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Pay."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".pay."

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiPay.PAY_API 的行 | Delete rows containing Huaweipay.pay_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPay.PAY_API"

# 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Pay 的类 | Delete class with name Pay in Com/huawei/android/hms/agent/hmsagent.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delBlock -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Pay"

# 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .pay. 的行 | Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Pay."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".pay."

# 只有集成游戏或支付才有cpid  Only integrated games or payments have cpid
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "cpid"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "pay"
fi


if [ "$NEEDHWID" == "" ] ; then
echo "您是否需要集成 “华为帐号” （1表示需要， 0表示不需要）："
echo "Do you need to integrate 'Huawei Account' (1 for required, 0 means not required):"
read NEEDHWID
fi
# 不需要集成华为帐号则 | No need to integrate Huawei account：
if  [ "$NEEDHWID" == "0" ] ; then

# 删除com/huawei/android/hms/agent/hwid 文件夹及内容 | Delete Com/huawei/android/hms/agent/hwid folder and content
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar"  -m delFile -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/hwid"

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .hwid. 的行 | Delete a line in Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Hwid."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".hwid."

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiId 的行 | Delete rows containing huaweiid in Com/huawei/android/hms/agent/common/apiclientmgr.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiId"

# 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Hwid 的类 | Delete class with name Hwid in Com/huawei/android/hms/agent/hmsagent.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delBlock -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Hwid"

# 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .hwid. 的行 | Delete a line in Com/huawei/android/hms/agent/hmsagent.java that contains ". Hwid."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".hwid."

# 删除manifest文件华为帐号配置 Delete manifest file hwid configuration
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "account"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "HMSSignInAgentActivity"
fi


if [ "$NEEDSNS" == "" ] ; then
echo "您是否需要集成 “社交” （1表示需要， 0表示不需要）："
echo "Do you need to integrate 'sns' (1 for need, 0 for No):"
read NEEDSNS
fi
# 不需要集成社交则 | No need to integrate sns：
if  [ "$NEEDSNS" == "0" ] ; then
# 删除com/huawei/android/hms/agent/sns 文件夹及内容 | Delete Com/huawei/android/hms/agent/sns folder and content
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar"  -m delFile -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/sns"

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .sns. 的行 | Delete the line in the Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Sns."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".sns."

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiSns.API 的行 | Delete rows containing Huaweisns.api in Com/huawei/android/hms/agent/common/apiclientmgr.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiSns.API"

# 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Sns 的类 | Delete a class named Sns in Com/huawei/android/hms/agent/hmsagent.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delBlock -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Sns"

# 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .sns. 的行 | Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Sns."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".sns."
fi


if [ "$NEEDPUSH" == "" ] ; then
echo "您是否需要集成 “Push” （1表示需要， 0表示不需要）："
echo "Do you need to integrate 'Push' (1 for required, 0 for No):"
read NEEDPUSH
fi
# 不需要集成Push则 | No integration push is required：
if  [ "$NEEDPUSH" == "0" ] ; then
# 删除com/huawei/android/hms/agent/push 文件夹及内容 |  Delete Com/huawei/android/hms/agent/push folder and content
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar"  -m delFile -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/push"

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 .push. 的行 | Delete the line in the Com/huawei/android/hms/agent/common/apiclientmgr.java that contains ". Push."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  ".push."

# 删除com/huawei/android/hms/agent/common/ApiClientMgr.java中包含 HuaweiPush.PUSH_API 的行 | Delete rows containing Huaweipush.push_api in Com/huawei/android/hms/agent/common/apiclientmgr.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/common/ApiClientMgr.java"  "HuaweiPush.PUSH_API"

# 删除com/huawei/android/hms/agent/HMSAgent.java中名称为 Push 的类 | Delete class with name Push in Com/huawei/android/hms/agent/hmsagent.java
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delBlock -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  "class Push"

# 删除com/huawei/android/hms/agent/HMSAgent.java中包含 .push. 的行 | Delete the line in the Com/huawei/android/hms/agent/hmsagent.java that contains ". Push."
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delLine -codeformat utf-8 -linechar rn  "${CURPATH}copysrc/java/com/huawei/android/hms/agent/HMSAgent.java"  ".push."

# 删除manifest文件push配置 Delete manifest file push configuration
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "PUSH"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "push"
"$JAVACMD"  -jar "${CURPATH}tool/tools.jar" -m delXmlBlock  -codeformat utf-8 -linechar rn   "${CURPATH}copysrc/AndroidManifest.xml"  "Push"
fi

echo  " "
echo " "
echo "脚本同级目录下的 copysrc 里面即为抽取后的代码，可将里面的代码拷贝的您的工程代码中"
echo "The copysrc folder in the script sibling is the extracted code, which copies the code in your engineering code"
echo "按回车键结束"
echo  "Press ENTER to exit"
read

