此目录下包含的几个特殊文件夹和文件作用说明如下：

HMSAgent 相关：
1、app 文件夹
		agent 使用示例代码工程模块

2、hmsagents 文件夹
		agent 代码模块（包含所有HMS模块）
		
3、tool 文件夹
		同目录下批处理执行需要的工具包
	
4、GetHMSAgent.bat、GetHMSAgent.sh 脚本文件
		从agent 代码模块（hmsagents 文件夹）中抽取需要模块的agent代码。抽取后的代码放在了同目录下的copysrc目录下
	
5、Buildcopysrc2jar.bat、Buildcopysrc2jar.sh 批处理文件
		用来将GetHMSAgent.bat 生成的代码（copysrc目录下）编译成jar包
		
