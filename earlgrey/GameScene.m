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



// ゲームのステータス
@interface GameScene()
@end


@implementation GameScene {
    
    SKTexture *_texture1jpy;
    SKTexture *_texture5jpy;
    SKTexture *_texture10jpy;
    SKTexture *_texture50jpy;
    SKTexture *_texture100jpy;
    SKTexture *_texture500jpy;
    SKLabelNode *scoreNode;
    SKLabelNode *timerLabel;
    CGFloat radius1jpy;
    CGFloat radius5jpy;
    CGFloat radius10jpy;
    CGFloat radius50jpy;
    CGFloat radius100jpy;
    CGFloat radius500jpy;
    
    GameState _gameState;
    NSTimeInterval _startedTime;
    
    SKAction *coinremove;
}

-(void)didMoveToView:(SKView *)view {
    
    radius1jpy = 30;
    radius5jpy = 31;
    radius10jpy = 31.75;
    radius50jpy = 30.5;
    radius100jpy = 31.3;
    radius500jpy = 33.25;
    self.backgroundColor = [SKColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1];
    self.physicsWorld.gravity = CGVectorMake(0, 0);

    //硬貨の生成
    SKAction *make1JPY = [SKAction sequence: @[
                                               [SKAction performSelector:@selector(add1JPY) onTarget:self],
                                               [SKAction waitForDuration:1.5 withRange:3.0]]];
    [self runAction: [SKAction repeatActionForever:make1JPY]];
    SKAction *make5JPY = [SKAction sequence: @[
                                               [SKAction performSelector:@selector(add5JPY) onTarget:self],
                                               [SKAction waitForDuration:1.75 withRange:3.5]]];
    [self runAction: [SKAction repeatActionForever:make5JPY]];
    SKAction *make10JPY = [SKAction sequence: @[
                                               [SKAction performSelector:@selector(add10JPY) onTarget:self],
                                               [SKAction waitForDuration:2.0 withRange:4.0]]];
    [self runAction: [SKAction repeatActionForever:make10JPY]];
    SKAction *make50JPY = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(add50JPY) onTarget:self],
                                                [SKAction waitForDuration:2.25 withRange:4.5]]];
    [self runAction: [SKAction repeatActionForever:make50JPY]];
    SKAction *make100JPY = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(add100JPY) onTarget:self],
                                                [SKAction waitForDuration:2.5 withRange:5.0]]];
    [self runAction: [SKAction repeatActionForever:make100JPY]];
    SKAction *make500JPY = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(add500JPY) onTarget:self],
                                                [SKAction waitForDuration:2.75 withRange:5.5]]];
    [self runAction: [SKAction repeatActionForever:make500JPY]];
    
    //スコアタイトル
    int margin = 10;
    SKLabelNode *scoreTitleNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreTitleNode.fontSize = 30;
    scoreTitleNode.text = @"お年玉";
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
    
    //Timer
    timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    timerLabel.text = @"残り時間: 0";
    timerLabel.fontColor = [UIColor whiteColor];
    timerLabel.fontSize = 24.0f;
    timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timerLabel.position = CGPointMake(10,10);
    
    [self addChild:timerLabel];
    
    
    //texture設定
    _texture1jpy = [SKTexture textureWithImageNamed:@"1jpy.png"];
    _texture5jpy = [SKTexture textureWithImageNamed:@"5jpy.png"];
    _texture10jpy = [SKTexture textureWithImageNamed:@"10jpy.png"];
    _texture50jpy = [SKTexture textureWithImageNamed:@"50jpy.png"];
    _texture100jpy = [SKTexture textureWithImageNamed:@"100jpy.png"];
    _texture500jpy = [SKTexture textureWithImageNamed:@"500jpy.png"];
    
    //coinremove
    coinremove = [SKAction sequence: @[
                                        [SKAction moveBy:CGVectorMake(0, 50) duration:0.15],
                                        [SKAction moveBy:CGVectorMake(0, -50) duration:0.15],
                                        [SKAction fadeOutWithDuration:0.5],
                                        [SKAction removeFromParent]
                                        ]];
    
   
}


// タッチ
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
   
        SKNode *node = [self nodeAtPoint:location];
        
        if (node != nil && [node.name isEqualToString:k1JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 1;
        }
        if (node != nil && [node.name isEqualToString:k5JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 5;
        }
        if (node != nil && [node.name isEqualToString:k10JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 10;
        }
        if (node != nil && [node.name isEqualToString:k50JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 50;
        }
        if (node != nil && [node.name isEqualToString:k100JPYName]) {
            if(_gameState == STOPPED) {            // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 100;
        }
        if (node != nil && [node.name isEqualToString:k500JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinremove];
            self.score += 500;
        }
    }
}


static inline CGFloat skRand(CGFloat low,CGFloat high) {
    return skRandf() *(high - low) + low;
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}


- (void)add1JPY {
    SKSpriteNode *jpy1 = [SKSpriteNode spriteNodeWithTexture:_texture1jpy];
    jpy1.name = k1JPYName;
    jpy1.size = CGSizeMake(radius1jpy * 2, radius1jpy * 2);
    
    
   
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(0,self.frame.size.width),
                                   self.frame.size.height);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius1jpy,
                                   skRand(-radius1jpy, self.size.height + radius1jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius1jpy, self.size.width + radius1jpy),
                                   -radius1jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius1jpy,
                                   skRand(-radius1jpy, self.size.height + radius1jpy));
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
    [self enumerateChildNodesWithName:k1JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius1jpy || node.position.y > self.size.height + radius1jpy ||
            node.position.x < -radius1jpy || node.position.x > self.size.width + radius1jpy) {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:k5JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius5jpy || node.position.y > self.size.height + radius5jpy ||
            node.position.x < -radius5jpy || node.position.x > self.size.width + radius5jpy) {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:k10JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius10jpy || node.position.y > self.size.height + radius10jpy ||
            node.position.x < -radius10jpy || node.position.x > self.size.width + radius10jpy) {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:k50JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius50jpy || node.position.y > self.size.height + radius50jpy ||
            node.position.x < -radius50jpy || node.position.x > self.size.width + radius50jpy) {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:k100JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius100jpy || node.position.y > self.size.height + radius100jpy ||
            node.position.x < -radius100jpy || node.position.x > self.size.width + radius100jpy) {
            [node removeFromParent];
        }
    }];
    [self enumerateChildNodesWithName:k500JPYName usingBlock:^(SKNode *node,BOOL *stop) {
        if (node.position.y < -radius500jpy || node.position.y > self.size.height + radius500jpy ||
            node.position.x < -radius500jpy || node.position.x > self.size.width + radius500jpy) {
            [node removeFromParent];
        }
    }];
    
}


//スコア更新
-(void)setScore:(int)score
{
    _score = score;
    //ラベル更新
    SKLabelNode *scoreNode;
    scoreNode = (SKLabelNode *)[self childNodeWithName:kScoreName];
    scoreNode.text = [NSString stringWithFormat:@"%d", _score];
}


@end
