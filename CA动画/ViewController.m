//
//  ViewController.m
//  CA动画
//
//  Created by 1 on 2017/7/31.
//  Copyright © 2017年 深圳市全日康健康产业股份有限公司. All rights reserved.
//
/**
 判断值是否为空， 如果为空， 那么替换成 NSNull 对象
 
 @param value 进行判断的值
 @return 非空值或者NSNull
 */
#define knil(value) (nil == value ? [NSNull null] : value)

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *baview;
@property (nonatomic, strong) CALayer *changeColorLayer;
@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UITableView *tabview;

@end

@implementation ViewController
- (UIView *)baview{
    if (!_baview) {
        _baview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _baview.center = self.view.center;
        _baview.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
    return _baview;
}
- (UIImageView *)image{
    if (!_image) {
        _image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lingnai"]];
        _image.frame = self.baview.bounds;
        [self.baview addSubview:_image];
    }
    return _image;
}
- (UITableView *)tabview{
    if (!_tabview) {
        _tabview = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tabview.delegate = self;
        _tabview.dataSource = self;
        [_tabview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"111"];
        
    }
    return _tabview;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view addSubview:self.baview];
    
//    [self yinshidonghua];     // 简单隐式动画
//    [self changeActions];  //  修改过渡动画过程
//    [self presentationLayer];   // 使用  presentationLayer  判断当前图层位置 动画过程中的呈现图层当前的位置
    
//    [self CABasicAnimation];   // 简单使用动画结束的代理    代理有动画开始、结束两个
    
    
//    [self changeColor]; // 关键帧动画 改变颜色简单使用
    [self CAKeyframeAnimation]; // 关键帧动画 根据路径运动   //  有点意思      动画结束之后  会回到初始状态
    
    
//    [self xunishuxing]; // 虚拟属性
//    [self CATransition];
    
//    [self.view addSubview:self.tabview];  // tableview的图层树动画  cell 加载的时候 动画效果

//        [self performTransition];
    
    NSLog(@"currentTime  %@",[[NSDate date]description]);
    [self performSelector:@selector(afer) withObject:nil afterDelay:5.0];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afer) object:nil];// 取消之后就不运行方法了
    
}
- (void)afer{
    NSLog(@"11111");
    NSLog(@"currentTime  %@",[[NSDate date]description]);
}
#pragma mark --  取消动画
/**
 
    -addAnimation:forKey: 在创建动画的时候 给动画添加一个key
 
    - (CAAnimation *)animationForKey:(NSString *)key   根据key 拿到图层
        不支持在动画运行中修改动画，这个方法主要用来检测动画的属性，或者判断它是否被添加到当前图层中。
 
    - (void)removeAnimationForKey:(NSString *)key;  根据key 取消动画
 
    - (void)removeAllAnimations;       移除所有动画
 
    - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag      flag 判断是否是打断或者停止，
 
    动画被移除之后，图层的外观就立刻更新到当前的模型图层的值，一般来说，动画在结束之后被自动移除，除非设置 removedOnCompletion = NO  如果设置动画在结束之后不被自动移除，那么当它不需要的时候手动移除，不然会一直存在于内存中，直到图层被销毁。
 */


#pragma mark --  过渡 -- 自定义动画
/**
    
    过渡动画做基础的原则就是对原始的图层外观截图，然后添加一段动画，平滑过渡到图层改变之后那个截图的效果。如果我们知道如何对图层截图，我们就可以使用属性动画来代替CATransition或者是UIKit的过渡方法来实现动画。
 
    对图层做截图还是很简单的。CALayer有一个  
                                    -renderInContext:方法，
        可以通过把它绘制到Core Graphics的上下文中捕获当前内容的图片，然后在另外的视图中显示出来。如果我们把这个截屏视图置于原始视图之上，就可以遮住真实视图的所有变化，于是重新创建了一个简单的过渡效果。
 
        这里有个警告：-renderInContext:捕获了图层的图片和子图层，但是不能对子图层正确地处理变换效果，而且对视频和OpenGL内容也不起作用。但是用CATransition，或者用私有的截屏方式就没有这个限制了.
 
 
 
     - performTransition 演示了一个基本的实现。我们对当前视图状态截图，然后在我们改变原始视图的背景色的时候对截图快速转动并且淡出，
 
    为了让事情更简单，我们用UIView -animateWithDuration:completion:方法来实现。虽然用CABasicAnimation可以达到同样的效果，但是那样的话我们就需要对图层的变换和不透明属性创建单独的动画，然后当动画结束的是哦户在CAAnimationDelegate中把coverView从屏幕中移除。
 */ 
- (void)performTransition{
    UIGraphicsBeginImageContextWithOptions(self.baview.bounds.size, YES, 0.0);
    [self.baview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImg = UIGraphicsGetImageFromCurrentImageContext();
    UIView *coverView = [[UIImageView alloc]initWithImage:coverImg];
    coverView.frame = self.baview.bounds;
    [self.baview addSubview:coverView];
    UIGraphicsEndImageContext();
    self.baview.backgroundColor = [UIColor colorWithRed:(float)(arc4random_uniform(256) /255.0) green:(float)(arc4random_uniform(256) /255.0) blue:(float)(arc4random_uniform(256) /255.0) alpha:1.0];
    [UIView animateWithDuration:2.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
    
    
}



#pragma mark --  过渡 -- 对图层树动画
/**
    CATransition 并不作用于指定的图层属性，也就是说，在即使不能准确知道改变了什么的情况下对图层做动画，例如，在不知道UITableview 哪一行被添加或者删除的情况下，直接就可以平滑的刷新它，或者在不知道UIViewController内部视图层级的情况下对两个不同的实例做过渡动画。
    
    图层树动画 要确保CATransition 添加到图层，在过渡动画发生时，不会再树状结构中被移除，否则，CATransition 将会和图层一起被移除，一般来说，只需要将动画添加到被影响图层的superLayer
 
    例如tabbarController 的切换时， 在其选中的代理方法中添加一个淡入淡出的过渡动画，把动画添加到UITabBarController 的视图图层上，于是在标签被替换的时候，动画不会被移除。
 
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"111"];
    cell.backgroundColor = [UIColor colorWithRed:(float)(arc4random_uniform(256) /255.0) green:(float)(arc4random_uniform(256) /255.0) blue:(float)(arc4random_uniform(256) /255.0) alpha:1.0];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.beginTime = CACurrentMediaTime() + 0.20 * indexPath.item -2;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 2.0;
    [cell.layer addAnimation:transition forKey:nil];
    return cell;
}

#pragma mark --  过渡 -- 隐式过渡
/**
 CATransision可以对图层任何变化平滑过渡的事实使得它成为那些不好做动画的属性图层行为的理想候选。苹果当然意识到了这点，并且当设置了CALayer的content属性的时候，CATransition的确是默认的行为。但是对于视图关联的图层，或者是其他隐式动画的行为，这个特性依然是被禁用的，但是对于你自己创建的图层，这意味着对图层contents图片做的改动都会自动附上淡入淡出的动画。
 
 我们在第七章使用CATransition作为一个图层行为来改变图层的背景色，当然backgroundColor属性可以通过正常的CAPropertyAnimation来实现，但这不是说不可以用CATransition来实行。
 */


#pragma mark --  过渡 -- 图层过渡
/**
 
 
    属性动画 只能对图层的可动画属性起作用，如果是图层的不可动画属性，比如图片，或者层级关系中添加或者移除图层，属性动画不起作用
 
    过渡动画不像属性动画那样平滑的在两个值之间做动画，而是影响到整个图层的变化，过渡动画首先展示之前的图层外观，然后通过一个交换过渡到新的外观
 
    创建一个过渡动画，使用 CATransition 同样是一个CAAnimation 子类， CATransition 有个type 和subtype 来标志变换效果， type 是一个NSString类型，可以被设置成如下类型：
            kCATransitionFade     默认  淡入淡出
            kCATransitionMoveIn   与push 相似 实现定向滑动动画  新图层滑动进入，不会把旧图层推走
            kCATransitionPush     push 新图层从旧图层边界开始把旧图层推出
            kCATransitionReveal   把原始图层滑动出去显示新的图层，而不是把新的图层滑动进入
        除了这4个以外还可以通过别的方式来自定义动画，之后再说
 
    subtype  设置动画的方向
            kCATransitionFromRight
            kCATransitionFromLeft
            kCATransitionFromTop
            kCATransitionFromBottom
 
    栗子：
        对UIimage 的image 属性做动画， 隐式动画或者  CAPropertyAnimation 都不能对其动画， 因为Core Animation 不知道如何在插入图片，通过对图层应用一个淡入淡出的过渡，可以忽略它的内容来做平滑动画
 
    过渡动画添加方式和属性动画或者组动画一致，但是和属性东部啊不同的是，对指定的图层一次只能使用一次CATransition ，所以无论对动画的键设置什么值， 过渡动画都会对它的键设置成“transition” 也就是常量 kCATransition。
 
 
 
 以下几种转场动画调用的苹果的私有API，注意咯，小心用了之后被苹果打回来。
 [plain] view plain copy
 switch (btn.tag) {
 case 0:
 animation.type = @"cube";//---立方体
 break;
 case 1:
 animation.type = @"suckEffect";//103 吸走的效果
 break;
 case 2://前后翻转效果
 animation.type = @"oglFlip";//When subType is "fromLeft" or "fromRight", it's the official one.
 break;
 case 3:
 animation.type = @"rippleEffect";//110波纹效果
 break;
 case 4:
 animation.type = @"pageCurl";//101翻页起来
 break;
 case 5:
 animation.type = @"pageUnCurl";//102翻页下来
 break;
 case 6:
 animation.type = @"cameraIrisHollowOpen ";//107//镜头开
 break;
 case 7:
 animation.type = @"cameraIrisHollowClose ";//106镜头关
 break;
 default:  
 break;  
 }
 
 
 
 */
- (void)CATransition{
    [self.baview bringSubviewToFront:self.image];
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionMoveIn ;
//    transition.subtype = kCATransitionFromLeft;
//    
//    [self.image.layer addAnimation:transition forKey:nil];
//    UIImage *aniImg = [UIImage imageNamed:@"jieyi"];
//    self.image.image = aniImg;
//
//}




#pragma mark --  组动画  -- CAAnimationGroup
/*
 CAKeyframeAnimation 、 CABasicAnimation 都是对单一属性做动画   也可以组合起来  放在一个 CAAnimationGroup 里面 添加在layer上  做动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
    [colorLayer addAnimation:groupAnimation forKey:nil];
 
 */


#pragma mark --  虚拟属性

/**
 
 虚拟属性  实际就是动画 keypath 路径的做动画   路径下的属性是不存在的所以叫虚拟属性   
 例如
    用transform.rotation而不是transform做动画的好处如下：
 
        我们可以不通过关键帧一步旋转多于180度的动画。
        可以用相对值而不是绝对值旋转（设置byValue而不是toValue）。
        可以不用创建CATransform3D，而是使用一个简单的数值来指定角度。
        不会和transform.position或者transform.scale冲突（同样是使用关键路径来做独立的动画属性）”
 
 transform.rotation属性有一个奇怪的问题是它其实并不存在。这是因为CATransform3D并不是一个对象，它实际上是一个结构体，也没有符合KVC相关属性，transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性。
 
 你不可以直接设置transform.rotation或者transform.scale，他们不能被直接使用。当你对他们做动画时，Core Animation自动地根据通过CAValueFunction来计算的值来更新transform属性。
 
 CAValueFunction用于把我们赋给虚拟的transform.rotation简单浮点值转换成真正的用于摆放图层的CATransform3D矩阵值。你可以通过设置CAPropertyAnimation的valueFunction属性来改变，于是你设置的函数将会覆盖默认的函数。
 
 CAValueFunction看起来似乎是对那些不能简单相加的属性（例如变换矩阵）做动画的非常有用的机制，但由于CAValueFunction的实现细节是私有的，所以目前不能通过继承它来自定义。你可以通过使用苹果目前已近提供的常量（目前都是和变换矩阵的虚拟属性相关，所以没太多使用场景了，因为这些属性都有了默认的实现方式）。
 
 
 
 */
- (void)xunishuxing{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(150, 150);
    [self.view.layer addSublayer:layer];
    layer.contents = (__bridge id)[UIImage imageNamed:@"lingnai"].CGImage;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 2.0;
    // 对transform 做旋转    超过   180°的旋转就没什么效果
//    animation.keyPath = @"transform";
//    animation.byValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 1)];

    // 对关键帧做动画    对关键路径做动画   而不是transform本身
    animation.keyPath = @"transform.rotation";
    animation.byValue = @(M_PI*2);
    [layer addAnimation:animation forKey:nil];
    
    
}



#pragma mark --  关键帧动画 --  CAKeyframeAnimation
/**
 
    CAKeyframeAnimation是另一种UIKit没有暴露出来但功能强大的类。和CABasicAnimation类似，CAKeyframeAnimation同样是CAPropertyAnimation的一个子类，它依然作用于单一的一个属性，但是和CABasicAnimation不一样的是，它不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画
 
    关键帧起源于传动动画，意思是指主导的动画在显著改变发生时重绘当前帧（也就是关键帧），每帧之间剩下的绘制（可以通过关键帧推算出）将由熟练的艺术家来完成。CAKeyframeAnimation也是同样的道理：你提供了显著的帧，然后Core Animation在每帧之间进行插入。
 
    动画结束开始都是baview 的默认颜色，那么可以证明， CAKeyframeAnimation 不能像 CABasicAnimation 一样自动把当前值作为第一帧，(CABasicAnimation.fromValue = nil)
    动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值。
 
    当然可以创建一个结束和开始值不同的动画，那样的话就需要在动画启动之前手动更新属性和最后一帧的值保持一致，就和之前讨论的一样。
 
    我们用duration属性把动画时间从默认的0.25秒增加到2秒，以便于动画做的不那么快。运行它，你会发现动画通过颜色不断循环，但效果看起来有些奇怪。原因在于动画以一个恒定的步调在运行。当在每个动画之间过渡的时候并没有减速，这就产生了一个略微奇怪的效果，为了让动画看起来更自然，我们需要调整一下缓冲，第十章将会详细说明。
 
    提供一个数组的值就可以按照颜色变化做动画，但一般来说用数组来描述动画运动并不直观。CAKeyframeAnimation有另一种方式去指定动画，就是使用CGPath。path属性可以用一种直观的方式，使用Core Graphics函数定义运动序列来绘制动画。
 
    rotationMode 属性 可以让图片跟随路径移动的时候，跟着切线的方向转动
 
 
 
 
 */
- (void)changeColor{
    //  动画结束开始都是baview 的默认颜色，那么可以证明， CAKeyframeAnimation 不能像 CABasicAnimation 一样自动把当前值作为第一帧，(CABasicAnimation.fromValue = nil)
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 4.0;
    animation.values = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor blackColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
    [self.baview.layer addAnimation:animation forKey:nil];
}

- (void)CAKeyframeAnimation{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, 150)];
    [path addCurveToPoint:CGPointMake(150, 150) controlPoint1:CGPointMake(70, 0) controlPoint2:CGPointMake(100, 300)];
    [path addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(180,0) controlPoint2:CGPointMake(225, 300)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 1.0;
    [self.view.layer addSublayer:layer];
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.bounds = CGRectMake(0, 0, 50, 50);
    imgLayer.position = CGPointMake(0, 150);
    imgLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    imgLayer.contentsGravity = kCAGravityResizeAspectFill;
    [self.view.layer addSublayer:imgLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.rotationMode = kCAAnimationRotateAuto;   // 图片移动时候沿着切线方向转动
    animation.duration = 4.0;
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.repeatCount = MAXFLOAT;
    [imgLayer addAnimation:animation forKey:nil];

}

#pragma mark --  显式动画  --  属性动画
/*
    CAAnimationDelegate在任何头文件中都找不到，但是可以在CAAnimation头文件或者苹果开发者文档中找到相关函数。在这个例子中，我们用-animationDidStop:finished:方法在动画结束之后来更新图层的backgroundColor。
 
    当更新属性的时候，我们需要设置一个新的事务，并且禁用图层行为。否则动画会发生两次，一个是因为显式的CABasicAnimation，另一次是因为隐式动画.
 
    
    CAAnimation实现了KVC（键-值-编码）协议 使用setvalueforkey 和 valueforkey 方法读取属性 
            eg: [animation setValue:handView forKey:@"handView"];  
        CAAnimation 的这种设置 类似于字典，可以随意设置键值对，可以根据动画取出动画属于哪个视图
            eg: UIView *handView = [anim valueForKey:@"handView"];
    然而 在动画结束代理里面将属性值设置为新值
 
 设定动画
 
 设定动画的属性和说明
 
 属性	        说明
 duration	    动画的时长
 repeatCount	重复的次数。不停重复设置为 HUGE_VALF
 repeatDuration	设置动画的时间。在该时间内动画一直执行，不计次数。
 beginTime	    指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
 timingFunction	设置动画的速度变化
 autoreverses	动画结束时是否执行逆动画
 fromValue    	所改变属性的起始值
 toValue	    所改变属性的结束时的值
 byValue    	所改变属性相同起始值的改变量
 

 
 一些常用的animationWithKeyPath值的总结
 
 值                      说明                                使用形式
 transform.scale        比例转化                             	@(0.8)
 transform.scale.x      宽的比例	                            @(0.8)
 transform.scale.y	    高的比例	                            @(0.8)
 transform.rotation.x	围绕x轴旋转	                        @(M_PI)
 transform.rotation.y	围绕y轴旋转	                        @(M_PI)
 transform.rotation.z	围绕z轴旋转	                        @(M_PI)
 cornerRadius	        圆角的设置	                        @(50)
 backgroundColor	   背景颜色的变化	           (id)[UIColor purpleColor].CGColor
 bounds	               大小，中心不变	       [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
 position	          位置(中心点的改变)	   [NSValue valueWithCGPoint:CGPointMake(300, 300)];
 contents	     内容，比如UIImageView的图片	  imageAnima.toValue = (id)[UIImage imageNamed:@"to"].CGImage;
 opacity	              透明度	                            @(0.7)
 contentsRect.size.width 横向拉伸缩放	                   @(0.4)最好是0~1之间的

 */

- (void)CABasicAnimation{
    self.changeColorLayer = [CALayer layer];
    self.changeColorLayer.frame = self.baview.frame;
    self.changeColorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.changeColorLayer];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"backgroundColor";
//    animation.toValue = (__bridge id)[UIColor colorWithRed:(float)(arc4random_uniform(256) /255.0) green:(float)(arc4random_uniform(256) /255.0) blue:(float)(arc4random_uniform(256) /255.0) alpha:1.0].CGColor;
//    
//    animation.delegate = self;
//    [self.changeColorLayer addAnimation:animation forKey:nil];
//    
//}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.changeColorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
    [CATransaction commit];
}


#pragma mark --  隐式动画  --  呈现与模型
/*
 
    当设置CALayer的属性，实际上是在定义当前事务结束之后图层如何显示的模型。Core Animation扮演了一个控制器的角色，并且负责根据图层行为和事务设置去不断更新视图的这些属性在屏幕上的状态。
 
    我们讨论的就是一个典型的微型MVC模式。CALayer是一个连接用户界面（就是MVC中的view）虚构的类，但是在界面本身这个场景下，CALayer的行为更像是存储了视图如何显示和动画的数据模型。实际上，在苹果自己的文档中，图层树通常都是值的图层树模型。
 
    在iOS中，屏幕每秒钟重绘60次。如果动画时长比60分之一秒要长，Core Animation就需要在设置一次新值和新值生效之间，对屏幕上的图层进行重新组织。这意味着CALayer除了“真实”值（就是你设置的值）之外，必须要知道当前显示在屏幕上的属性值的记录。
 
    每个图层属性的显示值都被存储在一个叫做呈现图层的独立图层当中，他可以通过-presentationLayer方法来访问。这个呈现图层实际上是模型图层的复制，但是它的属性值代表了在任何指定时刻当前外观效果。换句话说，你可以通过呈现图层的值来获取当前屏幕上真正显示出来的值
 
    我们在第一章中提到除了图层树，另外还有呈现树。呈现树通过图层树中所有图层的呈现图层所形成。注意呈现图层仅仅当图层首次被提交（就是首次第一次在屏幕上显示）的时候创建，所以在那之前调用-presentationLayer将会返回nil。
 
    你可能注意到有一个叫做–modelLayer的方法。在呈现图层上调用–modelLayer将会返回它正在呈现所依赖的CALayer。通常在一个图层上调用-modelLayer会返回–self（实际上我们已经创建的原始图层就是一种数据模型）。
 
    大多数情况下，你不需要直接访问呈现图层，你可以通过和模型图层的交互，来让Core Animation更新显示。两种情况下呈现图层会变得很有用，一个是同步动画，一个是处理用户交互。
 
        * 如果你在实现一个基于定时器的动画（见第11章“基于定时器的”“动画”），而不仅仅是基于事务的动画，这个时候准确地知道在某一时刻图层显示在什么位置就会对正确摆放图层很有用了。
        * 如果你想让你做动画的图层响应用户输入，你可以使用-hitTest:方法（见第三章“图层几何学”）来判断指定图层是否被触摸，这时候对呈现图层而不是模型图层调用-hitTest:会显得更有意义，因为呈现图层代表了用户当前看到的图层位置，而不是当前动画结束之后的位置。
 
    我们可以用一个简单的案例来证明后者（见清单7.7）。在这个例子中，点击屏幕上的任意位置将会让图层平移到那里。点击图层本身可以随机改变它的颜色。我们通过对呈现图层调用-hitTest:来判断是否被点击。
 
    如果修改代码让-hitTest:直接作用于colorLayer而不是呈现图层，你会发现当图层移动的时候它并不能正确显示。这时候你就需要点击图层将要移动到的位置而不是图层本身来响应点击（这就是为什么用呈现图层来响应交互的原因）。
 
 
 
 */


// 使用  presentationLayer  判断当前图层位置
- (void)presentationLayer{
    self.changeColorLayer = [CALayer layer];
    self.changeColorLayer.frame = self.baview.bounds;
    self.changeColorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.changeColorLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if ([self.changeColorLayer.presentationLayer hitTest:point]) {
        self.changeColorLayer.backgroundColor = [UIColor colorWithRed:(float)(arc4random_uniform(256) /255.0) green:(float)(arc4random_uniform(256) /255.0) blue:(float)(arc4random_uniform(256) /255.0) alpha:1.0].CGColor;
        
    }else{
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.changeColorLayer.position = point;
        [CATransaction commit];
    }
}


#pragma mark --  隐式动画 --  隐式动画原理
/*
    使用隐式动画的时候，比如颜色渐变，会有个过渡效果，而直接设置baview.layer 的背景色的时候，没有动画效果，直接变换。隐式动画好像被uiview 的关联图层给禁用了
    
    试想一下，如果UIView的属性都有动画特性的话，那么无论在什么时候修改它，我们都应该能注意到的。所以，如果说UIKit建立在Core Animation（默认对所有东西都做动画）之上，那么隐式动画是如何被UIKit禁用掉呢？
 
    我们知道Core Animation通常对CALayer的所有属性（可动画的属性）做动画，但是UIView把它关联的图层的这个特性关闭了。为了更好说明这一点，我们需要知道隐式动画是如何实现的。
 
    我们把改变属性时CALayer自动应用的动画称作行为，当CALayer的属性被修改时候，它会调用-actionForKey:方法，传递属性的名称。剩下的操作都在CALayer的头文件中有详细的说明，实质上是如下几步：
 
    1.图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
    2.如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
    3.如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
    4.最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
 
    所以一轮完整的搜索结束之后，-actionForKey:要么返回空（这种情况下将不会有动画发生），要么是CAAction协议对应的对象，最后CALayer拿这个结果去对先前和当前的值做动画。
 
    于是这就解释了UIKit是如何禁用隐式动画的：每个UIView对它关联的图层都扮演了一个委托，并且提供了-actionForLayer:forKey的实现方法。当不在一个动画块的实现中，UIView对所有图层行为返回nil，但是在动画block范围之内，它就返回了一个非空值。我们可以用一个demo做个简单的实验 :  - (void)text
 
    运行程序，控制台显示结果如下：

        LayerTest[21215:c07] Outside: <null>
        LayerTest[21215:c07] Inside: <CABasicAnimation: 0x757f090>
 
    于是我们可以预言，当属性在动画块之外发生改变，UIView直接通过返回nil来禁用隐式动画。但如果在动画块范围之内，根据动画具体类型返回相应的属性，在这个例子就是CABasicAnimation（第八章“显式动画”将会提到）。
 
    当然返回nil并不是禁用隐式动画唯一的办法，CATransacition有个方法叫做+setDisableActions:，可以用来对所有属性打开或者关闭隐式动画。如果在清单7.2的[CATransaction begin]之后添加下面的代码，同样也会阻止动画的发生：
 
    [CATransaction setDisableActions:YES];
 
    总结一下，我们知道了如下几点
 
    UIView关联的图层禁用了隐式动画，对这种图层做动画的唯一办法就是使用UIView的动画函数（而不是依赖CATransaction），或者继承UIView，并覆盖-actionForLayer:forKey:方法，或者直接创建一个显式动画（具体细节见第八章）。
    对于单独存在的图层，我们可以通过实现图层的-actionForLayer:forKey:委托方法，或者提供一个actions字典来控制隐式动画。我们来对颜色渐变的例子使用一个不同的行为，通过给colorLayer设置一个自定义的actions字典。我们也可以使用委托来实现，但是actions字典可以写更少的代码。那么到底改如何创建一个合适的行为对象呢？
 
    行为通常是一个被Core Animation隐式调用的显式动画对象。这里我们使用的是一个实现了CATransaction的实例，叫做推进过渡。
 
    第八章中将会详细解释过渡，不过对于现在，知道CATransition响应CAAction协议，并且可以当做一个图层行为就足够了。结果很赞，不论在什么时候改变背景颜色，新的色块都是从左侧滑入，而不是默认的渐变效果。
 
 
    修改 actions 的字典 来修改默认的动画效果
 
     CATransition *transition = [CATransition animation];
     transition.type = kCATransitionPush;                       // 动画样式   系统的   宏
     transition.subtype = kCATransitionFromLeft;                // 动画过程   系统的   宏
     self.changeColorLayer.actions = @{@"backgroundColor":transition}; // 赋值
 
 */
- (void)changeActions{
    [self yinshidonghua]; // 添加layer
    self.baview.frame = CGRectMake(0, 0, 100, 100);
    self.baview.center = self.view.center;
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.changeColorLayer.actions = @{@"backgroundColor":transition};
    
    
    
}
- (void)text{
    //test layer action when outside of animation block
    NSLog(@"Outside: %@", [self.baview actionForLayer:self.baview.layer forKey:@"backgroundColor"]);
    //begin animation block
    [UIView beginAnimations:nil context:nil];
    //test layer action when inside of animation block
    NSLog(@"Inside: %@", [self.baview actionForLayer:self.baview.layer forKey:@"backgroundColor"]);
    //end animation block
    [UIView commitAnimations];
}



#pragma mark --  隐式动画 --  事务  代码块

/*
 
    Core Animation基于一个假设，说屏幕上的任何东西都可以（或者可能）做动画。动画并不需要你在Core Animation中手动打开，相反需要明确地关闭，否则他会一直存在。
 
    当你改变CALayer的一个可做动画的属性，它并不能立刻在屏幕上体现出来。相反，它是从先前的值平滑过渡到新的值。这一切都是默认的行为，你不需要做额外的操作。
 
    这看起来这太棒了，似乎不太真实，我们来用一个demo解释一下：首先和第一章“图层树”一样创建一个蓝色的方块，然后添加一个按钮，随机改变它的颜色。代码见清单7.1。点击按钮，你会发现图层的颜色平滑过渡到一个新值，而不是跳变
 
    这其实就是所谓的隐式动画。之所以叫隐式是因为我们并没有指定任何动画的类型。我们仅仅改变了一个属性，然后Core Animation来决定如何并且何时去做动画。Core Animaiton同样支持显式动画，下章详细说明。
 
    但当你改变一个属性，Core Animation是如何判断动画类型和持续时间的呢？实际上动画执行的时间取决于当前事务的设置，动画类型取决于图层行为。
 
    事务实际上是Core Animation用来包含一系列属性动画集合的机制，任何用指定事务去改变可以做动画的图层属性都不会立刻发生变化，而是当事务一旦提交的时候开始用一个动画过渡到新值。
 
    事务是通过CATransaction类来做管理，这个类的设计有些奇怪，不像你从它的命名预期的那样去管理一个简单的事务，而是管理了一叠你不能访问的事务。CATransaction没有属性或者实例方法，并且也不能用+alloc和-init方法创建它。但是可以用+begin和+commit分别来入栈或者出栈。
 
    任何可以做动画的图层属性都会被添加到栈顶的事务，你可以通过+setAnimationDuration:方法设置当前事务的动画时间，或者通过+animationDuration方法来获取值（默认0.25秒）。
 
    Core Animation在每个run loop周期中自动开始一次新的事务（run loop是iOS负责收集用户输入，处理定时器或者网络事件并且重新绘制屏幕的东西），即使你不显式的用[CATransaction begin]开始一次事务，任何在一次run loop循环中属性的改变都会被集中起来，然后做一次0.25秒的动画。
 
    明白这些之后，我们就可以轻松修改变色动画的时间了。我们当然可以用当前事务的+setAnimationDuration:方法来修改动画时间，但在这里我们首先起一个新的事务，于是修改时间就不会有别的副作用。因为修改当前事务的时间可能会导致同一时刻别的动画（如屏幕旋转），所以最好还是在调整动画之前压入一个新的事务。
 
 
    如果你用过UIView的动画方法做过一些动画效果，那么应该对这个模式不陌生。UIView有两个方法，+beginAnimations:context:和+commitAnimations，和CATransaction的+begin和+commit方法类似。实际上在+beginAnimations:context:和+commitAnimations之间所有视图或者图层属性的改变而做的动画都是由于设置了CATransaction的原因。
 
    在iOS4中，苹果对UIView添加了一种基于block的动画方法：+animateWithDuration:animations:。这样写对做一堆的属性动画在语法上会更加简单，但实质上它们都是在做同样的事情。
 
    CATransaction的+begin和+commit方法在+animateWithDuration:animations:内部自动调用，这样block中所有属性的改变都会被事务所包含。这样也可以避免开发者由于对+begin和+commit匹配的失误造成的风险。
 
 
   使用CATransaction 开始结束动画   通过设置时间来操作    不断点击 不断动画 动画过渡过程中，结束颜色变化，动画过程会跟着结果变化
 
    
 
    完成块儿
    CATransaction setCompletionBlock:    在block 里面写完成后的代码，
        block里面的代码是在颜色变化事务提交之后提交的， 旋转是在颜色变化的同时进行旋转，旋转的时间是 0.25s   在颜色变化的时候，旋转好像同时进行，并没有感觉到有先后顺序。
        更改顺序之后， 谁在前谁就按照自定义的时间执行。谁在后就是默认的0.25秒
 
    书中的解释：注意旋转动画要比颜色渐变快得多，这是因为完成块是在颜色渐变的事务提交并出栈之后才被执行，于是，用默认的事务做变换，默认的时间也就变成了0.25秒。
 
 
 */
- (void)yinshidonghua{
    // 加上 touch 方法
    CALayer *layer = [CALayer layer];
    self.changeColorLayer = layer;
    layer.frame = self.baview.bounds;
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.baview.layer addSublayer:self.changeColorLayer];
    
}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    //  使用CATransaction 开始结束动画   通过设置时间来操作    不断点击 不断动画 变化过程中，结束颜色变化，动画过程会跟着结果变化
//    [CATransaction begin];
//
//    self.changeColorLayer.backgroundColor = [UIColor colorWithRed:(float)(arc4random_uniform(256) /255.0) green:(float)(arc4random_uniform(256) /255.0) blue:(float)(arc4random_uniform(256) /255.0) alpha:1.0].CGColor;
//    [CATransaction setCompletionBlock:^{
//    
//        CGAffineTransform transform = self.changeColorLayer.affineTransform;
//        transform = CGAffineTransformRotate(transform, M_PI_4);
//        self.changeColorLayer.affineTransform = transform;
//    }];
//    
//    
//    [CATransaction setAnimationDuration:2.0];
//    [CATransaction commit];
//    
//}
//




@end
