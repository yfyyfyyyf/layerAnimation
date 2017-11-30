//
//  ViewController.m
//  LayerText
//
//  Created by 杨果果 on 2017/5/15.
//  Copyright © 2017年 yangyangyang. All rights reserved.
//
#define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)


#define kkkk 0,1,1

#import "LayerBasic.h"

#import <GLKit/GLKit.h>  //做向量计算

#import "Mybtn.h"
@interface LayerBasic ()<CALayerDelegate>{
    NSInteger clickNum;
    CGPoint gestureStartPoint;
    BOOL isfrist;
    CGFloat x;
    CGFloat y;
    CATransform3D transformcube;
    NSMutableArray *cubeSbuViewArr;
}
@property (nonatomic, strong) UIView *baView;
@property (nonatomic, strong) UIView *baView2;
@end

@implementation LayerBasic

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //cube
    transformcube = CATransform3DIdentity;
    isfrist = YES;
    x= 0;
    y=0;
    cubeSbuViewArr = [NSMutableArray array];
    
    // main
    self.baView = [[UIView alloc]initWithFrame:CGRectMake(110, 110, 200, 200)];

    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    self.baView.layer.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0].CGColor;
    self.baView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    [self.view addSubview:self.baView];
    [self CALayerBuildCube];  // 立方体
   
}
#pragma mark -- lazy
- (UIView *)baView2{
    if (!_baView2) {
        _baView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 200, 200)];
        self.baView2.backgroundColor = [UIColor clearColor];
        //        self.baView2.center = self.view.center;
        self.baView2.layer.contentsGravity = kCAGravityResizeAspect;
        self.baView2.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"jieyi"].CGImage);
    }
    return _baView2;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.5 animations:^{
        clickNum--;
        clickNum = clickNum ? 1 : 0;
        //    [self layerContentsScale];  //contentsRect 拼合图片
        //    [self layerAddimageContentsRect];
        
        //    [self CALayerShouldRasterize];   //  组透明   好像没什么卵用
        
        
        //    [self CALayerClickShadowAndContent];  //masktobounds阴影裁剪
        //    [self CALayerClickShadowPath]; // cgpath  画矩形背景阴影
        //    [self CALayerMaskShadow];  //蒙版图层   有意思
        
        
        
        //    [self CALayerCGAffineTransform];   //仿射变换   2D 的旋转平移缩放
        
//        [self CALayerCATransform3D];    // 3D 基础变换  平移旋转缩放
//        [self CALayerCATransform3DSublayerTransform];  // SublayerTransform
//        [self CALayerCATransform3DDoubleSided];  // DoubleSided  是否绘制背面，获取镜像图片
//        [self CALayerBuildCube];  // 立方体
        
        
    }];

//    #pragma mark -- 固体对象
        UITouch *touch = [touches anyObject];
        gestureStartPoint = [touch locationInView:self.view];//开始触摸
//    #pragma mark -- 固体对象
}





#pragma mark -- 固体对象
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    transformcube = CATransform3DIdentity;
    transformcube.m34 = -1.0/500;
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    CGFloat x1 = point.x - gestureStartPoint.x + x;
    CGFloat y1 = point.y - gestureStartPoint.y + y;
    
    transformcube = CATransform3DRotate(transformcube, -M_PI/180.0 * x1, 0, 1, 0);
    transformcube = CATransform3DRotate(transformcube, -M_PI/180.0 * y1, 1, 0, 0);
    
    self.baView.layer.sublayerTransform  = transformcube;
    self.baView.layer.doubleSided  = NO;

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    isfrist = NO;
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    x = point.x - gestureStartPoint.x;
    y = point.y - gestureStartPoint.y;
}

/*
    6个view 放到一个容器view 然后 给容器view  self.baView.layer.sublayerTransform  设置 transform 值 改变容器view的子控件的显示    其中背面绘制 doubleSided 设置为NO
    根据滚动来改变 旋转 x y

 */
- (void)CALayerBuildCube{
    
    CATransform3D transform1 = CATransform3DMakeTranslation(0, 0, 100);
    [self creatView:1 withTransform:transform1];
    
    transform1 = CATransform3DMakeTranslation(100, 0, 0);
    transform1 = CATransform3DRotate(transform1, M_PI_2, 0, 1, 0);
    [self creatView:2 withTransform:transform1];
    
    transform1 = CATransform3DMakeTranslation(0, -100, 0);
    transform1 = CATransform3DRotate(transform1, M_PI_2, 1, 0, 0);
    [self creatView:3 withTransform:transform1];
    
    transform1 = CATransform3DMakeTranslation(0, 100, 0);
    transform1 = CATransform3DRotate(transform1, -M_PI_2, 1, 0, 0);
    [self creatView:4 withTransform:transform1];
    
    transform1 = CATransform3DMakeTranslation(-100, 0, 0);
    transform1 = CATransform3DRotate(transform1, -M_PI_2, 0, 1, 0);
    [self creatView:5 withTransform:transform1];
    
    transform1 = CATransform3DMakeTranslation(0, 0, -100);
    transform1 = CATransform3DRotate(transform1, M_PI, 0, 1, 0);
    [self creatView:6 withTransform:transform1];
    
    
}
- (void)creatView:(NSInteger)i withTransform:(CATransform3D)transform{
    UIView *view = [[UIView alloc]initWithFrame:self.baView.bounds];
    view.layer.transform = transform;
    view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    [view addSubview:btn];
    [self.baView addSubview:view];
    [btn setBackgroundColor: [UIColor grayColor]];
    [btn setTitleColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"%ld",i] forState:UIControlStateNormal];
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    [cubeSbuViewArr addObject:view];
    // [self addface:i withTransforms:transform];  加阴影并没有什么用处  在设置 GLKVector3 normal 标量的时候 标量出错设置  NAN NAN NAN
}
- (void)addface:(NSInteger)index withTransforms:(CATransform3D )transforms{
    UIView *face = cubeSbuViewArr[index-1];
    [self applyLightToFace:face.layer];
}
- (void)applyLightToFace:(CALayer *)facelayer{
    CALayer *layer = [CALayer layer];
    layer.frame = facelayer.bounds;
    [facelayer addSublayer:layer];
    //GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换
    CATransform3D transform = facelayer.transform;
    GLKMatrix4 kmatrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 kmatrix3 = GLKMatrix4GetMatrix3(kmatrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(kmatrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(0, 1, -0.5));
    float dot = GLKVector3DotProduct(light, normal);
    CGFloat shadow =  1+ (CGFloat)dot -0.5;
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:shadow].CGColor;
    
    
}

#pragma mark -- 3D坐标变换
/*
    Core Graphics 框架实际上是一个严格意义上的2D绘图API，CGAffineTransform仅仅对于2D 绘图有效
 
    Core Animation 的 CATransform3D 类型的 transform 属性可以让图层在3D控件内移动或者旋转
    
    CATransform3D 也是一个矩阵  不过是3维  的 4x4矩阵
 
                [ m11  m21  m31 m41]
    [x,y,z,1] x [ m21  m22  m32 m42] = [x' y' z' 1];
                [ m31  m23  m33 m43]
                [ m41  m24  m34 m44]
 
    点+zPosition    CATransform3D       Transformed Point
 
    // 旋转除了角度  还多出来  xyz   x、y、z 值是  0 或 非0  不在乎值的大小    xyz 同时有值三个方向都会旋转
    CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
 
    CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
 
    CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
 
    上面的旋转  旋转了之后 并不能有一个3d 的效果  因为 还要设置  ↓
    
    透视投影
    “在真实世界中，当物体远离我们的时候，由于视角的原因看起来会变小，理论上说远离我们的视图的边要比靠近视角的边跟短，但实际上并没有发生，而我们当前的视角是等距离的，也就是在3D变换中任然保持平行，和之前提到的仿射变换类似。
 
    在等距投影中，远处的物体和近处的物体保持同样的缩放比例，这种投影也有它自己的用处（例如建筑绘图，颠倒，和伪3D视频），但当前我们并不需要。
 
    为了做一些修正，我们需要引入投影变换（又称作z变换）来对除了旋转之外的变换矩阵做一些修改，Core Animation并没有给我们提供设置透视变换的函数，因此我们需要手动修改矩阵值”
    
    改值 CATransform3D 的 m34 值
 
    m34 默认为0 通过设置 m34 = -1.0/d 来应用透视效果。d 代表想象中的视角相机和屏幕之间的距离，以像素为单位，实际上并不需要计算，大概估算一个就行。因为相机视角实际上并不存在，所以根据屏幕上的显示效果，自由决定它的放置位置，通常  500/1000 就已经很好了。值非常小的时候看起来可能会失真，值非常大的时候看起来基本失去透视效果。
 

 
 
 
 *******  关键点   ******
    transform 添加顺序不同，所得的结果不同。
        先平移。再旋转  那么   就是先平移之后旋转，图片尺寸不变
        先旋转再平移   那么   先旋转 再平移  图层会顺着旋转的角度  进行平移   所得  图层显示会变大
        
 
        CATransform3DTranslate  z 有值，会讲相机视角拉近，显示的图层会变大一些
 
 */
- (void)CALayerCATransform3D{
    
    
    //  x、y、z 值是  0 或 非0  不在乎值的大小    xyz 同时有值三个方向都会旋转
//    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 0.1, 0);
    // 缩放以锚点为基础缩放
//    CATransform3D transform = CATransform3DMakeScale(0.5, 1, 0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500;
//    transform = CATransform3DMakeScale(0.5, 1, 0);
    transform = CATransform3DRotate(transform, M_PI_4, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    
    self.baView.layer.transform = clickNum % 2 ? transform : CATransform3DIdentity;
    
}

/*
    sublayerTransform
    如果有多个视图或者图层，每个都做3D变换，那就需要分别设置相同的m34值，并且确保在变换之前都在屏幕中央共享同一个position，
    CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
    相较而言，通过在一个地方设置透视变换会很方便，同时它会带来另一个显著的优势：灭点被设置在容器图层的中点，从而不需要再对子图层分别设置了。这意味着你可以随意使用position和frame来放置子图层，而不需要把它们放置在屏幕中点，然后为了保证统一的灭点用变换来做平移。
    
 
    灭点啊灭点     图层的锚点，  改变了锚点就是改变了灭点位置
 
    Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外，见第三章）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。
    当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
 
 */
- (void)CALayerCATransform3DSublayerTransform{
      // 灭点是容器图层的锚点 （默认中心）  阿西吧   图片变换的时候。就坑爹了，图层中心Y 和 容器图层中心Y 不等的时候就会出现显示别扭   单纯的做  Y 轴旋转变化的时候   ，同理x 轴一样   如果只做  z 旋转  那就是在 xy 平面旋转  结果与灭点无关。
    [self.view addSubview:self.baView2];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500.0;
    self.view.layer.sublayerTransform = transform;
    
    CATransform3D transform1 = CATransform3DIdentity;
    transform1 = CATransform3DRotate(transform1, -M_PI_4, 1, 0, 0);
//    transform1 = CATransform3DTranslate(transform1, 0, 0, 85);
    self.baView.layer.transform = transform1;
    
    CATransform3D transform2 = CATransform3DIdentity;
//    transform2 = CATransform3DTranslate(transform2,0.5, 0.5, 1);
    transform2 = CATransform3DRotate(transform2, M_PI_4, 0, 1, 1);
    self.baView2.layer.transform = transform2;
    
}
/*
 
     背部是否绘制。 CALayer 的 doubleSided 属性 默认是  YES  此时如果要获取左右对称图像  绕Y 旋转180°  获取上下对称图像，绕X 旋转180°。  改成NO  那么就不会被绘制
 
 */
- (void)CALayerCATransform3DDoubleSided{
//    self.baView.layer.doubleSided = NO;  // 默认yes  改成NO了背面不绘制，那么，就不显示
    self.baView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
}



#pragma mark -- 2D坐标变换
/*
    仿射变换
        2D
            一个坐标（CGPoint）  乘以 CGAffineTransform矩阵  得到新的点的坐标 （CGPoint）
                CGAffineTransform 2x3  CGPoint 1x2，那么在乘法的时候添加一个标志值（3x3，1x3），不影响计算结果
                      [ a  b  0]
            [x,y,1] x [ c  d  0] = [x1 y1 1];
                      [ Tx Ty 1]
            
            CGAffineTransform 可以点出来 a,b,c,d, 来直接修改旋转，不通过CG 提供的封装方法。
                struct CGAffineTransform {
                                            CGFloat a, b, c, d;
                                            CGFloat tx, ty;
                                          };
 
    当对图层应用变换矩阵，图层矩形内的每一个点都被相应地做变换，从而形成一个新的四边形的形状。CGAffineTransform中的“仿射”的意思是无论变换矩阵用什么值，图层中平行的两条线在变换之后任然保持平行，CGAffineTransform可以做出任意符合上述标注的变换
            变化后  eg: 矩形的平行的边还是平行
 
    CGAffineTransform:
        CGAffineTransformMakeRotation(CGFloat angle)                旋转
        CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)          缩放
        CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)    平移
    
    UIView可以通过设置transform属性做变换，但实际上它只是封装了内部图层的变换。
    CALayer对应于UIView的transform属性叫做affineTransform ( affine 仿射 )

    CALayer同样也有一个transform属性，但它的类型是CATransform3D，而不是CGAffineTransform
 
    
 
    混合变换
 
        1.生成CGAffineTransform 空值 - 单位矩阵 Core Graphics 提供 常量CGAffineTransformIdentity
 
        2.创建复合变换   见代码
 
            如果混合两个已经存在的变换矩阵， 可以通过方法算新矩阵
            CGAffineTransformConcat(CGAffineTransform t1, CGAffineTransform t2)
    
    平移的时候，以中心点为锚点移动，
    平移+缩放/旋转，平移后再缩放/旋转，
    缩放+平移  缩放后平移，此时平移量 * 缩放比例。
    旋转+平移  旋转后平移，此时平移会沿着旋转的角度移动，移动的量不变
 
    注意：
    比如 图片向右边发生了平移，但并没有指定距离那么远（200像素），另外它还有点向下发生了平移。原因在于当你按顺序做了变换，上一个变换的结果将会影响之后的变换，所以200像素的向右平移同样也被旋转了30度，缩小了50%，所以它实际上是斜向移动了100像素。
 
    ** 这意味着变换的顺序会影响最终的结果 ** ，也就是说旋转之后的平移和平移之后的旋转结果可能不同。

 */

- (void)CALayerCGAffineTransform{
    self.baView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    

    [self.view addSubview:self.baView2];
    //给100 宽度的标尺
    for (int i = 0; i < 5; i++)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100 *i, 100, 100, 10)];
        view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        [self.view addSubview:view];
    }
    
    
    [self.view sendSubviewToBack:self.baView2];
    
    self.baView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    // 组合变换     依次添加到  CGAffineTransform 对象实例中  然后放一个动画变化就行了
    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, 0.75, 0.5);
    transform = CGAffineTransformRotate(transform, M_PI_4);
    transform = CGAffineTransformTranslate(transform, 200, 0);
    [UIView animateWithDuration:0.5 animations:^{
        self.baView.layer.affineTransform = transform;
    }];
    
}


#pragma mark -- 阴影
/*
    阴影从 mac 上演变过来，  因为mac 的Y轴与 iOS 上Y轴是颠倒的， mac 默认阴影向下， 就导致了默认阴影是在iOS是默认向上
    shadowOpacity  透明度  0-1.0  0透明  1不透明
    shadowColor    阴影色   默认灰黑就行了
    shadowOffset   默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移
    shadowRadius   值越大，阴影效果越平滑，越小，就越明显
 
    阴影裁剪    阴影在layer之外   那么还有内容需要裁剪的时候，设置masksToBounds会不显示阴影和layer之外的内容，不是想要的，此时，使用2个图层，一个是阴影图层一个是内容图层，那么，完成显示
 
 */
- (void)CALayerClickShadowAndContent{
    // 2个view
    self.baView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    self.baView.layer.shadowColor = [UIColor redColor].CGColor;
    self.baView.layer.shadowOffset = CGSizeMake(5, 10);
    self.baView.layer.shadowRadius = 10;
    self.baView.layer.shadowOpacity = 0.5;
    self.baView.layer.masksToBounds = YES;
    
    
    self.baView2.layer.shadowColor = [UIColor blueColor].CGColor;
    self.baView2.layer.shadowOffset = CGSizeMake(5, 10);
    self.baView2.layer.shadowRadius = 10;
    self.baView2.layer.shadowOpacity = 0.5;
}

/*
    图形阴影  shadowPath
            使用CGPath曲线或者UIBezierPath 曲线来画
 */
- (void)CALayerClickShadowPath{
    self.baView.backgroundColor = [UIColor clearColor];
    self.baView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    self.baView.layer.shadowOpacity = 0.5f;
    
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, self.baView.bounds);
//    self.baView.layer.shadowPath = squarePath;
//    CGPathRelease(squarePath);
    
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, self.baView.bounds);
    self.baView.layer.shadowPath = circlePath;
    CGPathRelease(circlePath);
}

/*
    图层蒙版
        mask 属性可以像饼干切割机一样， mask 实心图层会被留下来，
        mask 本身就是一个CALayer类型，有和其他图层一样的绘制和布局属性，它类似一个子图层，相对于父图层布局又不是一个普通的子图层，mask图层定义了父图层哪个部分可以显示
        mask 不仅可以是静态图层，任何有图层构成的都能作为mask 属性  这意味着蒙版可以通过代码动画生成
 */
- (void)CALayerMaskShadow{
    CALayer *masklayer = [CALayer layer];
    masklayer.frame = self.baView.bounds;
    masklayer.contentsGravity = kCAGravityResizeAspect;
    masklayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"jieyi"].CGImage);
    self.baView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lingnai"].CGImage);
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    self.baView.layer.mask = masklayer;
}


#pragma mark -- 图层添加图片
/*
 contents   id 类型，赋值为任意类型都可以，但是，如果不是CGImage，显示会是空白。
    奇怪的原因：
        “是由Mac OS的历史原因造成的。它之所以被定义为id类型，是因为在Mac OS系统上，这个属性对CGImage和NSImage类型的值都起作用。如果你试图在iOS平台上将UIImage的值赋给它，只能得到一个空白的图层。一些初识Core Animation的iOS开发者可能会对这个感到困惑。”
 
    实际上，需要赋值的类型是CGImageRef——一个指向CGImage的指针，UIImage有一个CGImage，返回的是CGImageRef指针。但是，直接给contents会报错，CGImageRef不是一个真正的Cocoa对象，而是一个Core Foundation类型，两个在运行时很像，但是并不兼容，可以用桥接 (__bridge id),不用ARC可以不用转换。
 
 
 */
- (void)layerContents{
    UIImage *image = [UIImage imageNamed:@"lingnai"];
    
    self.baView.layer.contents  =  (__bridge id)image.CGImage;
}

/*
 contentsGravity 加载图片时，图片宽高比和view宽高比不同时，会拉伸压缩，此时设置contentsGravity来适应
 在使用UIImageView时，也会出现图片拉伸的情况，通过contentMode 属性设置成UIViewContentModeScaleAspectFit解决，
    contentMode，contentsGravity 两者均是，决定内容在图层的边界中怎么对齐。
    contentMode 对应 枚举
    contentsGravity 对应 NSString 类型，
    kCAGravityResizeAspect 等效于 UIViewContentModeScaleAspectFit  等比例拉伸图片
 */
- (void)layerContentsGravity{
    UIImage *image = [UIImage imageNamed:@"lingnai"];
    
    self.baView.layer.contents  =  (__bridge id)image.CGImage;
    
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
}

/*
 masksToBounds 是否显示超出边界的内容
 clipsToBounds UIView 的是否显示超出便捷的内容

 contentsScale 属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数。
 
 contentsScale属性其实属于支持高分辨率（又称Hi-DPI或Retina）屏幕机制的一部分。它用来判断在绘制图层的时候应该为寄宿图创建的空间大小，和需要显示的图片的拉伸度（假设并没有设置contentsGravity属性）。UIView有一个类似功能但是非常少用到的contentScaleFactor属性。
     如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕。
 
 contentsScale在contents设置了contentsGravity属性时，图片它已经被拉伸以适应图层的边界，所以contentsScale并不会起效果。
 
    把contentsGravity设置为kCAGravityCenter（这个值并不会拉伸图片），使用UIImage类去读取的时候，图片可能很大，因为读取到的是retina版本的图片，但是当使用CGImage来设置图层内容的时候，拉伸因素在转换的时候丢失了，此时可以通过手动设置 contentsScale = [UIScreen mainScreen].scale 来解决。
 
 */
- (void)layerContentsScale{
    UIImage *image = [UIImage imageNamed:@"lingnai"];
    self.baView.layer.contents  =  (__bridge id)image.CGImage;
    self.baView.layer.contentsGravity = kCAGravityCenter;   // 不会缩放图片
    self.baView.layer.contentsScale = [UIScreen mainScreen].scale;
    self.baView.layer.masksToBounds = YES;
}

/*
 contentsRect  显示寄宿图的一个子域，单位是单位坐标，值范围0-1（frame/bounds,使用点做单位），默认的contentsRect = {0,0,1,1}，默认整个寄宿图可见，可以修改contentsRect，原点可以不在{0,0}，大小也可以大于{1,1}，但是最边缘的像素会被拉伸以填充剩下的区域。同时，图像会缩放，比如宽度为2，那么图片会相应快高缩小到一半。

    “点 —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一致的视觉效果。”
 
    “像素 —— 物理像素坐标并不会用来屏幕布局，但是仍然与图片有相对关系。UIImage是一个屏幕分辨率解决方案，所以指定点来度量大小。但是一些底层的图片表示如CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，他们表现出来了不同的大小。”
 
    “单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式， 当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标。”
 
 */
- (void)layerContentsRect{
    UIImage *image = [UIImage imageNamed:@"lingnai"];
    
    self.baView.layer.contents  =  (__bridge id)image.CGImage;
    
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    
//    self.baView.layer.contentsScale = [UIScreen mainScreen].scale;
    
//    self.baView.layer.contentsRect = CGRectMake(-0.5, 0, 1, 1);
    self.baView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
}

/*
contentsRect 拼合图片
    将一张大图的各个部分 根据rect拿出来 载入到不同的独立图层中去   
    
    用处 载入一张所有用到的图，分割不同块儿来加载在不同的地方
    并没有什么卵用  暂时
 */

- (void)layerAddimageContentsRect{
    UIImage *image = [UIImage imageNamed:@"lingnai"];
    [self addLayerImage:image contentsRect:CGRectMake(0, 0, 0.2, 0.2)];
//    [self addLayerImage:image contentsRect:CGRectMake(0, 0.5, 0.2, 0.2)];
//    [self addLayerImage:image contentsRect:CGRectMake(0.5, 0, 0.2, 0.3)];
//    [self addLayerImage:image contentsRect:CGRectMake(0.5, 0.5, 0.3, 0.3)];
    
}
- (void)addLayerImage:(UIImage *)image contentsRect:(CGRect)rect{
    self.baView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    self.baView.layer.contentsGravity = kCAGravityResizeAspect;
    self.baView.layer.contentsRect = rect;
}


/*
 -drawRect:
 
    给contents 设置CGImage 并不是唯一添加寄宿图的方式，还有drawRect: 方法
 
    方法:  不是默认实现的，因为对一个图层来说，并不是一定要有寄宿图， 如果-drawRect:被调用 那么就会给UIView添加一个寄宿图，像素大小是UIView * contentsScale 
 当视图在屏幕上出现时，-drawRect: 被自动调用.方法里面的代码利用Core Graphics绘制一个寄宿图，然后缓存起来，直到它需要被更新的时候（通常是开发者调用 -setNeedsDisplay 方法，尽管影响到表现效果的属性值被更改时，一些视图类型会被自动重绘，如bounds属性）。 - drawRect: 是一个UIView方法，实际上都是底层的CALayer安排重绘工作和保存产生的图片
    
    代理: 实现了CALayerDelegate 协议，在CALayer需要一个内容特定的信息时，就会从协议中请求
    
    代理过程: 当需要被重绘时，CALayer会请求它的代理给他一个寄宿图，调用- (void)displayLayer:(CALayerCALayer *)layer;方法。此时，可以直接设置contents 属性，除了这个方法没有其他可以直接设置了。
            如果没有实现上一步代理方法，那么CALayer会转而尝试调用- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;方法，在这个方法之前，CALayer创建空的寄宿图和一个Core Graphics创建的上下文（作为参数传入）。
    注意: 
        1.我们在blueLayer上显式地调用了-display。不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者。
        2.在绘制过程中，超出视图边界的部分不会绘制，因为，并没有对超出边界的寄宿图做支持
        3.在不需要创建一个图层的时候，基本用不到这个代理
        4.在UIView创建宿主图层时，它自动将图层的代理设置为自己，并提供了 -displayLayer 的实现。
    实际上在- drawRect: 方法调用的时候，UIView会帮着完成剩下的工作，包括在需要重绘时调用的 - displayLayer方法
 
 */



/*
    对UIView来讲：
    frame = (10,10,40,50)
    bounds = (0,0,40,50)
    center = (30,35) 
 
    对于CALayer
    frame = (10,10,40,50)
    bounds = (0,0,40,50)
    position = (30,35)
        视图的frame、bounds、center属性仅仅是存取方法。操作视图的frame实际上是改变视图的layer的frame，不能独立图层之外改变视图的frame
    frame 实际上是根据 bounds、position、transform 来算出来的。当然，改变frame 也会改变bounds等属性
    
    # 在图层做变换的时候，比如旋转或者缩放，实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域，也就是，frame和bounds 的宽高可能不一致
        ## bounds的宽高是图层的长宽   frame是图层旋转之后，对应的 正 的矩形区域，（图层可能是斜着的）
 
    锚点
        self.view.layer.anchorPoint = CGPointMake(0.5f, 0.9f);   0-1 的区间  默认 （0.5，0.5） 中间
 
 */


/*
    组透明
        当你显示一个50%透明度的图层时，图层的每个像素都会一半显示自己的颜色，另一半显示图层下面的颜色。这是正常的透明度的表现。但是如果图层包含一个同样显示50%透明的子图层时，你所看到的视图，50%来自子视图，25%来了图层本身的颜色，另外的25%则来自背景色。
 
 ios6之前会显示不一样    在ios10   没有书中的效果
 */

- (void)CALayerShouldRasterize{
    //自定义btn   btn上加label
    Mybtn *btn = [[Mybtn alloc]init];
    btn.frame = CGRectMake(100, 100, 100, 50);
    
    [self.baView addSubview:btn];
    btn.alpha = 0.5;
    
    [btn setBackgroundColor:[UIColor whiteColor]];
}




@end
