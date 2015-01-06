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
    SKSpriteNode *player;
    SKLabelNode *myLabel;
}


//-(id)initWithSize:(CGSize)size{
//    if(self = [super initWithSize:size]){
//        self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        myLabel.text = @"Hello,World";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
//        
//        [self addChild:myLabel];
//        
//        _texture = [SKTexture textureWithImage:@"shit.png"];
//    }
//    return self;
//}





//
-(void) setUpPlayer{
    player = [SKSpriteNode spriteNodeWithImageNamed:@"shit"];
    player.size = CGSizeMake(25, 25);
    player.position = CGPointMake(self.size.width / 2, self.size.height /2);
//    player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:0.5];
    //player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
//    player.physicsBody.contactTestBitMask = 0x1<<0;
    player.physicsBody.dynamic = NO;
    player.name = @"player";
    [self addChild:player];
}




//画像の生成
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
      SKSpriteNode *sprite1 = [SKSpriteNode spriteNodeWithImageNamed:@"shit"];
    sprite1.xScale = 0.5;
    sprite1.yScale = 0.5;
    sprite1.position = CGPointMake(self.size.width / 2 +50,
                                   self.size.height /2 - 100);
    sprite1.name = @"shit";
    SKSpriteNode *sprite2 = [SKSpriteNode spriteNodeWithImageNamed:@"shit"];
    sprite2.xScale = 0.3;
    sprite2.yScale = 0.3;
    sprite2.position = CGPointMake(self.size.width / 2 - 50,
                                   self.size.height /2 + 100);
    sprite2.name = @"shit";

    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"スコア";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(self.size.width /2 - 200,
                                   self.size.height /2 + 350);
    //スコア
    SKLabelNode *scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Baskerville-Bold"];
    scoreNode.name = kScoreName;
    scoreNode.fontSize = 20;
    self.score = 0;
    [self addChild:scoreNode];
    scoreNode.position = CGPointMake(self.size.width / 2, self.size.height / 2 + 350);
    [self addChild:sprite2];
    [self addChild:sprite1];
    [self addChild:myLabel];
//    NSLog(@"Hello SO14!!");
}


// タッチ
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:_texture];
        sprite.position = location;
        [self addChild:sprite];


        SKNode *node = [self nodeAtPoint:location];
        if(node != nil && [node.name isEqualToString:@"shit"]) {
            [node removeFromParent];
            self.score += 10;
            break;
        }
    }

}



//スコア更新
-(void)setScore:(int)score
{
    _score = score;
    //ラベル更新
    SKLabelNode* scoreNode;
    scoreNode = (SKLabelNode*)[self childNodeWithName:kScoreName];
    scoreNode.text = [NSString stringWithFormat:@"%d", _score];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
