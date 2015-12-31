UIView-Extension
==================================================
A extension class makes you easier to use frame. Are you tired with writting frame.<br>
一个帮助你简化frame的扩展类。
####BEFORE
```oc
CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height * 0.9)
```
Now you got UIView+Extension,Frame is way easier to use.<br>
现在有了UIView+Extension事情就简单了。
####NOW
```oc
CGRectMake(self.view.x,self.view.y,self.view.width,self.view.height * 0.9)
```
#How to Use
Drag `UIView+Extension.h`,`UIView+Extension.m` to you project. Then `import "UIView+Extension.h"`. 将`UIView+Extension.h`,`UIView+Extension.m`加入你的工程，在使用的文件`import "UIView+Extension.h"`。
