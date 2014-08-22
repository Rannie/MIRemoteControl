MIRemoteControl
===============

##简介

<br />
小米遥控器类似实现。通过监听Touch事件，来实现遥控器的简单功能。包括上下左右，菜单，主页以及返回等。

<br />
手势的即时显示通过贴图完成非绘制，而手势的判断则借助对点集合的简单分析。

<br />

##截图

####点轨迹(Points Track)

<br />
![First Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_points.png)
<br />

####方向(Direction)

<br />
![First Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_up.png)
![Second Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_down.png)
![Third Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_right.png)

####功能(Menu and Back)

<br />
![First Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_menu.png)
![Second Screenshot](https://raw.github.com/Rannie/MIRemoteControl/master/screenshots/miremote_back.png)

##提升

<br />
1.点的集合通过系统自带的NSMutableArray来维护，由于不能存结构体，导致需要不停的封包拆包动作如下:

    static inline NSValue * pointToValue(CGPoint a) {
    	return [NSValue valueWithCGPoint:a];
	}

	static inline CGPoint valueToPoint(NSValue *v) {
    	return [v CGPointValue];
	}
	
可以通过自己实现数据结构来维护点顺序集合。

<br />
2.贴图使用的是UIImageView，可以通过轻量级一些的layer设置content来实现。

<br />
3.这里监听的是控制器中的touch事件，也可以通过子类化UIGestureRecognizer来监听UITouch，需要导入<UIKit/UIGestureRecognizerSubclass.h>.

<br />
4.点的路径分析比较简单，如果对统计有研究会有更出色的分析公式。