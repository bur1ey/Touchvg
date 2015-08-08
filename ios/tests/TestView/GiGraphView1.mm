//! \file GiGraphView1.mm
//! \brief 实现iOS绘图视图类 GiGraphView1
// Copyright (c) 2012-2013, https://github.com/rhcad/touchvg

#import "GiGraphView1.h"
#import "GiViewHelper.h"
#import <QuartzCore/QuartzCore.h>
#include "GiCanvasAdapter.h"
#include "gicoreview.h"

//! 动态图形的绘图视图类
@interface IosTempView1 : UIView {
    ViewAdapter1    *_adapter;
}

- (id)initWithFrame:(CGRect)frame :(ViewAdapter1 *)viewAdapter;

@end

//! 绘图视图适配器
class ViewAdapter1 : public GiView
{
private:
    UIView      *_view;
    UIView      *_dynview;
    GiCoreView  *_coreView;
    UIImage     *_tmpshot;
    int         _sid;
    
public:
    ViewAdapter1(UIView *mainView) : _view(mainView), _dynview(nil), _tmpshot(nil) {
        _coreView = GiCoreView::createView(this, 0);
    }
    
    virtual ~ViewAdapter1() {
        if (_coreView) {
            _coreView->release();
            _coreView = NULL;
        }
    }
    
    GiCoreView *coreView() {
        return _coreView;
    }
    
    UIView *getDynView() {
        return _dynview;
    }
    
    UIImage *snapshot() {
        UIGraphicsBeginImageContextWithOptions(_view.bounds.size, _view.opaque, 0);
        [_view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    bool drawAppend(GiCanvasAdapter* canvas) {
        bool ret = false;
        
        if (_tmpshot) {
            [_tmpshot drawAtPoint:CGPointZero];
            _tmpshot = nil;
            ret = _coreView->drawAppend(this, canvas, _sid);
        }
        return ret;
    }
    
    virtual void regenAll(bool changed) {
        if (changed) {
            _sid = 0;
            _coreView->submitBackDoc(this);
        }
        _coreView->submitDynamicShapes(this);
        [_view setNeedsDisplay];
        [_dynview setNeedsDisplay];
    }
    
    virtual void regenAppend(int sid) {
        _sid = sid;
        _coreView->submitBackDoc(this);
        _coreView->submitDynamicShapes(this);
        _tmpshot = nil;                 // renderInContext可能会调用drawRect
        _tmpshot = snapshot();
        
        [_view setNeedsDisplay];
        [_dynview setNeedsDisplay];
    }
    
    virtual void redraw(bool changed) {
        _coreView->submitDynamicShapes(this);
        if (!_dynview && _view) {       // 自动创建动态图形视图
            _dynview = [[IosTempView1 alloc]initWithFrame:_view.frame :this];
            _dynview.autoresizingMask = _view.autoresizingMask;
            [_view.superview addSubview:_dynview];
        }
        [_dynview setNeedsDisplay];
    }
};

@implementation IosTempView1

- (id)initWithFrame:(CGRect)frame :(ViewAdapter1 *)viewAdapter
{
    self = [super initWithFrame:frame];
    if (self) {
        _adapter = viewAdapter;
        self.opaque = NO;                           // 透明背景
        self.userInteractionEnabled = NO;           // 禁止交互，避免影响主视图显示
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    GiCanvasAdapter canvas;
    
    if (canvas.beginPaint(UIGraphicsGetCurrentContext())) {
        _adapter->coreView()->dynDraw(_adapter, &canvas);
        canvas.endPaint();
    }
}

@end

@implementation GiGraphView1

- (void)dealloc
{
    delete _adapter;
    [super DEALLOC];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;                           // 透明背景
        self.autoresizingMask = 0xFF;               // 自动适应大小
        _adapter = new ViewAdapter1(self);
        
        GiCoreView::setScreenDpi(giGetScreenDpi());
        [self coreView]->onSize(_adapter, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    GiCanvasAdapter canvas;
    GiCoreView* coreView = [self coreView];
    
    coreView->onSize(_adapter, self.bounds.size.width, self.bounds.size.height);
    
    if (canvas.beginPaint(context)) {
        if (!_adapter->drawAppend(&canvas)) {
            coreView->drawAll(_adapter, &canvas);
        }
        canvas.endPaint();
    }
}

- (void)removeFromSuperview {
    [_adapter->getDynView() removeFromSuperview];
    [super removeFromSuperview];
}

- (GiCoreView *)coreView
{
    return _adapter->coreView();
}

- (UIImage *)snapshot
{
    return _adapter->snapshot();
}

- (BOOL)exportPNG:(NSString *)filename
{
    BOOL ret = NO;
    UIImage *image = [self snapshot];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    if (imageData) {
        ret = [imageData writeToFile:filename atomically:NO];                 
    }
    
    return ret;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];
    
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureBegan, pt.x, pt.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];
    
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureMoved, pt.x, pt.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:touch.view];
    
    [self coreView]->onGesture(_adapter, kGiGesturePan,
                               kGiGestureEnded, pt.x, pt.y);
}

@end
