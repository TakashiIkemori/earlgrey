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

@implementation GameScene {
    SKLabelNode *scoreNode;
    CGFloat radius;
}

-(void)didMoveToView:(SKView *)view {
    
    radius = 25;
    self.backgroundColor = [SKColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1];
    self.physicsWorld.gravity = CGVectorMake(0, 0);

    SKAction *makeCircles = [SKAction sequence: @[
                                                  [SKAction performSelector:@selector(addCircle) onTarget:self],
                                                  [SKAction waitForDuration:1.5 withRange:3.0]]];
    [self runAction: [SKAction repeatActionForever:makeCircles]];
    
    //スコアタイトル
    int margin = 10;
    SKLabelNode *scoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreTitleNode.fontSize = 30;
    scoreTitleNode.text = @"SCORE";
    [self addChild:scoreTitleNode];
    CGSize scoreTitleNodeSize = scoreTitleNode.frame.size;
    scoreTitleNode.position = CGPointMake(margin + (scoreTitleNodeSize.width / 2),
                                          self.size.height - margin - scoreTitleNodeSize.height);
    //スコア点数
    scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreNode.name = kScoreName;
    scoreNode.fontSize = 30;
    [self addChild:scoreNode];
    self.score = 0;
    scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreNode.position = CGPointMake(margin + scoreTitleNodeSize.width + margin + scoreNode.frame.size.width / 2,
                                     self.size.height - margin - scoreTitleNodeSize.height);
   
}


// タッチ
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
   
        SKNode *node = [self nodeAtPoint:location];
        
        if (node != nil && [node.name isEqualToString:kCircleName]) {
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
    circle.Path = CGPathCreateWithEllipseInRect(CGRectMake(-radius, -radius, radius * 2, radius * 2), nil);
    circle.fillColor = [SKColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
    circle.lineWidth = 0;
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius, self.size.width + radius),
                                   self.size.height + radius);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius,
                                   skRand(-radius, self.size.height + radius));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius, self.size.width + radius),
                                   -radius);
            break;
        case 3: // 左
            position = CGPointMake(-radius,
                                   skRand(-radius, self.size.height + radius));
            break;
    }
    circle.position = position;
    
    [self addChild:circle];
    circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.frame.size.width / 2];
    circle.physicsBody.categoryBitMask = circleCategory;
    circle.physicsBody.contactTestBitMask = 0;
    circle.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - circle.position.x,
                              target.y - circle.position.y));
    circle.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    circle.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:kCircleName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius || node.position.y > self.size.height + radius ||
            node.position.x < -radius || node.position.x > self.size.width + radius) {
            [node removeFromParent];
        }
    }];
}

//スコア更新
-(void)setScore:(int)score
{
    _score = score;
    //ラベル更新
    scoreNode.text = [NSString stringWithFormat:@"%d", _score];
}


@end
