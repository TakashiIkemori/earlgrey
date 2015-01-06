//
//  GameScene.h
//  earlgrey
//

//  Copyright (c) 2014 SO14. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kCircleName @"circle"
#define kScoreName @"score"

static const uint32_t circleCategory = 0x1 << 0;

@interface GameScene : SKScene

@property (assign, nonatomic)int score;		//スコア

@end
