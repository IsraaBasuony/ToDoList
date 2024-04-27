//
//  Task.m
//  todo
//
//  Created by JETSMobileLabMini1 on 17/04/2024.
//

#import "Task.h"

@implementation Task  



- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.describtion forKey:@"describtion"];
    [coder encodeObject:self.priority forKey:@"priority"];
    [coder encodeObject:self.state forKey:@"state"];
    [coder encodeObject:self.date forKey:@"date"];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { 
    self = [super init];
    
    if(self)
    {
        self.title = [coder decodeObjectForKey:@"title"];
        self.describtion =  [coder decodeObjectForKey:@"describtion"];
        self.priority =  [coder decodeObjectForKey:@"priority"];
        self.state=  [coder decodeObjectForKey:@"state"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    
    return self;
}

@end
