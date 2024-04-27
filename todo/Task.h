//
//  Task.h
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>
@property NSMutableString *title;
@property NSMutableString *describtion;
@property NSDate *date;
@property NSMutableString *state;
@property NSMutableString  *priority;



@end

NS_ASSUME_NONNULL_END
