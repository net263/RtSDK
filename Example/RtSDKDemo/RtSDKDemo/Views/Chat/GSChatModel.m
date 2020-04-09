//
//  GSChatModel.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSChatModel.h"
#import "GSTextAttachment.h"

#define WIDTH (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - 20)

@implementation GSChatModel

- (instancetype)initWithModel:(GSChatMessage*)obj type:(GSChatModelType)type{
    if (self = [super init]) {
        
        if (obj) {
            self.info = obj.userInfo.userName;
            self.infoHeight = [GSBaseModel heightWithString:self.info LabelFont:[UIFont boldSystemFontOfSize:18.f] withLabelWidth:WIDTH];
            
            NSAttributedString *attribute = [[GSEmotionEscape sharedInstance] attributeStringFromHtml:obj.richText textFont:[UIFont fontWithName:@"Heiti SC" size:14.f] imageType:@"png"];
            
            self.message = attribute;

            CGRect rect = [self.message boundingRectWithSize:CGSizeMake(WIDTH, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            self.messageHeight = rect.size.height;
            self.msgID = obj.msgID;
            self.chatMessage = obj;
            
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            self.timeStr = dateString;
        }
        
        if (type == GSChatModelPublic) {
            self.subinfo = @"公聊";
        }else if (type == GSChatModelPrivate){
            self.subinfo = @"对你说";
        }else if (type == GSChatModelSystem){
            self.subinfo = @"系统消息";
        }
        self.type = type;
        
        self.totalHeight = self.infoHeight + self.subInfoHeight + self.messageHeight;
        
    }
    return self;
}





@end
