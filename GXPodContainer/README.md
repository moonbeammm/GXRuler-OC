# GXPodContainer
对三方库的封装.
# 使用方法
## 一.不更新三方库
如果你不需要更新三方库.
那直接将GXPodContainer库拖入你的工程即可以使用Podfile中所有引入的三方库.

## 二.更新三方库
如果你需要添加或减少或更新三方库.则需要以下步骤.

1.进入GXPodLinker/ 目录下.
2.更新Podfile文件里的三方库依赖.
3.运行pod install命令.更新三方库
4.打开GXPodLinker.xworkspace.要做两件事.
4.1.打开GXPodLinker -> Build Phases -> Link Binary With Libraries -> 添加刚才你新加的三方库.
4.2.将target更改为GXPodLinkerShell.并commond+B编译.
5.将引用GXPodContainer库的工程的driveData文件夹删除.(清缓存)
6.运行你的工程即可.完工


