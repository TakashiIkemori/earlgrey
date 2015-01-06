//
//  GameScene.m
//  earlgrey
//
//  Created by Hirofumi Tanigami on 12/10/14.
//  Copyright (c) 2014 SO14. All rights reserved.
//  TakatoshiMasamori  

// RikuSaito
// Hirofumi Tanigami
// Yuta Tamura
// Ajia Suzuki
// Takashi Ikemori
// chagawa yacchan
// mori yuuya


#import "GameScene.h"
SKTexture *_texture;

@implementation GameScene {
    
}
//うんこの生成
-(void) setUpShit{
    shit = [SKSpriteNode spriteNodeWithImageNamed:@"shit"];
    shit.size = CGSizeMake(25, 25);
    shit.position = CGPointMake(self.size.width / 2, self.size.height /2);
    shit.physicsBody.dynamic = NO;
    shit.name = @"shit";
    [self addChild:shit];
}
//プリンの生成
-(void) setUpPurin{
    purin = [SKSpriteNode spriteNodeWithImageNamed:@"purin.jpeg"];
    purin.size = CGSizeMake(25, 25);
    purin.position = CGPointMake(self.size.width / 2, self.size.height /2);
    purin.physicsBody.dynamic = NO;
    purin.name = @"purin";
    [self addChild:purin];
}


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    self.backgroundColor = [SKColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0,0);
    
    SKAction *makeCircles = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addCircle) onTarget:self],
                                                [SKAction waitForDuration:1.5 withRange:1.0]]];
    [self runAction: [SKAction repeatActionForever:makeCircles]];
}


// タッチ
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
   
}

-(void)didSimulatePhysics {
    [self enumerateChildNodesWithName:kCircleName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < 0 || node.position.y > self.frame.size.height ||
            node.position.x < 0 || node.position.x > self.frame.size.width)
            [node removeFromParent];
    }];
}


static inline CGFloat skRand(CGFloat low,CGFloat high) {
    return skRandf() *(high - low) + low;
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}


- (void)addCircle {
    
    SKShapeNode *circle = [SKShapeNode node];
    circle.name = kCircleName;
    circle.Path = CGPathCreateWithEllipseInRect(CGRectMake(-25, -25, 50, 50), nil);
    circle.fillColor = [SKColor redColor];
    circle.strokeColor = 0;
    
    
    CGPoint position;
    
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(0,self.frame.size.width),self.frame.size.height);
            break;
        case 1: // 右
            position = CGPointMake(self.frame.size.width,skRand(0,self.frame.size.height));
            break;
        case 2: // 下
            position = CGPointMake(skRand(0,self.frame.size.width),0);
            break;
        case 3: // 左
            position = CGPointMake(0,skRand(0, self.frame.size.height));
            break;
    }
    
    circle.position = position;
    
    
    [self addChild:circle];
    circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.frame.size.width / 2];
    CGPoint location = CGPointMake(skRand(0,self.size.width),skRand(0,self.size.height));
    CGFloat radian = -(atan2f(location.x - circle.position.x,
                              location.y - circle.position.y));
    circle.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    circle.physicsBody.velocity = CGVectorMake(-(500*x), (500*y));
}

@end
