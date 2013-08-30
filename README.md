DragonBones2.2 for cocos2d-x
======================

基于 [这里提到的原因][db224cocos2dx]，我以DragonBones2.2版本为基础制作了这个插件，并重新打包发布。

我做的工作并不多，只是花了一些时间理解了DragonBonesDesignPanel的结构。

* 这个项目包含了 [SkeletonAnimationLibrary][dbl22] 和 [SkeletonAnimationDesignPanel][dbdp22] 项目v2.2的内容，做了极少量的修改；
* DesignPanel中的修改在 [这里][c1]；
* jsfl的修改，直接比较 [这3个文件即可][c2]。其中 `skeleton.jsfl.original` 是原始文件， `skeleton.jsfl.20cocos2dx` 是2.0修改版提供的文件， `skeketon.jsfl` 是我修改的文件；
* 如何使用可以看这里： [在cocos2d-x中使用DragonBones][using]。

感谢DragonBones Team带来这样优秀的软件；

感谢DragonBones2.0修改版的作者。

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
5  Change complie parameters to -locale en_US zh_CN ja_JP fr_FR -source-path ./locale/{locale} -allow-source-path-overlap=true
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
