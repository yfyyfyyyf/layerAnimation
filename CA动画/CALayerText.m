//
//  ViewController.m
//  CALayerText专用图层
//
//  Created by 杨果果 on 2017/7/24.
//  Copyright © 2017年 yangyangyang. All rights reserved.
//

#import "CALayerText.h"
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
@interface CALayerText (){
    CATransform3D layerTransform2;
    CGPoint gestureStartPoint;
    CGFloat x;
    CGFloat y;
    
    CAReplicatorLayer *replicatorLayer;
    CATransform3D transformTouch;
    CGFloat replicatorNum;
}
@property (nonatomic, strong) UIView *baview;
@end

@implementation CALayerText
- (UIView *)baview{
    if (!_baview) {
        _baview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _baview.center = self.view.center;
        
        _baview.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    return _baview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    replicatorNum = 10;
    [self.view addSubview:self.baview];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
     如果需要重写view的layer， 那么可以在重写的view里面使用   - (calayer *)layerclass   返回一个 类型的layer
     
     
     */
    
    
    //     [self CAShapeLayer]; //CAShapeLayer  主要用贝塞尔曲线画图
    //    [self CAShapeLayerCornerRadius]; //CAShapeLayer 画圆角 指定那个角做圆角  图层背景设白色或者透明
    
    
    //    [self CATextLayer];   // 可以作为UILabel的替代，ios6以后使用渲染比UILabel快很多，iOS6之前UILabel实现是使用webkit方式实现
    
    
    //    [self CATransformLayer];   // 创建的 是3d 的不是sublayerTransform 方式创建的2d扁平化模型
    
    //    [self CAGradientLayer];     //  渐变颜色
//        [self CAGradientLayerRainbow];   //🌈   指定渐变位置 指定渐变的颜色组成
    
    //    [self CAReplicatorLayer];     //重复图层
    
//    [self CAEmitterLayer];   // 花火效果
    
    
    //跑马灯渐变
    
    [self paomadeng];
    
    
}
-(void)paomadeng{

    CATextLayer *text = [CATextLayer layer];
    text.string = @"为奇偶微积分iOSA级发送飞机开始";
    text.fontSize = 13.0;
    
    text.foregroundColor = [UIColor redColor].CGColor;
    text.frame = CGRectMake(0, 0, self.baview.frame.size.width, 30);
    text.alignmentMode = kCAAlignmentCenter;
   
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.locations = @[@0.2,@0.5,@0.8];
    gradientLayer.frame = CGRectMake(0, 0, self.baview.frame.size.width, 30);
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    gradientLayer.mask = text;
    
    [self.baview.layer addSublayer:gradientLayer];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"locations"];
    anim.duration = 3.0;
    anim.repeatCount = HUGE;
    anim.fromValue = @[@0,@0,@0.25];
    anim.toValue = @[@.75,@1,@1];
    [gradientLayer addAnimation:anim forKey:nil];
    
  
}
#pragma mark -- AVPlayerLayer
/*
    AVPlayerLayer。尽管它不是Core Animation框架的一部分（AV前缀看上去像），AVPlayerLayer是有别的框架（AVFoundation）提供的，它和Core Animation紧密地结合在一起，提供了一个CALayer子类来显示自定义的内容类型。
 
    AVPlayerLayer是用来在iOS上播放视频的。他是高级接口例如MPMoivePlayer的底层实现，提供了显示视频的底层控制。AVPlayerLayer的使用相当简单：你可以用+playerLayerWithPlayer:方法创建一个已经绑定了视频播放器的图层，或者你可以先创建一个图层，然后用player属性绑定一个AVPlayer实例。
 
    1. Core Animation并不支持自动大小和自动布局
 
    2. AVPlayerLayer是CALayer的子类，它继承了父类的所有特性。我们并不会受限于要在一个矩形中播放视频；清单6.16演示了在3D，圆角，有色边框，蒙板，阴影等效果
 
 
 
 
 
 */

- (void)AVPlayerLayer{
    // 添加URL 就可以简单的播放
    NSURL *url = [NSURL URLWithString:@""];
    
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerlayer.frame = self.baview.bounds;
    [player play];
}




#pragma mark -- CAEAGLLayer    调用c 代码  OpenGL 与硬件打交道高效绘制图形，好难








#pragma mark -- CAEmitterLayer   花火效果
/*
    CAEmitterLayer  iOS 5 引入的一个新的CALayer子类，是一个高性能的粒子引擎，被用来创建实时例子动画如：烟雾，火，雨等等这些效果。
 

 
    // 粒子的初始加速度  x,y
        cell.yAcceleration = -10.f;
        cell.xAcceleration = 20.f;
        cell.velocity = 100;                    // 粒子运动的速度均值
        cell.velocityRange = 5;                // 粒子运动的速度扰动范围
 
    如果 cell.velocity 相对于 x,y 初始值较小，那么，粒子运动方向是 初始加速度方向
    如果 cell.velocity 相对于 x,y 初速较大， 那么，粒子运动方向是受到初始加速度影响的一个抛物线，如果速度均值远大于初始加速度，那么就会有一个看上去好像在四下发散，实际上是有被初始加速度影响的抛物线
    如果x，y 初始加速度为0，默认   那么就会四下发散，没有初始方向影响
 
    cell.emissionRange = M_PI * 2.0;        // 粒子发射角度, 这里是一个扇形.
    发射角度需要设置 跟着扇形的面儿发散
 
    preservesDepth，是否将3D例子系统平面化到一个图层（默认值）或者可以在3D空间中混合其他的图层
    renderMode，控制着在视觉上粒子图片是如何混合的。你可能已经注意到了示例中我们把它设置为kCAEmitterLayerAdditive，它实现了这样一个效果：合并例子重叠部分的亮度使得看上去更亮。如果我们把它设置为默认的kCAEmitterLayerUnordered，效果就没那么好看了.
 
    CAEmitterCell 还可以设置 color   设置颜色 greenSpeed 红黄绿颜色的速度，改变cell的颜色
 */
- (void)CAEmitterLayer{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.frame = self.baview.bounds;
    [self.baview.layer addSublayer:emitterLayer];
//    emitterLayer.emitterMode = kCAEmitterLayerAdditive;
    emitterLayer.emitterPosition = CGPointMake(emitterLayer.frame.size.width/2, emitterLayer.frame.size.height/2);
    emitterLayer.emitterSize = CGSizeMake(self.view.frame.size.width, 0);
    //指定发射源的形状 和 模式
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterMode  = kCAEmitterLayerOutline;
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    UIImage *image = [UIImage imageNamed:@"lingnai"];
   

    
    
    
    cell.contents = (__bridge id _Nullable)([self scaleImageToSize:50.0 image:image].CGImage);
//    cell.yAcceleration = -10.f;     // 粒子的初始加速度  x,y
//    cell.xAcceleration = 10.f;
    cell.birthRate = 10;                   // 每秒生成粒子的个数
    cell.lifetime = 100.0;                 // 粒子存活时间
    cell.velocity = -100;                    // 粒子运动的速度均值   正值向上  负值向下
    cell.velocityRange = 5;                // 粒子运动的速度扰动范围
//    cell.emissionRange = M_PI * 2.0;        // 粒子发射角度, 这里是一个扇形.
        cell.emissionRange = 0;        // 粒子发射角度, 这里是一个扇形.
    cell.alphaSpeed = -0.1f;        // 粒子消逝的速度
    __block typeof(cell) Wcell = cell;
    emitterLayer.emitterCells = @[cell];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        Wcell.birthRate = 0.0;
        
    });
}

- (UIImage *)scaleImageToSize:(CGFloat)width image:(UIImage *)image{
    CGFloat wei = image.size.width;
    CGFloat hei = image.size.height;
    
    if (wei > width ) {
        wei = width;
        hei = width / image.size.width * image.size.height;
    }
    if (hei > width ){
        hei = width;
        wei = width / image.size.height * image.size.width;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(wei, hei));
    [image drawInRect:CGRectMake(0, 0, wei, hei)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

#pragma mark -- CATiledLayer   大图裁剪成小图了显示
/*
    图片
    imageWithContentsOfFile: 读取指定位置（path 路径）的图片，不会加入到缓存，适合在大图，使用频率低的位置
           iOS8 以后 生成图片时会优先使用@2x的图片
           iOS7 之前 生成图片的路径需要拼接 @2x.png
 
        （1）加载内存当中之后，会一直停留在内存当中，不会随着对象的销毁而销毁。
 
        （2）加载进去图片之后，占用的内存归系统管理，我们无法管理。
 
        （3）相同的图片，图片不会重复加载。
 
        （4）加载到内存中后，占据内存空间较大。
 
 
 
    imageWithName: 加入缓存，如果缓存没有那么就到指定的文档中加载并缓存，适合常用的图标。
        当遭遇内存消耗过大的时候，系统强制释放内存，此时，加载到缓存的图片可能就会被释放，这时候，容易引起内存泄漏，
        （1）加载到内存当中后，占据内存空间较小。
 
        （2）相同的图片会被重复加载内存当中。
 
        （3）对象销毁的时候，加载到内存中图片会随着一起销毁
 
 
    CATiledLayer    显示高像素的图片时候。imageWithName: 或者imageWithContentsOfFile: 读取整个图片到内存中，是不明智的，载入大图的时间可能相当的慢，而且，内存占用也多，主线程调用 将会阻塞主线程，至少是引起卡顿。
    能高效绘制在iOS上的图片也有一个大小限制。所有显示在屏幕上的图片最终都会被转化为OpenGL纹理，同时OpenGL有一个最大的纹理尺寸（通常是2048*2048，或4096*4096，这个取决于设备型号,4s以后都是4096*4096了好像）。如果你想在单个纹理中显示一个比这大的图，即便图片已经存在于内存中了，你仍然会遇到很大的性能问题，因为Core Animation强制用CPU处理图片而不是更快的GPU（见第12章『速度的曲调』，和第13章『高效绘图』，它更加详细地解释了软件绘制和硬件绘制）。
 
    CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。
 
    小片裁剪
 
        256*256是CATiledLayer的默认小图大小，默认大小可以通过tileSize属性更改
 
    当你滑动这个图片，你会发现当CATiledLayer载入小图的时候，他们会淡入到界面中。这是CATiledLayer的默认行为。（你可能已经在iOS 6之前的苹果地图程序中见过这个效果）你可以用fadeDuration属性改变淡入时长或直接禁用掉。CATiledLayer（不同于大部分的UIKit和Core Animation方法）支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用，所以请小心谨慎地确保你在这个方法中实现的绘制代码是线程安全的。
 
    retain 小图
 
    你也许已经注意到了这些小图并不是以Retina的分辨率显示的。为了以屏幕的原生分辨率来渲染CATiledLayer，我们需要设置图层的contentsScale来匹配UIScreen的scale属性：
 
    tileLayer.contentsScale = [UIScreen mainScreen].scale;
 
    有趣的是，tileSize是以像素为单位，而不是点，所以增大了contentsScale就自动有了默认的小图尺寸（现在它是128*128的点而不是256*256）.所以，我们不需要手工更新小图的尺寸或是在Retina分辨率下指定一个不同的小图。我们需要做的是适应小图渲染代码以对应安排scale的变化，然而：
 
    //determine tile coordinate
     CGRect bounds = CGContextGetClipBoundingBox(ctx);
     CGFloat scale = [UIScreen mainScreen].scale;
     NSInteger x = floor(bounds.origin.x / layer.tileSize.width * scale);
     NSInteger y = floor(bounds.origin.y / layer.tileSize.height * scale);
 
    通过这个方法纠正scale也意味着我们的雪人图将以一半的大小渲染在Retina设备上（总尺寸是1024*1024，而不是2048*2048）。这个通常都不会影响到用CATiledLayer正常显示的图片类型（比如照片和地图，他们在设计上就是要支持放大缩小，能够在不同的缩放条件下显示），但是也需要在心里明白。
 
 */








#pragma mark -- CAScrollLayer  scrollview 的替代品
/*
 
    对于一个未转换的图层，它的bounds和它的frame是一样的，frame属性是由bounds属性自动计算而出的，所以更改任意一个值都会更新其他值。
 
    但是如果你只想显示一个大图层里面的一小部分呢。比如说，你可能有一个很大的图片，你希望用户能够随意滑动，或者是一个数据或文本的长列表。在一个典型的iOS应用中，你可能会用到UITableView或是UIScrollView，但是对于独立的图层来说，什么会等价于刚刚提到的UITableView和UIScrollView呢？
 
    在第二章中，我们探索了图层的contentsRect属性的用法，它的确是能够解决在图层中小地方显示大图片的解决方法。但是如果你的图层包含子图层那它就不是一个非常好的解决方案，因为，这样做的话每次你想『滑动』可视区域的时候，你就需要手工重新计算并更新所有的子图层位置。
 
    这个时候就需要CAScrollLayer了。CAScrollLayer有一个-scrollToPoint:方法，它自动适应bounds的原点以便图层内容出现在滑动的地方。注意，这就是它做的所有事情。前面提到过，Core Animation并不处理用户输入，所以CAScrollLayer并不负责，将触摸事件转换为滑动事件，既不渲染滚动条，也不实现任何iOS指定行为例如滑动反弹（当视图滑动超多了它的边界的将会反弹回正确的地方）。
 
    让我们来用CAScrollLayer来常见一个基本的UIScrollView替代品。我们将会用CAScrollLayer作为视图的宿主图层，并创建一个自定义的UIView，然后用UIPanGestureRecognizer实现触摸事件响应。这段代码见清单6.10. 图6.11是运行效果：ScrollView显示了一个大于它的frame的UIImageView。
 
    不同于UIScrollView，我们定制的滑动视图类并没有实现任何形式的边界检查（bounds checking）。图层内容极有可能滑出视图的边界并无限滑下去。CAScrollLayer并没有等同于UIScrollView中contentSize的属性，所以当CAScrollLayer滑动的时候完全没有一个全局的可滑动区域的概念，也无法自适应它的边界原点至你指定的值。它之所以不能自适应边界大小是因为它不需要，内容完全可以超过边界。
    那你一定会奇怪用CAScrollLayer的意义到底何在，因为你可以简单地用一个普通的CALayer然后手动适应边界原点啊。真相其实并不复杂，UIScrollView并没有用CAScrollLayer，事实上，就是简单的通过直接操作图层边界来实现滑动。
 
 
    CAScrollLayer有一个潜在的有用特性。如果你查看CAScrollLayer的头文件，你就会注意到有一个扩展分类实现了一些方法和属性：
 
    - (void)scrollPoint:(CGPoint)p;
    - (void)scrollRectToVisible:(CGRect)r;
    @property(readonly) CGRect visibleRect;
 
 
    看到这些方法和属性名，你也许会以为这些方法给每个CALayer实例增加了滑动功能。但是事实上他们只是放置在CAScrollLayer中的图层的实用方法。
 
        scrollPoint:方法从图层树中查找并找到第一个可用的CAScrollLayer，然后滑动它使得指定点成为可视的。
        scrollRectToVisible:方法实现了同样的事情只不过是作用在一个矩形上的。
        visibleRect属性决定图层（如果存在的话）的哪部分是当前的可视区域。
 
    如果你自己实现这些方法就会相对容易明白一点，但是CAScrollLayer帮你省了这些麻烦，所以当涉及到实现图层滑动的时候就可以用上了。
 
 
 */


#pragma mark -- CAReplicatorLayer  重复图层
/*
    CAReplicatorLayer  为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。
    图要旋转的话 生成扇形子图层，子图层的的中心 为 layer  的中心，第一个子图层位置不变
    平移生成， 以第一个子图层为起始点，依次等偏移量变换
    平移+旋转，子图层的中心也位置会 平移+旋转做变换
 
    变换的过程有一个动画效果，目测  超过180度，会先缩放到最小然后在放大到设置大小
 
 
    可以使用这个做镜面效果，  向下平移 然后X。Y旋转 然后设置透明    重复数量设置为2
 
    ******    *****
        在设置旋转之后，重新给 CAReplicatorLayer设置旋转角度，会在上一个设置的基础值上继续平移变化  例如点击例子，设置定值，每次点击之后，会在原来基础上再加。
 
        如果不想在上一个基础值上继续增加，可以给  CATransform3D 初始化    transformTouch = CATransform3DIdentity;
 */
- (void)CAReplicatorLayer{
    replicatorLayer = [CAReplicatorLayer layer];
//    self.baview.frame = self.view.frame;
    replicatorLayer.frame = self.baview.bounds;
    [self.baview.layer addSublayer:replicatorLayer];
    replicatorLayer.instanceCount = 3;
    
    
    
    //  shapeLayer 只是画个圆点    并不是给CAReplicatorLayer 设置轨迹
    CGFloat radius = 100/4;
    CGFloat transX = 100 - radius;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.backgroundColor = [UIColor blueColor].CGColor;
    shape.frame = CGRectMake(0, 0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor redColor].CGColor;
    shape.lineWidth = 1;

    
    transformTouch = CATransform3DIdentity;
    transformTouch = CATransform3DRotate(transformTouch, replicatorNum*M_PI/180.0, 0.0, 0.0, 1.0);
//    transformTouch = CATransform3DTranslate(transformTouch, replicatorNum, 0, 0);
    replicatorLayer.instanceTransform = transformTouch;

    replicatorLayer.instanceBlueOffset = - 0.1;
    replicatorLayer.instanceRedOffset  = -0.1;
    [replicatorLayer addSublayer:shape];
    
    CALayer *littlelayer = [CALayer layer];
    littlelayer.frame = CGRectMake(25.0f, 25.0f, 25.0f, 25.0f);
    littlelayer.backgroundColor = [UIColor whiteColor].CGColor;
    
//    [layer addSublayer:littlelayer];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    replicatorNum += 10;
    transformTouch = CATransform3DRotate(transformTouch, replicatorNum*M_PI/180.0, 0.0, 0.0, 1.0);
//    transformTouch = CATransform3DTranslate(transformTouch, replicatorNum, 0, 0);
    replicatorLayer.instanceTransform = transformTouch;
}
//- (void)CAReplicatorLayer{
//    [self.baview.layer addSublayer:[self replicatorLayer_Triangle]];
//}


- (CALayer *)replicatorLayer_Triangle{
    CGFloat radius = 100/4;
    CGFloat transX = 100 - radius;
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, radius, radius);
    shape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.fillColor = [UIColor redColor].CGColor;
    shape.lineWidth = 1;
//    [shape addAnimation:[self rotationAnimation:transX] forKey:@"rotateAnimation"];
    
    CAReplicatorLayer *replicatorLayer1 = [CAReplicatorLayer layer];
    replicatorLayer1.frame = CGRectMake(0, 0, radius, radius);
    replicatorLayer1.instanceDelay = 0.0;
    replicatorLayer1.instanceCount = 3;
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D = CATransform3DTranslate(trans3D, transX, 0, 0);
    trans3D = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    replicatorLayer1.instanceTransform = trans3D;
    [replicatorLayer1 addSublayer:shape];
    
    return replicatorLayer1;
}
- (CABasicAnimation *)rotationAnimation:(CGFloat)transX{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
    scale.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D toValue = CATransform3DTranslate(CATransform3DIdentity, transX, 0.0, 0.0);
    toValue = CATransform3DRotate(toValue,120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    
    scale.toValue = [NSValue valueWithCATransform3D:toValue];
    scale.autoreverses = NO;
    scale.repeatCount = HUGE;
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scale.duration = 0.8;
    return scale;
}




#pragma mark -- CAGradientLayer 基础渐变
/*
    CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。
    
    这些渐变色彩放在一个数组中，并赋给colors属性。这个数组成员接受CGColorRef类型的值（并不是从NSObject派生而来），所以我们要用通过bridge转换以确保编译正常。
 
    CAGradientLayer也有startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1};
 
 */
- (void)CAGradientLayer{
    CAGradientLayer *layer=  [CAGradientLayer layer];
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor];
    layer.frame = self.baview.bounds;
    [self.baview.layer addSublayer:layer];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    
}

- (void)CAGradientLayerRainbow{
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.frame = self.baview.bounds;
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
    layer.locations = @[@0.0,@0.5,@1.0];
    layer.startPoint = CGPointMake(0.5, 0.5);
    layer.endPoint = CGPointMake(1, 1);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.baview.bounds cornerRadius:self.baview.bounds.size.width/3];
    CAShapeLayer *shaperLayer= [CAShapeLayer layer];
    shaperLayer.path = path.CGPath;
    shaperLayer.frame = layer.bounds;
    //蒙板图层
    layer.mask = shaperLayer;
    [self.baview.layer addSublayer:layer];
}

#pragma mark -- CATransformLayer
/*
 CATransformLayer  
    当我们在构造复杂的3D事物的时候，如果能够组织独立元素就太方便了。比如说，你想创造一个孩子的手臂：你就需要确定哪一部分是孩子的手腕，哪一部分是孩子的前臂，哪一部分是孩子的肘，哪一部分是孩子的上臂，哪一部分是孩子的肩膀等等。
 
    当然是允许独立地移动每个区域的啦。以肘为指点会移动前臂和手，而不是肩膀。Core Animation图层很容易就可以让你在2D环境下做出这样的层级体系下的变换，但是3D情况下就不太可能，因为所有的图层都把他的孩子都平面化到一个场景中（第五章『变换』有提到 -- 创建cube立方体）。
 
    CATransformLayer解决了这个问题，CATransformLayer不同于普通的CALayer，因为它不能显示它自己的内容。只有当存在了一个能作用域子图层的变换它才真正存在。CATransformLayer并不平面化它的子图层，所以它能够用于构造一个层级的3D结构，比如我的手臂示例。
 
 */

- (void)CATransformLayer{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500;
    self.baview.layer.sublayerTransform = transform;
    
    CATransform3D Layertransform = CATransform3DIdentity;
    Layertransform = CATransform3DTranslate(Layertransform, -100, 0, 0);
    [self.baview.layer addSublayer:[self creatCubeCATransformLayer:Layertransform]];
    
    layerTransform2 = CATransform3DIdentity;
    layerTransform2 = CATransform3DMakeTranslation(100, 0, 0);
    layerTransform2 = CATransform3DRotate(layerTransform2, -M_PI_4, 1, 0, 0);
    layerTransform2 = CATransform3DRotate(layerTransform2, -M_PI_4, 0, 1, 0);
    [self.baview.layer addSublayer:[self creatCubeCATransformLayer:layerTransform2]];
}
- (CALayer *)creatCubeCATransformLayer:(CATransform3D)transform{
    CATransformLayer *layer = [CATransformLayer layer];
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    ct = CATransform3DMakeTranslation(0, 0, -50);
    [layer addSublayer:[self creatFaceLayer:ct]];
    
    CGSize containerSize = self.baview.bounds.size;
    layer.position = CGPointMake(containerSize.width/2.0, containerSize.height/2.0);
    
    layer.transform = transform;
    
    return layer;
}

- (CALayer *)creatFaceLayer:(CATransform3D)transform{
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    face.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0].CGColor;
    face.transform = transform;
    return face;
}
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    gestureStartPoint = [touch locationInView:self.view];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    layerTransform2 = CATransform3DIdentity;
    layerTransform2 = CATransform3DMakeTranslation(100, 0, 0);
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    CGFloat x1 = point.x - gestureStartPoint.x + x;
    CGFloat y1 = point.y - gestureStartPoint.y + y;
    layerTransform2 = CATransform3DRotate(layerTransform2, M_PI/180.0 * x1, 0, 1, 0);
    layerTransform2 = CATransform3DRotate(layerTransform2, M_PI/180.0 * y1, 1, 0, 0);
    ((CALayer *)self.baview.layer.sublayers.lastObject).transform = layerTransform2;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    x = point.x - gestureStartPoint.x;
    y = point.y - gestureStartPoint.y;
}

*/




#pragma mark -- CATextLayer
/*
    CATextLayer
    用户界面是无法从一个单独的图片里面构建的。一个设计良好的图标能够很好地表现一个按钮或控件的意图，不过你迟早都要需要一个不错的老式风格的文本标签。
    如果你想在一个图层里面显示文字，完全可以借助图层代理直接将字符串使用Core Graphics写入图层的内容（这就是UILabel的精髓）。如果越过寄宿于图层的视图，直接在图层上操作，那其实相当繁琐。你要为每一个显示文字的图层创建一个能像图层代理一样工作的类，还要逻辑上判断哪个图层需要显示哪个字符串，更别提还要记录不同的字体，颜色等一系列乱七八糟的东西。
    万幸的是这些都是不必要的，Core Animation提供了一个CALayer的子类CATextLayer，它以图层的形式包含了UILabel几乎所有的绘制特性，并且额外提供了一些新的特性。
    同样，CATextLayer也要比UILabel渲染得快得多。很少有人知道在iOS 6及之前的版本，UILabel其实是通过WebKit来实现绘制的，这样就造成了当有很多文字的时候就会有极大的性能压力。而CATextLayer使用了Core text，并且渲染得非常快。
 */
- (void)CATextLayer{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.fontSize = 35.0;
    textLayer.string = @"nisdfsjakfljsaklfjskalfjklsfdkfjskaldfjklsa";
    textLayer.frame = self.baview.bounds;
    [self.baview.layer addSublayer:textLayer];
    textLayer.foregroundColor = [UIColor blueColor].CGColor; //文字颜色
    textLayer.borderColor = [UIColor redColor].CGColor;      //边框颜色  要设置边框宽度
    textLayer.borderWidth = 1.0;                            // 边框宽度
    textLayer.backgroundColor = [UIColor clearColor].CGColor;  //背景颜色
    textLayer.alignmentMode = kCAAlignmentCenter;          // 居中
    textLayer.wrapped = YES;                                  // yes 优化适应图层边界 -- 自动换行
    
    // 仔细看文本可能有些地方被像素化了，是因为渲染的时候并不是以retain渲染的，contentsScale 默认渲染比例是1.0，需要设置屏幕的渲染比例
    // contentsScale 属性用来决定图层是以怎样的分辨率来渲染
    textLayer.contentsScale = [UIScreen mainScreen].scale;
  
}

/*
    textLayer.string 接收值是一个id 类型就是说可以接收富文本。NSAttributedString并不是NSString的子类
    NSAttributedString : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>
 
    textLayer 可做UILabel的代替  ios 3.2 以后就能支持属性化字符串了   ios6以前 是需要跟webview 打交道
    现在也没什么必要用这个吧  除了特定的场景
 
 */


#pragma mark -- CAShapeLayer
/*
    CAShapeLayer   主要 贝塞尔曲线 画线  比如绘图板

    CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。你指定诸如颜色和线宽等属性，用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了。当然，你也可以用Core Graphics直接向原始的CALyer的内容中绘制一个路径，相比直下，使用CAShapeLayer有以下一些优点：
            渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
            高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
            不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉
            不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 
    CAShapeLayer可以用来绘制所有能够通过CGPath来表示的形状。这个形状不一定要闭合，图层路径也不一定要不可破，事实上你可以在一个图层上绘制好几个不同的形状。你可以控制一些属性比如lineWith（线宽，用点表示单位），lineCap（线条结尾的样子），和lineJoin（线条之间的结合点的样子）；但是在图层层面你只有一次机会设置这些属性。如果你想用不同颜色或风格来绘制多个形状，就不得不为每个形状准备一个图层了
 
 
 
 */
- (void)CAShapeLayer{
//    CAShapeLayer *layer = [CAShapeLayer layer];
    
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];   //  将path的起点移动到。。。
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];   //  绘制一个圆形   圆心半径起始角度 终止角度
    [path moveToPoint:CGPointMake(150, 125)];     //  移动path起始点
    [path addLineToPoint:CGPointMake(150, 175)];  //  从起始点画线
    [path addLineToPoint:CGPointMake(125, 225)];  //  从起始点画线
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];

    //create shape layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;  // 线的颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;    // 填充颜色
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;               //线条之间的结合点的样子
    shapeLayer.lineCap = kCALineCapRound;                 //线条结尾的样子
    shapeLayer.path = path.CGPath;

    [self.view.layer addSublayer:shapeLayer];
    
}

/*
    CAShapeLayer 实现圆角比layer的圆角属性做的事情多，但是有一个优点就是可以单独设置圆角  比如绘制三个角是圆角的view
    创建圆角实际上就是人工绘制单独的直线和弧度，贝塞尔曲线有自动绘制圆角矩形的构造方法
 
 */

- (void)CAShapeLayerCornerRadius{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    CGSize cornerRadius = CGSizeMake(20, 20);
    UIRectCorner rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.baview.bounds byRoundingCorners:rectCorner cornerRadii:cornerRadius];
    shapeLayer.path = path.CGPath;
    [self.baview.layer addSublayer:shapeLayer];
}

@end
