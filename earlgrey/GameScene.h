//
//  GameScene.h
//  earlgrey
//

//  Copyright (c) 2014 SO14. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define k1JPYName @"1JPY"
#define k5JPYName @"5JPY"
#define k10JPYName @"10JPY"
#define k50JPYName @"50JPY"
#define k100JPYName @"100JPY"
#define k500JPYName @"500JPY"
#define kScoreName @"score"

static const uint32_t jpyCategory = 0x1 << 0;

@interface GameScene : SKScene

@property (assign, nonatomic)int score;		//スコア

@end
