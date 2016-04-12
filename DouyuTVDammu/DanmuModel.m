
//
//  DanmuModel.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/12.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DanmuModel.h"
#import "NSString+InfoGet.h"
#import "TYAttributedLabel.h"
#import "RegexKitLite.h"

@implementation DanmuModel

#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

- (void)setModelFromStirng:(NSString *)string{

    _dataString = string;
    NSString *msg;
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:15];
    container.linesSpacing = 0;
    container.characterSpacing = 0;
    
    switch (self.cellType) {
        case CellNewChatMessageType:
            {

                
                NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
                NSString *contentPattern = @"(?<=txt@=).*?(?=/)";
                
                NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
                NSString *unReplaceTXT = [[string componentsMatchedByRegex:contentPattern]firstObject];
                NSString *replaceTXT = [unReplaceTXT stringByReplacingOccurrencesOfRegex:@"@A" withString:@"@"];
                NSString *txt = [replaceTXT stringByReplacingOccurrencesOfRegex:@"@S" withString:@"/"];
                
                msg = [NSString stringWithFormat:@"%@:%@",name,txt];
                
                // 属性文本生成器
                container.text = msg;
                NSMutableArray *tmpArray = [NSMutableArray array];
                
                // 正则匹配表情
                [msg enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                    
                    if (captureCount > 0) {
                        // 图片信息储存
                        TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                        imageStorage.cacheImageOnMemory = YES;
                        imageStorage.imageName = capturedStrings[1];
                        imageStorage.range = capturedRanges[0];
                        imageStorage.size = CGSizeMake(30, 30);
                        
                        [tmpArray addObject:imageStorage];
                    }
                }];
                TYTextStorage *textStorage = [[TYTextStorage alloc]init];
                textStorage.range = [msg rangeOfString:name];
                textStorage.textColor = RGB(30, 153, 247, 1);
                textStorage.font = [UIFont systemFontOfSize:15];
                [container addTextStorage:textStorage];
                
                // 添加表情数组到label
                [container addTextStorageArray:tmpArray];
            }
            break;
        case CellNewGiftType:
            {

                NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
                NSString *giftPattern = @"(?<=gfid@=).*?(?=/)";
                NSString *hitPattern = @"(?<=hits@=).*?(?=/)";
                
                NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
                NSString *gift = [[string componentsMatchedByRegex:giftPattern]firstObject];
                NSString *hits = [[string componentsMatchedByRegex:hitPattern] firstObject];
                if (hits == NULL) {
                    hits = @"1";
                }
                NSString *giftName;
                NSURL *giftIconURL;
                for (NSDictionary *dic in self.gift) {
                    NSString *giftID = dic[@"id"];
                    if ([gift isEqualToString:giftID]) {
                        giftName = dic[@"name"];
                        giftIconURL = [NSURL URLWithString:dic[@"mobile_icon_v2"]];
                        break;
                    }
                }
                NSString *text = [NSString stringWithFormat:@"%@ 赠送给主播%@",name,giftName];
                
                container = [[TYTextContainer alloc]init];
                container.text = text;
                
                TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
                nameTextStorage.range = [text rangeOfString:name];
                nameTextStorage.textColor = RGB(30, 153, 247, 1);
                nameTextStorage.font = [UIFont systemFontOfSize:15];
                [container addTextStorage:nameTextStorage];
                
                TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
                imageStorage.imageURL = giftIconURL;
                imageStorage.size = CGSizeMake(30, 30);
                [container appendTextStorage:imageStorage];
                
                TYTextStorage *giftTextStorage = [[TYTextStorage alloc]init];
                giftTextStorage.text = [NSString stringWithFormat:@"%@连击",hits];
                giftTextStorage.font = [UIFont systemFontOfSize:15];
                [container appendTextStorage:giftTextStorage];
                
                msg = [NSString stringWithFormat:@"%@%@连击",text,hits];
                
            }
            break;
        case CellNewUserEnterType:
            {
                NSString *nickPattern = @"(?<=nn@=).*?(?=/)";
                NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
                msg = [NSString stringWithFormat:@"%@ 进入了直播间",name];
                
                container.text = msg;
                
                TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
                nameTextStorage.range = [msg rangeOfString:name];
                nameTextStorage.textColor = RGB(257, 100, 113, 1);
                nameTextStorage.font = [UIFont systemFontOfSize:15];
                [container addTextStorage:nameTextStorage];
                
            }
            break;
        case CellBanType:
            {
                NSString *nickPattern = @"(?<=snick@=).*?(?=/)";
                NSString *banedNamePattern = @"(?<=dnick@=).*?(?=/)";
                NSString *name = [[string componentsMatchedByRegex:nickPattern]firstObject];
                NSString *banedName = [[string componentsMatchedByRegex:banedNamePattern]firstObject];
                msg = [NSString stringWithFormat:@"管理员%@封禁了%@",name,banedName];
                
                container.text = msg;
                
                container.textColor = RGB(257, 100, 113, 1);
                
            }
            break;
        case CellDeserveType:
            {
            NSString *nickPattern = @"(?<=Snick@A=).*?(?=@)";
            NSString *levPattern = @"(?<=lev@=).*?(?=/)";
            NSString *hitPattern = @"(?<=hits@=).*?(?=/)";
            NSString *name = [[string componentsSeparatedByRegex:nickPattern]firstObject];
            NSInteger levle = [[[string componentsSeparatedByRegex:levPattern]firstObject]integerValue];
            NSString *hits = [[string componentsSeparatedByRegex:hitPattern]firstObject];
            NSString *deserve;

            switch (levle) {
                case 1:
                    deserve = @"初级酬勤";
                    break;
                case 2:
                    deserve = @"中级酬勤";
                    break;
                case 3:
                    deserve = @"高级酬勤";
                    break;
                default:
                    break;
            }
            msg = [NSString stringWithFormat:@"%@ 给主播赠送了%@%@连击",name,deserve,hits];
            
            container.text = msg;
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            nameTextStorage.range = [msg rangeOfString:name];
            nameTextStorage.textColor = RGB(30, 153, 247, 1);
            nameTextStorage.font = [UIFont systemFontOfSize:15];
            [container addTextStorage:nameTextStorage];
            
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [msg rangeOfString:deserve];
            deserveTextStorage.textColor = RGB(198, 53, 150, 1);
            deserveTextStorage.font = [UIFont systemFontOfSize:15];
            [container addTextStorage:deserveTextStorage];
            

        }
        default:
            break;
    }
    _unColoredMsg = msg;
    _textContainer = container;
}



@end
