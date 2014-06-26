DragonBonesCPP
======================
DragonBones开发组已经开发了 [DragonBonesCPP][dbcpp] 版本，支持 cocos2d-x 2.x 和 3.x 引擎。因此，建议改用 DragonBonesCPP，并使用官方的 [DragonBones DesignPanel][offical] 。

详细介绍请看这里：[DragonBones 官方C++版本 for cocos2d-x][ccarmature2dbcpp] 。

DragonBones2.2 for cocos2d-x
======================

基于 [这里提到的原因][db224cocos2dx]，我以DragonBones2.2版本为基础制作了这个插件，并重新打包发布。

我做的工作并不多，只是花了一些时间理解了DragonBonesDesignPanel的结构。

* 这个项目包含了 [SkeletonAnimationLibrary][dbl22] 和 [SkeletonAnimationDesignPanel][dbdp22] 项目v2.2的内容，做了极少量的修改；
* jsfl的修改，直接比较 [这3个文件即可][c2]。其中 `skeleton.jsfl.original` 是原始文件， `skeleton.jsfl.20cocos2dx` 是2.0修改版提供的文件， `skeketon.jsfl` 是我修改的文件；
* 导出面板中，我增加了两种导出类型 “Zip(XML and PNGs, for cocos2d-x)”、“Zip(XML+PLIST+PNG, for cocos2d-x)”；
* ![export panel][export]
* 如果选择后面一种，可以直接输出XML、PLIST和拼合后的PNG文件，这样就不必再使用其他工具将分离的PNG拼合了；
* 我修改了导入代码，现在也能在DesignPanel中导入使用上面的类型导出的资源；
* 其他的修改，请直接比较源码；
* 如何使用可以看这里： [在cocos2d-x中使用DragonBones][using]。

感谢 DragonBones Team 带来这样优秀的软件；

感谢对 DragonBones2.0 进行修改的程序员；

希望这个项目对你们有用。

SkeletonAnimationDesignPanel
======================
http://dragonbones.github.com/ 

In this project you can find the source code of DragonBones' Flash Pro based design panel, which is a visual editer for skeleton animation editing. With the design panel, designers can easily convert flash timeline based animation to skeleton animation, edit it and export it to texture file for developers. 

Following steps show you how to use the source code:  
1. Make sure you have installed Flash Builder with Flex SDK 4.0 or later version.  
2. Make sure you have got [SeletonAnimationLibrary](https://github.com/DragonBones/SkeletonAnimationLibrary) project.  
3. Open Flash Builder and create a Flex project named SkeletonAnimationDesignPanel.  
4. Change project location to SkeletonAnimationDesignPanel's location to make sure the IDE can find the source code.
5. Change complie parameters to -locale en_US zh_CN ja_JP fr_FR -source-path ./locale/{locale} -allow-source-path-overlap=true
6. Import SeletonAnimationLibrary project.  
7. (Optional) Change project theme to "Graphite".  
8. Test and have fun.

**Debug**  
Want to debug the design panel in Flash Pro? It's very easy. Just to open the SkeletonAnimationDesignPanel in your Flash Pro and debug the project in Flash Builder. Now the debug version of the design panel in Flash Builder is connected with your Flash Pro. You can use it and debug it just like it is inside of the Flash Pro. Don't wait to try this amazing feature!

There are some demos in [SkeletonAnimationDemos](https://github.com/DragonBones/SkeletonAnimationDemos) project shows how to use the design panel

**All things you need to download can be found [here](http://dragonbones.github.com/download.html)**  

Copyright 2012-2013 the DragonBones Team


[using]: http://zengrong.net/post/1911.htm
[db224cocos2dx]: http://zengrong.net/post/1915.htm
[dbdp22]: https://github.com/DragonBones/SkeletonAnimationDesignPanel/tree/V2.2
[dbl22]: https://github.com/DragonBones/SkeletonAnimationLibrary/tree/V2.2
[c1]: https://github.com/zrong/dragonbones-for-cocos2d-x/blob/master/src/control/ExportDataCommand.as#L222
[c2]: https://github.com/zrong/dragonbones-for-cocos2d-x/tree/master/build/DragonBonesDesignPanel
[export]: build/export.png
[offical]: http://github.com/DragonBones/SkeletonAnimationDesignPanel 
[ccarmature2dbcpp]: http://zengrong.net/post/2106.htm
[dbcpp]: https://github.com/DragonBones/DragonBonesCPP
