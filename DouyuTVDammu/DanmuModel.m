
//
//  DanmuModel.m
//  DouyuTVDammu
//
//  Created by LuChen on 16/3/12.
//  Copyright © 2016年 Bad Chen. All rights reserved.
//

#import "DanmuModel.h"
#import "NSString+InfoGet.h"
@implementation DanmuModel

- (void)setModelFromStirng:(NSString *)string{

    NSString *msg;
    NSMutableAttributedString *abText;
    
    switch (self.cellType) {
        case CellNewChatMessageType:
            {
                NSString *contentPattern = @"(?<=txt@=).*(?=\/cid)";
                NSString *nickPattern = @"(?<=nn@=).*(?=\/txt)";
                NSString *nickname = [string regexString:nickPattern];
                NSString *content = [string regexString:contentPattern];
                msg = [NSString stringWithFormat:@"%@:%@",nickname,content];
                abText = [[NSMutableAttributedString alloc]initWithString:msg];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,nickname.length)];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(nickname.length, 1)];
            }
            break;
        case CellNewGiftType:
            {
                NSString *gifPattern = @"(?<=gfid@=).*(?=\/gs)";
                NSString *namePattern = @"(?<=nn@=).*(?=\/ic)";
                NSString *hitPattern = @"(?<=hits@=).*(?=\/)";
                NSString *nickname;
                if ([string regexString:namePattern].length == 0) {
                    nickname = [string regexString:@"(?<=nn@=).*(?=\/ic)"];
                }else{
                    nickname = [string regexString:namePattern];
                }
                NSString *gift = [string regexString:gifPattern];
                NSString *hits = [string regexString:hitPattern];
                if (hits == NULL) {
                    hits = @"1";
                }
                NSString *giftName;
                for (NSDictionary *dic in self.gift) {
                    NSString *giftID = dic[@"id"];
                    if ([gift isEqualToString:giftID]) {
                        giftName = dic[@"name"];
                    }
                }
                NSString *temp = [NSString stringWithFormat:@"%@给主播赠送了%@ x%@",nickname,giftName,hits];
                if ([temp rangeOfString:@"/"].location != NSNotFound) {
                    msg = [temp substringToIndex:[temp rangeOfString:@"/"].location];
                }else{
                    msg = temp;
                }
                abText = [[NSMutableAttributedString alloc]initWithString:msg];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,nickname.length)];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(nickname.length+6, msg.length-nickname.length-6)];
            }
            break;
        case CellNewUserEnterType:
            {
                NSString *nickPattern = @"(?<=nn@=).*(?=\/str)";
                NSString *nickname = [string regexString:nickPattern];
                msg = [NSString stringWithFormat:@"%@ 进入了直播间",nickname];
                abText = [[NSMutableAttributedString alloc]initWithString:msg];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, nickname.length)];
            }
            break;
        case CellBanType:
            {
                NSString *nickPattern = @"(?<=snick@=).*(?=\/dnick)";
                NSString *banNickPattern = @"(?<=\/dnick@=).*(?=\/)";
                NSString *nickname = [string regexString:nickPattern];
                NSString *banedName = [string regexString:banNickPattern];
                msg = [NSString stringWithFormat:@"管理员%@封禁了%@",nickname,banedName];
                abText = [[NSMutableAttributedString alloc]initWithString:msg];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(3, nickname.length)];
                [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6+nickname.length, banedName.length)];
                
            }
            break;
        case CellChatMessageType:
        {
            NSString *nickPattern = @"(?<=Snick@A=).*(?=@Srg)";
            NSString *contentPattern = @"(?<=content@=).*(?=\/snick)";
            NSString *nickname = [string regexString:nickPattern];
            NSString *content = [string regexString:contentPattern];
            msg = [NSString stringWithFormat:@"%@:%@",nickname,content];
            abText = [[NSMutableAttributedString alloc]initWithString:msg];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,nickname.length)];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(nickname.length, 1)];
        }
            break;
        case CellGiftType:
        {
            NSString *gifPattern = @"(?<=gfid@=).*(?=\/gs)";
            NSString *namePattern = @"(?<=src_ncnm@=).*(?=\/rid)";
            NSString *hitPattern = @"(?<=hits@=).*(?=\/sid)";
            NSString *gift = [string regexString:gifPattern];
            NSString *nickname = [string regexString:namePattern];
            NSString *hits = [string regexString:hitPattern];
            NSString *giftName;
            for (NSDictionary *dic in self.gift) {
                NSString *giftID = dic[@"id"];
                if ([gift isEqualToString:giftID]) {
                    giftName = dic[@"name"];
                }
            }
            NSString *temp = [NSString stringWithFormat:@"%@给主播赠送了%@ x%@",nickname,giftName,hits];
            if ([temp rangeOfString:@"/"].location != NSNotFound) {
                msg = [temp substringToIndex:[temp rangeOfString:@"/"].location];
            }else{
                msg = temp;
            }
            abText = [[NSMutableAttributedString alloc]initWithString:msg];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,nickname.length)];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(nickname.length+6, msg.length-nickname.length-6)];
        }
            break;
        case CellUserEnterType:
        {
            NSString *nickPattern = @"(?<=Snick@A=).*(?=@Srg)";
            NSString *nickname = [string regexString:nickPattern];
            msg = [NSString stringWithFormat:@"%@ 进入了直播间",nickname];
            abText = [[NSMutableAttributedString alloc]initWithString:msg];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, nickname.length)];
        }
            break;
        case CellDeserveType:
        {
            NSString *nickPattern = @"(?<=Snick@A=).*(?=@Sicon)";
            NSString *levPattern = @"(?<=lev@=).*(?=\/rid)";
            NSString *hitPattern = @"(?<=hits@=).*(?=\/sid)";
            NSInteger levle = [[string regexString:levPattern] integerValue];
            NSString *nickname = [string regexString:nickPattern];
            NSString *hits = [string regexString:hitPattern];
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
            
            msg = [NSString stringWithFormat:@"%@给主播赠送了%@ x%@",nickname,deserve,hits];;
            abText = [[NSMutableAttributedString alloc]initWithString:msg];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,nickname.length)];
            [abText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(nickname.length+6, msg.length-nickname.length-6)];
            
        }
        default:
            break;
    }
    _unColoredMsg = msg;
    _coloredMsg = abText;
}



@end
