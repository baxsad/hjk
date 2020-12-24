//
//  SIMComm.h
//  iosproject
//
//  Created by hlcisy on 2020/8/26.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SIMComm_h
#define SIMComm_h

typedef NS_ENUM(NSInteger, SIMConnState) {
    /**
     * 闲置状态
     */
    SIM_IDLE         = 1,
    
    /**
     * 连接中状态
     */
    SIM_CONNECTING   = 2,

    /**
     * 已连接
     */
    SIM_CONNECTED    = 3,
    
    /**
     * 已断开
     */
    SIM_DISCONNECTED = 4,
    
    /**
     * 网络掉线
     */
    SIM_OFFLINE      = 5,
};

#endif /* SIMComm_h */
