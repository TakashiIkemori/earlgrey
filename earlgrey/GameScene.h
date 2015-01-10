//
//  GameScene.h
//  earlgrey
//

//  Copyright (c) 2014 SO14. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h> //音を鳴らす為に必要(コメント確認後削除よろしく

#define k1JPYName @"1JPY"
#define k5JPYName @"5JPY"
#define k10JPYName @"10JPY"
#define k50JPYName @"50JPY"
#define k100JPYName @"100JPY"
#define k500JPYName @"500JPY"
#define kScoreName @"score"


static const uint32_t jpyCategory = 0x1 << 0;

@interface GameScene : SKScene

typedef enum {
    STOPPED,    // 止まっている
    STARTING,   // 始まる
    PLAYING,    // 遊んでいる
}GameState;

@property (assign, nonatomic)int score;		//スコア
@property (assign, nonatomic)int time;      //タイム

@property AVAudioPlayer *bgm;

@end
