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
const int TIME_LEVEL = 105.0f; // <----- ここで秒数を設定 現在　105秒。



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
    SKAction *coinSE;
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
    
    //SE
    coinSE = [SKAction playSoundFileNamed:@"coinSE.mp3" waitForCompletion:YES];
    
    //coinremove
    coinremove = [SKAction sequence: @[
                                       [SKAction moveBy:CGVectorMake(0, 100) duration:0.15],
                                       [SKAction fadeOutWithDuration:0.1],
                                       [SKAction removeFromParent]
                                       ]];
    //bgm
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jpBGM" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.bgm = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    [self.bgm play];
    _bgm.numberOfLoops = -1; //ここのコードは音を何回鳴らしますか？という意味。
                             //０より低い数値を設定する事でbgmをループ使用できます。(コメント確認後削除よろしく)
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
            [node runAction:coinSE];
            [node runAction:coinremove];
            self.score += 1;
        }
        if (node != nil && [node.name isEqualToString:k5JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinSE];
            [node runAction:coinremove];
            self.score += 5;
        }
        if (node != nil && [node.name isEqualToString:k10JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinSE];
            [node runAction:coinremove];
            self.score += 10;
        }
        if (node != nil && [node.name isEqualToString:k50JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinSE];
            [node runAction:coinremove];
            self.score += 50;
        }
        if (node != nil && [node.name isEqualToString:k100JPYName]) {
            if(_gameState == STOPPED) {            // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinSE];
            [node runAction:coinremove];
            self.score += 100;
        }
        if (node != nil && [node.name isEqualToString:k500JPYName]) {
            if(_gameState == STOPPED) {         // 1枚目のコインが消えたらスタート
                _gameState = STARTING;
            }
            node.physicsBody.dynamic = NO;
            [node runAction:coinSE];
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
            position = CGPointMake(skRand(-radius1jpy, self.size.width + radius1jpy),
                                   self.size.height + radius1jpy);
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
    jpy1.position = position;
    
    [self addChild:jpy1];
    jpy1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy1.frame.size.width / 2];
    jpy1.physicsBody.categoryBitMask = jpyCategory;
    jpy1.physicsBody.contactTestBitMask = 0;
    jpy1.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy1.position.x,
                              target.y - jpy1.position.y));
    jpy1.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy1.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)add5JPY {
    SKSpriteNode *jpy5 = [SKSpriteNode spriteNodeWithTexture:_texture5jpy];
    jpy5.name = k5JPYName;
    jpy5.size = CGSizeMake(radius5jpy * 2, radius5jpy * 2);
    
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius5jpy, self.size.width + radius5jpy),
                                   self.size.height + radius5jpy);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius5jpy,
                                   skRand(-radius5jpy, self.size.height + radius5jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius5jpy, self.size.width + radius5jpy),
                                   -radius5jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius5jpy,
                                   skRand(-radius5jpy, self.size.height + radius5jpy));
            break;
    }
    jpy5.position = position;
    
    [self addChild:jpy5];
    jpy5.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy5.frame.size.width / 2];
    jpy5.physicsBody.categoryBitMask = jpyCategory;
    jpy5.physicsBody.contactTestBitMask = 0;
    jpy5.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy5.position.x,
                              target.y - jpy5.position.y));
    jpy5.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy5.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)add10JPY {
    SKSpriteNode *jpy10 = [SKSpriteNode spriteNodeWithTexture:_texture10jpy];
    jpy10.name = k10JPYName;
    jpy10.size = CGSizeMake(radius10jpy * 2, radius10jpy * 2);
    
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius10jpy, self.size.width + radius10jpy),
                                   self.size.height + radius10jpy);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius10jpy,
                                   skRand(-radius10jpy, self.size.height + radius10jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius10jpy, self.size.width + radius10jpy),
                                   -radius10jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius10jpy,
                                   skRand(-radius10jpy, self.size.height + radius10jpy));
            break;
    }
    jpy10.position = position;
    
    [self addChild:jpy10];
    jpy10.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy10.frame.size.width / 2];
    jpy10.physicsBody.categoryBitMask = jpyCategory;
    jpy10.physicsBody.contactTestBitMask = 0;
    jpy10.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy10.position.x,
                              target.y - jpy10.position.y));
    jpy10.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy10.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)add50JPY {
    SKSpriteNode *jpy50 = [SKSpriteNode spriteNodeWithTexture:_texture50jpy];
    jpy50.name = k50JPYName;
    jpy50.size = CGSizeMake(radius50jpy * 2, radius50jpy * 2);
    
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius50jpy, self.size.width + radius50jpy),
                                   self.size.height + radius50jpy);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius50jpy,
                                   skRand(-radius50jpy, self.size.height + radius50jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius50jpy, self.size.width + radius50jpy),
                                   -radius50jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius50jpy,
                                   skRand(-radius50jpy, self.size.height + radius50jpy));
            break;
    }
    jpy50.position = position;
    
    [self addChild:jpy50];
    jpy50.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy50.frame.size.width / 2];
    jpy50.physicsBody.categoryBitMask = jpyCategory;
    jpy50.physicsBody.contactTestBitMask = 0;
    jpy50.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy50.position.x,
                              target.y - jpy50.position.y));
    jpy50.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy50.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)add100JPY {
    SKSpriteNode *jpy100 = [SKSpriteNode spriteNodeWithTexture:_texture100jpy];
    jpy100.name = k100JPYName;
    jpy100.size = CGSizeMake(radius100jpy * 2, radius100jpy * 2);
    
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius100jpy, self.size.width + radius100jpy),
                                   self.size.height + radius100jpy);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius100jpy,
                                   skRand(-radius100jpy, self.size.height + radius100jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius100jpy, self.size.width + radius100jpy),
                                   -radius100jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius100jpy,
                                   skRand(-radius100jpy, self.size.height + radius100jpy));
            break;
    }
    jpy100.position = position;
    
    [self addChild:jpy100];
    jpy100.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy100.frame.size.width / 2];
    jpy100.physicsBody.categoryBitMask = jpyCategory;
    jpy100.physicsBody.contactTestBitMask = 0;
    jpy100.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy100.position.x,
                              target.y - jpy100.position.y));
    jpy100.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy100.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
}

- (void)add500JPY {
    SKSpriteNode *jpy500 = [SKSpriteNode spriteNodeWithTexture:_texture500jpy];
    jpy500.name = k500JPYName;
    jpy500.size = CGSizeMake(radius500jpy * 2, radius500jpy * 2);
    
    
    CGPoint position;
    switch (arc4random() % 4) {
        case 0: // 上から出る場合
            position = CGPointMake(skRand(-radius500jpy, self.size.width + radius500jpy),
                                   self.size.height + radius500jpy);
            break;
        case 1: // 右
            position = CGPointMake(self.size.width + radius500jpy,
                                   skRand(-radius500jpy, self.size.height + radius500jpy));
            break;
        case 2: // 下
            position = CGPointMake(skRand(-radius500jpy, self.size.width + radius500jpy),
                                   -radius500jpy);
            break;
        case 3: // 左
            position = CGPointMake(-radius500jpy,
                                   skRand(-radius500jpy, self.size.height + radius500jpy));
            break;
    }
    jpy500.position = position;
    
    [self addChild:jpy500];
    jpy500.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:jpy500.frame.size.width / 2];
    jpy500.physicsBody.categoryBitMask = jpyCategory;
    jpy500.physicsBody.contactTestBitMask = 0;
    jpy500.physicsBody.collisionBitMask = 0;
    CGPoint target = CGPointMake(skRand(0, self.size.width),
                                 skRand(0, self.size.height));
    CGFloat radian = -(atan2f(target.x - jpy500.position.x,
                              target.y - jpy500.position.y));
    jpy500.zRotation = radian;
    CGFloat x = sin(radian);
    CGFloat y = cos(radian);
    jpy500.physicsBody.velocity = CGVectorMake(-(skRand(200, 600) * x), skRand(200, 600) * y);
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
    scoreNode.text = [NSString stringWithFormat:@"%d円", _score];
}

// ゲームオーバー
-(void)gameEnded
{
    _gameState = STOPPED;
    
    NSString *message = [NSString stringWithFormat:@"君のお年玉は%d円", _score];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"タイムアップ！"
                                                 message:message
                                                delegate:nil
                                                cancelButtonTitle:@"もう一度やる"
                                                otherButtonTitles:@"辞めさせない", nil];
    [av show];
    _score = 0;
}

// タイマー
-(void)update:(NSTimeInterval)currentTime {
    if(_gameState == STARTING) {
        _startedTime = currentTime;
        _gameState = PLAYING;
    }
    
    if(_gameState == PLAYING) {
        int timeLeftRounded = ceil(TIME_LEVEL+(_startedTime - currentTime));
        timerLabel.text = [NSString stringWithFormat:@"残り時間: %d", timeLeftRounded];
        
        if(timeLeftRounded == 0) {
            [self gameEnded];
        }
        
    }
}


// タイマー更新
-(void)setTime:(int)time
{
    _time = time;
    //ラベル更新
    timerLabel.text = [NSString stringWithFormat:@"%d残り時間", _time];
}



@end
