//
//  ViewController_01.m
//  CA动画
//
//  Created by 1 on 2017/8/9.
//  Copyright © 2017年 深圳市全日康健康产业股份有限公司. All rights reserved.
//

#import "ViewController_01.h"

@interface ViewController_01 ()<CAAnimationDelegate>
@property (nonatomic, strong) UITextField *text_01;
@property (nonatomic, strong) UITextField *text_02;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;

@property (nonatomic, strong) CALayer *shipLayer;


//基于定时器动画 添加的属性
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeoffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@end

@implementation ViewController_01



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.text_01];
    [self.view addSubview:self.text_02];
    [self.view addSubview:self.stopBtn];
    [self.view addSubview:self.startBtn];
    
    
    
//    [self repeatCountAndDuration];
//    [self CAMediaTimingFunction];
//    [self CAKeyframeAnimationUseCAMediaTimingFunction];
//    [self jumpAndDown];
//    [self jumpAndDownYouhua];
    [self timerJumpAndDownYouhua];
    
}
#pragma mark --  GPU VS CPU
/**
 
    **********************************************************************************
        纹理,纹理就是矩形的数据数组，例如颜色数据、亮度数据、颜色、和alpha数据，纹理数组中的单个值常常成为纹理单元，也叫纹素（texel）这里让它区别与像素主要是为了强调它的应用方式，
        纹理映射就是要实现如何把纹素映射到几何对象的每个点，一个2D的纹理有一个宽度和高度，通过宽度和高度相乘即可得到有多少个纹素
        纹理的单位 在 0-1 ， 纹素位置  就是   宽 ： 纹理宽 * 宽   高 ： 纹理高 * 高
    **********************************************************************************
    绘图和动画，有两种实现方式，CPU、GPU。 现在iOS设备中，都有可以运行不同软件的可编程芯片，但是由于历史原因。因为历史原因，可以说CPU所做的工作都是在软件层面上，GPU在硬件层面上。
    总的来说，软件可以使用CPU做任何事情，但是图形处理还是硬件更快，因为GPU使用图像对高度并行浮点运算做了优化。由于某些原因，我们想尽可能吧屏幕渲染的工作交给硬件去处理，问题在于GPU并不能无限制处理性能，而且一旦资源用完了，性能就开始下降，即使CPU并没有完全用完。
    大多数动画性能优化都是关于智能利用GPU与CPU。使得它们不会超出负荷。先说Core Animation 是如何处理两个处理器之间分配工作
 
    
    动画的舞台:
        Core Animation 处在iOS核心地位，在应用内和应用间都会用到它，一个简单的动画可能同步显示多个app内容，比如ipad多程序之间手势切换，会是的多个程序同事显示在屏幕上，在一个特定的应用中用代码是不能实现的，app 都是被沙箱管理，不能访问别的视图
        动画和屏幕上组合的图层实际上被一个单独的进程管理，而不是应用程序，这个进程就是所谓的渲染服务，在iOS5和之前的版本叫 SpringBoard 进程（同事管理iOS主屏）,正在iOS6只后的版本叫 BackBoard
        当运行一段动画的时候，过程会被四个分离的阶段打破：
            1.布局  准备视图/图层的层级关系，以及设置图层属性（位置、背景色、边框等）
            2.显示  这是在图层的寄宿图片被绘制的阶段，绘制有可能涉及你的 -drawRect： 和 -drawLayer：inContext：方法的调用路径
            3.准备  这是在CoreAnimation 准备发送动画数据到渲染服务的阶段，这同事也是CoreAnimation将要执行一些别的食物，例如解码动画过程中将要显示的图片的时间点。
            4.提交  这是最后的阶段， CoreAnimation 打包所有图层和动画属性，然后通过IPC（内部处理通信/进程间通信）发送到渲染服务进行显示
        
        这些仅仅阶段仅仅发生在你的应用程序之间，在动画在屏幕渲染服务进程，他们会被反序列化来形成另一个叫做渲染树的图层树，使用这个树状结构，渲染服务队动画的，每一帧做出如下工作:
            1.对所有图层的属性计算中间值，设置OpenGL几何形状（纹理化的三角形）来执行渲染
            2.在屏幕上渲染可见的三角形
 
        所以  一共有6个阶段，最后两个阶段在动画过程中不停地重复，前五个阶段是在软件层面CPU处理，只有最后一个被GPU执行，而且，真正只能控制前两个阶段，布局和显示，Core Animation 框架在内部处理剩下的事务，你也控制不了它。
 
        这不是个问题，因为在布局和显示阶段，可以决定哪些有CPU执行，哪些交个GPU去做。
    
        GPU 为一个具体的任务做了优化:它用来采集图片和形状（三角形），运行变换，应用纹理和混合然后把它们输送到屏幕上，现代iOS设备上可编程的GPU在这些操作的执行上又有很大的灵活性，但是Core Animation 并没有暴露出直接的接口，除非想绕开 Core Animation 并编写自己的OpenGL着色器，从根本上解决硬件加速的问题，那么剩下的所有都是还需要在CPU的软件层面完成，
        宽泛的说，大多数 CALayer 属性都是用GPU来绘制，比如设置图层的背景或者边框颜色，那么这些可以通过着色的三角板实时绘制出来，如果对一个contents属性设置一张图片，然后裁剪它，它就会被文理的三角形绘制出来，而不需要软件层面做任何绘制
        但是有一些事情会降低（基于GPU）图层绘制。比如:
 
            1.太多的几何结构 -- 这发生在需要太多的三角板来做变换，以应对处理器的栅格化的时候。现在iOS设备的图形芯片可以处理几百万个三角板，所以在CoreAnimation中几何结构并不是GPU的瓶颈，但是，由于图层在现实之前通过IPC发送到渲染服务器的时候（图层实际上是由很多小物体组成的特别重量级的对象）太多的图层就会引起CPU的瓶颈，这就限制了一次展示的图层个数。--- 见后续的 CPU相关操作
            2.重绘 -- 主要有重叠的半透明图层引起。GPU的填充比率（用颜色填充像素的比率）是有限的，所以需要避免重绘（每一帧用相同的像素填充多次）的发生。在现代iOS设备上，GPU都会应对重绘；即使是iPhone3GS都可以处理高达2.5的重回比率，并仍然保持60帧率的渲染（这以为这可以绘制一个半的整屏冗余信息而不影响性能），并且新设备可以处理更多。
            3.离屏绘制 -- 这发生在当不能直接在屏幕上绘制，并且必须绘制到离屏图片的上下文中的时候，离屏绘制发生在基于CPU或者是GPU的渲染，或者是为离屏图片分配额外内存，以及切换绘制上下文，这些都会降低GPU性能，对于特定图层效果的使用，比如圆角，图层遮罩，阴影或者图层光栅化都会强制CoreAnimation提前渲染图层的离屏绘制，但这部以为这你需要避免使用这些效果，只是要明白这会带来性能的负面效果。
            4. 过大的图片 -- 如果视图绘制超出GPU支持的 2048x2048 或者 4096x4096 尺寸的文理，就必须要用CPU在图层每次显示之前对图片预处理，同样会降低性能，----------一般情况没有这么大图片要处理，比如地图什么大图，可以分为小图片加载，可以使用专用图层CATiledLayer来解决-------
 
    CPU相关操作
        大多数工作在CoreAnimation 的CPU都发生在动画开始之前，这以为着它不会影响帧率，但是它会在延迟动画开始的时间让界面看起来比较迟钝
        以下CPU的操作都会延迟动画的卡是时间:
            1.布局计算 - 如果你的视图层级过于复杂，当视图呈现或者修改的时候，计算图层帧率就会消耗一部分时间，特别是使用iOS6的自动布局机制尤为明显，它应该是比老板的自动调整逻辑加强了CPU的工作。
            2.视图懒加载 - iOS只会在当视图控制器的视图显示到屏幕上是才会加载它，这对于内存使用和程序启动时间都很有好处，但是当呈现到屏幕上之前，按下按钮导致许多工作都不能被及时响应，比如控制器从数据库获取数据，或者视图从一个nib文件中国家在，或者设计IO的图片显示--后续IO相关操作。都会比CPU正常操作慢的多。
            3.Core Graphics绘制 - 如果对视图实现了 -drawRect: 方法 或者 CALayerDelegate 的 -drawLayer: inContext: 方法，那么在绘制任何东西之前都会产生一个巨大的性能开销。为了支持对图层内容的任意绘制，Core Animation必须创建一个内存中等大小的寄宿图片，然后一旦回执结束之后必须吧图片数据通过IPC传到渲染服务器，再次基础上， Core Graphics 绘制就变的十分缓慢，所以在一个对性能十分挑剔的场景下这样做十分不好
            4.解压图片 - PNG或者JPEG压缩之后的图片文件会比同质量的位图小的多，但是在图片绘制到屏幕上之前，必须把它扩展成完整的未解压的尺寸，通常等于 长x宽x4 个字节，为了节省内存，iOS通常在真正绘制的时候才去解码图片，根据加载图片的方式第一次对图层内容复制的时候，（直接或间接使用UIImageView）或者把它绘制到 Core Graphics中，都需要对它解压，这样的话，对于一个较大的图片，都会占用一定的时间
        
        当图层被成功打包，发送到渲染服务器之后，CPU仍然要做如下工作：为了显示屏幕上的图层，CoreAnimation 必须对渲染树中的每个可见图层通过OpenGL循环转换成纹理三角板，由于GPU并不知晓CoreAnimation涂岑搞定任何结构，所以必须要由CPU做这些事情，这里CPU涉及的工作和图层个数成正比，所以在层级关系中有太多的图层，就会导致CPU每一帧的渲染，及时这些事情不是你的应用程序可控.
 
    IO 相关操作
        IO 操作 -- 上下文中的IO(输入/输出) 指的是例如山村或者网络接口的硬件访问，一些动画可能需要从山村深圳市远程URL来加载，一个典型的栗子就是两个试图控制器之间的过渡效果，这就需要从一个nib 文件或者其他的内容中懒加载，或者一个旋转的图片，可能在内存中尺度太大，需要动态滚动来加载。
        IO 比内存访问更慢，所以如果动画涉及到IO，就是一个大问题，总的来说，这就需要使用聪敏但尴尬的技术，也就是多线程，缓存和投机加载(提前加载当前不需要的资源，但是之后可能需要用到)  之后会讨论
 
 
 */

#pragma mark --  物理模拟
/*    先放放   能用动画解决不用仿真，仿真的性能开销比较大，计算比较多    */


#pragma mark --  基于定时器的动画
/**
    用定时器来完成弹性球的栗子
        实现不太好
            位置打印没太大问题   最低点的位置不是268  所以动画过程出问题，不能到底，刷新越快 到底的效果越不明显，好像中间停顿一样
 ***********************************************************************************************************************
        NSTimer 处理并不是最佳方案，这涉及到 NSTimer 和 NSRunloop 的实现
        
            NSRunloop 
                循环完成一些任务列表。但是对主线程，这些任务包括:
                    1.处理触摸事件            touchEvent
                    2.发送和接受网络数据包      http
                    3.执行使用 GCD 代码       GCD
                    4.处理计时器行为           timer
                    5.屏幕重绘                
        
        当设置一个NSTimer ，它会被插入到当前任务列表中，然后知道指定时间过去之后才会被执行，但是何时启动定时器并没有一个时间上限，而且它只会在列表上一个任务完成之后开始执行，这通常导致有几毫秒的延迟，但是如果上一个任务过了很久才完成就会导致延迟很长一段时间
        
        屏幕重绘的频率是一秒60次，但是和定时器行为一样，如果列表中上一个任务执行了很长时间它也会延迟，这些延迟都是一个随机值，于是就不能保证定时器精准的一秒钟执行60次，有时候屏幕重绘之后，这就会使得更新屏幕会有个延迟，看起来就是动画卡壳了，有时候定时器会在屏幕更新的时候执行两次，于是动画看起来就跳动了。
        
        可以通过一些途径来优化
            1. 使用CADisplayLink 来优化，让更新频率更严格控制在每次屏幕刷新之后
            2. 基于真实帧的持续时间而不是假设的更新频率来做动画，
            3. 调整动画计时器的 runloop 模式，保证不会被别人干扰
 ***********************************************************************************************************************
 
 
 CADisplayLink Core Animation 提供的 当做 NSTimer 的一个替代类,接口设计和NSTimer 很相似，但是和 timeInterval 以秒为单位不同，CADisplayLink 有一个整形的 frameInterval 属性，指定了间隔多少帧之后才执行，默认是1 意味着 1分60帧 ，如果是2  那么， 1分30帧
 
 无论是NSTimer 还是CADisplayLink 我们仍然需要处理一阵的时间超出了预期的 1/60秒 ，由于我们不能够计算出一帧真实的持续时间，所以需要手动测量，可以在每帧开始刷新的时候用CACurrentMediaTime() 记录当前时间然后和上一阵记录去比较
 通过比较时间就可以得到真实的每帧持续时间，然后代替硬编码的 1/60 秒
 
 
 Runloop 模式 
        在床减一个 CADisplayLink 的时候，需要制定一个 runloop 和 runloopMode ，对于 runloop来说，使用了主线程的runloop ，任何界面更新都要在主线程执行，但是模式的选择就并不那么清楚了，每个添加到 Runloop 的任务都有了一个指定的优先级的模式，为了保证用户界面平滑， iOS提供和界面相关任务的优先级，当UI 很活跃的时候，的确会暂停一些别的任务来保证界面的平滑。最典型的就是 UIScrollView 滑动到时候，重绘滚动视图的内容会比别的任务优先级更高，所以标准的NSTimer和网络请求就不会启动，一些常见的 runloop 模式有三:
                1. NSDefaultRunloopMode 默认 优先级
                2. NSRunloopCommonMedes 高优先级
                3. UITrackingRunloopMode 用于 UIScrollView 和别的控件的动画
 
        在栗子中使用的是默认优先级。但是不能保证动画平滑运行，所以就可以用搞优先级来替代，但是如果动画在一个高帧率情况下运行，就会发现一些别的比如定时器（UIScrollView 滑动时候，轮播停止左右滚动） 任务会暂停，直到动画结束
        同样可以对 CADisplayLink 指定多个RunLoop模式。保证不会被滑动打断，也不会被其他UIKit 控件动画影响性能， 
            eg:
             [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
             [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
 
 
 */
- (void)timerJumpAndDownYouhua{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.shipLayer.position = CGPointMake(150, 32);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guanjianzhenTimerYouhua:)]];
    
}
- (void)guanjianzhenTimerYouhua:(UITapGestureRecognizer *)tap{
    self.duration = 10.0;
    self.timeoffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    
    [self.timer invalidate];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
    
}
- (void)timerBegin:(NSTimer *)timer{
    self.timeoffset = MIN(self.timeoffset + 1/60.0, self.duration);
    float time = self.timeoffset / self.duration;
    time = bounceEaseOut(time);
    id position = [self interpolateFromValue:self.fromValue toValue:self.toValue time:time];
    
    // 位置打印没太大问题   最低点的位置不是268  所以动画过程出问题，不能到底，刷新越快 到底的效果越不明显，好像中间停顿一样
    NSLog(@"%@",[position description]);
    self.shipLayer.position = [position CGPointValue];
    if (self.timeoffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark --  流程自动化   关键帧缓冲的优化方式
/**
    在下面的 基于关键帧缓冲 把动画分割成几大块，然后用 Core animation 的缓冲进入和缓冲退出函数来形成想要的曲线。但是如果我们把动画分割成更小的几部分，那么我们就可以用直线来拼接这些曲线，也就是线性缓冲。 此时需要知道如何做如下两件事情:
        1. 自动把任意属性动画分割成多个关键帧
        2. 用一个数学函数表示弹性动画，使得可以对帧做偏移
 
    解决第一个问题: 复制 Core Animation 的插值机制。 这是一个传入起点和终点，然后在这两个点之间的指定时间点产出一个新点的机制，对于简单的浮点起始值。公式如下
        
        value = (endValue - startValue ) * time + startValue;
    
    那么如果要插入一个类似于 CGPoint ，CGColorRef 或者 CATransform3D 这种更加复杂类型的值， 可以简单的对么个独立的元素应用这种犯法，也就是 CGPoint 中的 x和y 值，CGColorRef 中的 红蓝绿透明值  或者 CATransform3D 终点独立矩阵的坐标。 我们同样需要一些逻辑在插值之前对对象拆解值，然后在插值之后再重新封装成对象，也就是说需要实时地检查类型
    
    一旦可以用代码获取属性动画的起始值之间的任意插值，我们就可以吧动画分割成许多独立的关键帧，然后产出一个线性的关键帧动画，
    
    这个方法执行出来的是直下的动画过程   可以修改   float interpolate(float from , float to , float time)  里面的返回值来修改运动轨迹
    
    修改运动轨迹， 只需要通过  起始位置，结束为止，运动时间， 找出一个合适的 方程 就可以做属性动画的轨迹动画   
    国外大佬 罗伯特·彭纳  有一个关于缓冲函数的多重编程语言实现的连接，包括c   http://www.robertpenner.com/easing
************************************************************************************************************************
 
    NSValue 有一个属性 objCType  将 NSValue 值的类型转化为 OC 的类型， @property (readonly) const char *objCType NS_RETURNS_INNER_POINTER;
    
    int	 strcmp(const char *__s1, const char *__s2); 
    strcmp 比较两个字符串，如果字符串 1  大于字符串 2  返回正值， 小于 负值， 等于 0；
        比较过程，对字符串中各字符按顺序比较 ASCII 值， 遇着不等的，就返回结果，遇到相等的继续下一位，最后一位，短的末尾是 '/0' ，'/0' 的 ASCII 值小于 0-Z，得出结果， 所以比较会直到最后一位
 
************************************************************************************************************************
 
 
 */

- (void)jumpAndDownYouhua{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.shipLayer.position = CGPointMake(150, 32);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guanjianzhenyouhua:)]];

}
- (void)guanjianzhenyouhua:(UITapGestureRecognizer *)tap{
    
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 32)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 268)];
    CFTimeInterval duration = 1.0;
    
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++ ) {
        float time = 1/(float)numFrames * i;
        time = bounceEaseOut(time);
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = frames;
    [self.shipLayer addAnimation:animation forKey:nil];
    
}

// 函数

//国外大佬计算的函数
float quadraticEaseInOut(float t)
{
    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}

// 国外大佬计算的弹性球函数
float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}
// 平稳下落的函数
float interpolate(float from , float to , float time){
    return (to - from) * time + from;
}
// 计算出来的 position
- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    return (time < 0.5) ? fromValue : toValue; // 防错
}
#pragma mark --  基于关键帧的缓冲
/**
    皮球落地 、弹起、落地、弹起、最后不弹起
 
    这种方式还算不错，实现动画，但是比较笨重， 因为，不停的尝试计算各种关键帧和时间偏移，并且和动画强绑定了， 若果要改变动画的一个属性，那就意味着要重新计算所有的关键帧。   怎么样用缓冲函数吧任何一个简单的属性动画转换成关键帧动画？ 看上面  流程自动化
 
    CAKeyframeAnimation 做分段动画
 
    keyTime 对应 的是 动画时间的比例，  放的是 @0.0 ~ @1.0 之间的数    对应 animation.values 每一个元素的位置。
    
    timingFunction 对应的是每段动画的 缓冲函数 所以，比 animation.values 少一个元素
 
 
 ************************************************************************************************************************
    属性动画 CAKeyframeAnimation 设置完成之后，再给 layer 或者 view 设置position 或者其他属性， 会在动画完成之后， 在执行这一句设置代码
 ************************************************************************************************************************
 
 */
- (void)jumpAndDown{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.shipLayer.position = CGPointMake(150, 32);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpAndDown:)]];
    
}
- (void)jumpAndDown:(UITapGestureRecognizer *)tap{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 2.0;
    animation.delegate = self;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 268)],
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
                                  ];
    animation.keyTimes = @[
                           @0.0,
                           @0.3,
                           @0.5,
                           @0.7,
                           @0.8,
                           @0.9,
                           @0.95,
                           @1.0
                           ];
    
    self.shipLayer.position = CGPointMake(150, 132);
    [self.shipLayer addAnimation:animation forKey:nil];
    
}

#pragma mark --  自定义更复杂的运动曲线 
/**
    更加复杂的动画没法子用三次贝塞尔曲线表示。不能用 CAMediaTimingFunction 完成， 要实现效果，可以用如下的方法
        1. 用 CAKeyframeAnimation 创建动画， 分割成几个步骤，每个步骤用自己的计时函数。  --  往上看
        2. 使用定时器逐帧更新实现动画， -- 参见 基于定时器的动画
 
 */

#pragma mark --   自定义缓冲函数   三次贝塞尔曲线
/**
 
 
 //    根据  已定义的缓冲值 来创建  缓冲函数   CAMediaTimingFunction
 + (instancetype)functionWithName:(NSString *)name;
 

 
 //  自定义缓冲函数， 三次贝塞尔缓冲曲线，   起点是 （0，0），终点是（1，1），填入 中间2个值的坐标 0~1 之间的小数
+ (instancetype)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
- (instancetype)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;


//  获取三次贝塞尔曲线中设置的点     index 在 0-3 之间   一个四个点   ptr 是一个数组，float 精度 的 数组，
- (void)getControlPointAtIndex:(size_t)idx values:(float[2])ptr;

 eg:
    CGPoint controlPoint2;
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    nslog(@"%@",controlPoint2);   此时的 point 已经被赋值
 
 */

#pragma mark --  缓冲和关键帧动画
/**
    在颜色切换的关键帧动画中，由于是线性变换，所以看起来颜色有点不自然，没有缓冲来的好，
    CAKeyframeAnimation 有个NSArray 类型的timingFunctions 属性，可以用这个来对每次动画的步骤指定不同的计时函数，但是指定函数的个数一定要等于keyframes 数组的元素个数减 1 因为它是描述每一帧之间动画速度的函数。
    
    对CAKeyframeAnimation 使用 CAMediaTimingFunction
 
    方法可以有，恕我直言   这特么的效果并没有看出来有多厉害   眼拙
 */
- (void)CAKeyframeAnimationUseCAMediaTimingFunction{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CAKeyframeAnimationUseCAMediaTimingFunction:)]];
}
- (void)CAKeyframeAnimationUseCAMediaTimingFunction:(UITapGestureRecognizer *)tap{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor yellowColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         ];
    CAMediaTimingFunction *fn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[fn,fn,fn];
    
    [self.shipLayer addAnimation:animation forKey:nil];
}
#pragma mark --  UIView 的缓冲动画
/**
    相对于 QuartCore 框架的5个缓冲函数， UIKit 动画也支持这些缓冲方法的使用，尽管语法和常量有些不同，为了改变UIView 动画的缓冲选项给 options 参数添加如下常量:
         UIViewAnimationOptionCurveEaseInOut
         UIViewAnimationOptionCurveEaseIn
         UIViewAnimationOptionCurveEaseOut
         UIViewAnimationOptionCurveLinear
    
    几个参数与 CAMediaTimingFunction 紧密关联， UIViewAnimationOptionCurveEaseInOut 是默认值
 
 options 参数:

 UIView animateKeyframesWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:<#(UIViewKeyframeAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
 
 */


#pragma mark --   缓冲函数
/**
    现实生活中能的任何一个物体都会在运动中加速或者减速， 那么，实现这种加速度，----- 称这种类型的方程为 缓冲函数
        1.使用物理引擎对物体的摩擦和动量建模，然而太复杂
        2.Core Animation 内嵌了一系列标准函数
    
    CAMediaTimingFunction
 
    首先需要设置 CAAnimation 的timingFunction 属性 ，是CAMediaTimingFunction 类的一个对象，如果想改变隐式动画的计时函数，同样的可以使用 CATransction 的 + setAnimationTimingFunction 方法
    
    创建CAMediaTimingFunction 最简单的方式是调用 +timingFunctionWithName: 的构造方法  传入如下常亮之一
         kCAMediaTimingFunctionLinear           // 默认函数，线性步调对于那些立即加速并且保持匀速到达终点的场景
         kCAMediaTimingFunctionEaseIn           // 慢慢加速，然后突然停止，对之前提到的自由落体栗子合适
         kCAMediaTimingFunctionEaseOut          // 全速开始，然后慢慢减速停止，比如，慢慢关门
         kCAMediaTimingFunctionEaseInEaseOut    // 慢慢加速，然后慢慢减速， 使用UIView 的动画方法时，它是默认的,CAAnimation动画需要手动设置
         kCAMediaTimingFunctionDefault          // 慢慢加速，慢慢减速，和EaseInEaseOut很像，做隐式动画不是默认，做显示动画，需要设置
 
 
 经测试   没觉得 有什么差异。。。。都差不多
 
 
 */

- (void)CAMediaTimingFunction{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCAMediaTimingFunction:)]];
    
}
- (void)clickCAMediaTimingFunction:(UITapGestureRecognizer *)tap{
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.shipLayer.position = CGPointMake(100, 100);
    [CATransaction commit];
}

#pragma mark --   手动动画
/**
 
    layer 的 timeOffset 和 speed 属性   不是   CABasicAnimation 的属性  animation
 
        timeOffset 还有一个功能就是手动控制动画进程，通过设置  speed = 0  可以禁止动画自动播放，然后使用 timeOffset 来来回显示动画序列，这可以使得运用手势来手动控制动画变得很简单，
        
        比如之前开关门的动画
            给添加一个手势 然后 添加动画之类
 
    当然 直接修改 旋转角度也是能够完成这个效果  甚至更简单一点，
    但是， 在多个图层多个动画的时候，再来计算旋转角度就显得麻烦
    用这种方式就很方便了
*/
- (void)shoudongAnimation{
    [self.view.layer addSublayer:self.shipLayer];
    self.shipLayer.speed = 0.0;
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = transfrom;
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    
    animation.duration = 1.0;
    
    [self.shipLayer addAnimation:animation forKey:@"shoudongAnimation"];
}
-(void)pan:(UIPanGestureRecognizer *)pan{
    CGFloat x = [pan translationInView:self.view].x;
    x /= 100.0f;
    CFTimeInterval timeOffset = self.shipLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    NSLog(@"x = %lf",timeOffset);
    self.shipLayer.timeOffset = timeOffset;
    [pan setTranslation:CGPointZero inView:self.view];
}



#pragma mark --  fillMode
/**
    对于 beginTime 非 0 的一段动画来说， 会出现一个当动画添加到图层上但什么也没发生的状态， 类似的，removeOnCompletion 被设置为NO 的动画 讲会在动画结束的时候，仍然保持之前的状态，这就产生了一个问题，档动画开始之前和动画结束之后，被设置动画的属性将会是什么值？
 
    一种可能是属性和动画没被添加之前保持一致，也就是在模型图层定义的值（见第七章“隐式动画”，模型图层和呈现图层的解释）。
 
    另一种可能是保持动画开始之前那一帧，或者动画结束之后的那一帧。这就是所谓的填充，因为动画开始和结束的值用来填充开始之前和结束之后的时间。
 
    这种行为就交给开发者了，它可以被CAMediaTiming的fillMode来控制。fillMode是一个NSString类型，可以接受如下四种常量:
 
    kCAFillModeForwards
    kCAFillModeBackwards
    kCAFillModeBoth
    kCAFillModeRemoved
 
    默认是kCAFillModeRemoved，当动画不再播放的时候就显示图层模型指定的值剩下的三种类型向前，向后或者即向前又向后去填充动画状态，使得动画在开始前或者结束后仍然保持开始和结束那一刻的值。
 
    这就对避免在动画结束的时候急速返回提供另一种方案（见第八章）。但是记住了，当用它来解决这个问题的时候，需要把removeOnCompletion设置为NO，另外需要给动画添加一个非空的键，于是可以在不需要动画的时候把它从图层上移除。
 
 
 
 */

#pragma mark --  相对时间 
/**
 
    相对时间   每次讨论到 Core Animation 时间都是相对的，每个动画都有它自己描述的时间，可以独立地加速，延时或者偏移。
    
    beginTime 指定了动画开始之前的延迟时间， 这里的延迟从动画添加到可见图层的那一刻开始测量， 默认是0 -- 动画立刻执行。
    
    speed 是一个时间的倍数， 默认1.0 减少它会减慢图层/动画的时间， 增加它2会加快速度， 如果2.0 的速度，那么对于一个duration 为1 的动画 ， 实际上在0.5秒的时候就完成了。
 
    timeOffset 和 beginTime 类似，但是和增加 beginTime 导致的延迟动画不同， 增加 timeOffset 只是让动画快进到某一点。例如，对于一个持续1秒动画来说， 设置timeOffset 为0.5 那么，动画将从一半的地方开始。
    和 beginTime 不同的是 timeOffset 并不受 speed 的影响， 所以，如果把 speed 设为 2.0 把 timeOffset 设置为 0.5 ，那么你的动画将从动画最后结束的地方开始，因为，因为 speed 为2.0 动画实际时差 为0.5秒， 设置 timeOffset 为0.5。 动画已经完了，将从动画最后结束的地方开始，从头播放一次
 
    作为 CABasicAnimation 的属性设置，
 
 
 
 */


#pragma mark --  CAMediaTiming 重复和持续

/**
    duration 是CFTimeInterval 的类型（类似NSTimeInterval 的一种双精度浮点类型）对将要进行的动画的一次迭代指定时间
    repeatCount 代表动画重复的迭代次数，
    如果 duration = 2 repeatCount = 3.5  那么完整的动画时间 将是 7秒
    
    duration 和 repeatCount 的默认值是0 ， 但是 并不带表是 0 秒或者 0 次， 而是代表默认--- 0.25 秒 / 1次。
 
    另一种设置重复动画的方式   repeatDuration
    
    repeatDuration: 让动画重复一个指定的时间，而不是次数，  INFINITY  无限大的时间
    autoreverses  : BOOL 属性，设置在每次间隔交替循环过程中自动回访，这对于播放一段非连续动画很有帮助，比如打开一扇门，然后关上
    这种动画方式 需要设置单次的动画时间，然后，
 
 */
- (void)repeatCountAndDuration{
    self.shipLayer.contents = (__bridge id)[UIImage imageNamed:@"lingnai"].CGImage;
    [self.view.layer addSublayer:self.shipLayer];
}


- (void)startRepeatCountAndDuration{
    CFTimeInterval duration = [self.text_01.text doubleValue];
    CGFloat repeatCount = [self.text_02.text doubleValue];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.byValue = @(M_PI_2);
    animation.delegate = self;
    [self.shipLayer addAnimation:animation forKey:@"rotateAnimation"];
    [self setControllersEnable:NO];
}

- (void)repeatDuration{
    CATransform3D perspectvie = CATransform3DIdentity;
    perspectvie.m34 = - 1.0/ 500.0;
//    self.shipLayer.doubleSided = NO;  //是否绘制背面
    self.shipLayer.sublayerTransform = perspectvie;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = @(-M_PI);
    animation.duration = 2.0;
    animation.repeatDuration = INFINITY;
    animation.autoreverses = YES;
    animation.keyPath = @"transform.rotation.y";
    [self.shipLayer addAnimation:animation forKey:nil];
    
}


- (void)setControllersEnable:(BOOL)enabled{
    for (UIControl *control in @[self.text_01,self.text_02,self.stopBtn,self.startBtn]) {
        control.enabled = enabled;
        
        control.alpha = enabled ? 1.0 : 0.25;
        if (control == self.stopBtn) {
            control.alpha = enabled ? 0.25 : 1.0;
            control.enabled = !enabled;
        }
        
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && (anim ==  [self.shipLayer animationForKey:@"rotateAnimation"]))   {
        [self setControllersEnable:flag];
    }
}



- (void)start{
    //    [self startRepeatCountAndDuration];  //  repeatCountAndDuration   重复动画
    //    [self repeatDuration];    //  repeatDuration   重复动画
    [self shoudongAnimation];  //   手动动画
}
- (void)stop{
    [self setControllersEnable:YES];
    
    
    //rotateAnimation     repeatCountAndDuration 方法的重复动画
    if ([self.shipLayer animationForKey:@"rotateAnimation"] != nil) {
        [self.shipLayer removeAnimationForKey:@"rotateAnimation"];
    }
}

#pragma mark --  lazy
- (CALayer *)shipLayer{
    if (!_shipLayer) {
        _shipLayer = [CALayer layer];
        _shipLayer.bounds = CGRectMake(0, 0, 100, 100);
        _shipLayer.contentsGravity = kCAGravityResizeAspectFill;
        _shipLayer.position = self.view.center;
    }
    return _shipLayer;
}
- (UITextField *)text_01{
    if (!_text_01) {
        _text_01 = [[UITextField alloc]initWithFrame:CGRectMake(30, 20, 100, 30)];
        _text_01.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _text_01.text = @"3";
    }
    return _text_01;
}
- (UITextField *)text_02{
    if (!_text_02) {
        _text_02 = [[UITextField alloc]initWithFrame:CGRectMake(230, 20, 100, 30)];
        _text_02.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _text_02.text = @"2";
    }
    return _text_02;
}
- (UIButton *)stopBtn{
    if (!_stopBtn) {
        _stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 55, 100, 30)];
        [_stopBtn setTitle:@"stop" forState:UIControlStateNormal];
        [_stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [_stopBtn setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [_stopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _stopBtn;
}
- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 55, 100, 30)];
        [_startBtn setTitle:@"start" forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _startBtn;
}


@end
