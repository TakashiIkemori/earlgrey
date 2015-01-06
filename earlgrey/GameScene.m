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

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0,0);

    SKAction *makeCircles = [SKAction sequence: @[
                                                  [SKAction performSelector:@selector(addCircle) onTarget:self],
                                                  [SKAction waitForDuration:1.5 withRange:1.0]]];
    [self runAction: [SKAction repeatActionForever:makeCircles]];
    
    //スコアタイトル
    SKLabelNode *scoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreTitleNode.fontSize = 30;
    scoreTitleNode.text = @"SCORE";
    [self addChild:scoreTitleNode];
    scoreTitleNode.position = CGPointMake((scoreTitleNode.frame.size.width/2) + 10,self.frame.size.height -30);
    //スコア点数
    SKLabelNode *scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreNode.name = kScoreName;
    scoreNode.fontSize = 30;
    [self addChild:scoreNode];
    self.score = 0;
    scoreNode.position = CGPointMake(self.size.width / 2, self.frame.size.height -30);
   
}


// タッチ
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:_texture];
//        sprite.position = location;
        
        
        SKNode *node = [self nodeAtPoint:location];
        
        if(node != nil && [node.name isEqualToString:kCircleName]) {
            [node removeFromParent];
            self.score += 10;
        } /*else {
            SKNode *node1 = [self nodeAtPoint:location];
            if(node1 != nil && [node1.name isEqualToString:@"purin"]) {
                [node1 removeFromParent];
                self.score -= 10;
                */
                break;
            //}
        //}
    }
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
    circle.physicsBody.categoryBitMask = circleCategory;
    circle.physicsBody.contactTestBitMask = 0;
    circle.physicsBody.collisionBitMask = 0;
    CGPoint location = CGPointMake(skRand(0,self.size.width),skRand(0,self.size.height));
    CGFloat radian = -(atan2f(location.x - circle.position.x,
                                location.y-circle.position.y));
    circle.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    circle.physicsBody.velocity = CGVectorMake(-(400*x), (400*y));
}

- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:kCircleName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < 0 || node.position.y > self.frame.size.height ||
            node.position.x < 0 || node.position.x > self.frame.size.width)
            [node removeFromParent];
    }];
}

//スコア更新
-(void)setScore:(int)score
{
    _score = score;
    //ラベル更新
    SKLabelNode* scoreNode;
    scoreNode = (SKLabelNode *)[self childNodeWithName:kScoreName];
    scoreNode.text = [NSString stringWithFormat:@"%d", _score];
}


@end
