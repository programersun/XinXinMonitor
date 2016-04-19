//
//  PublicUtil.h
//  SINOBaseViewController
//
//  Created by 孙瑞 on 16/3/24.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicUtil : NSObject

//显示提示框,只有一个确定按钮
+(void)showInfoAlert:(NSString*)title;

//获取当前日期
+(NSString *)getToday;

//格式化日期
+(NSString *)formatToDay:(NSDate*)aDate;

//格式化日期, 时间
+(NSString*)formatToDayAndTime:(NSDate*)aDate;

//时间戳转字符串
+(NSString*)formatDayAndTimeFrom1970Seconds:(NSString*)aSecond;

//正则判断邮箱格式
+(BOOL)isValidateEmail:(NSString *)email;

//自定义正则判断
+ (BOOL)isTextJudgeWithRE:(NSString *)RE ofString:(NSString *)string;

//string高度
+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

//String宽度
+ (CGFloat)widthOfString:(NSString *)string withFont:(int)font;

//十六进制颜色转化为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

//MD5
+(NSString *)md5:(NSString *)str;

//判断是否谈有特殊字符
+(BOOL)isHasSpecialcharacters:(NSString*)characters;

//正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum;

//判断字符串是不是纯数字
+(BOOL)isPureNumandCharacters:(NSString *)string;

//判断是否是日期
+(BOOL)isDate:(NSString *)dateString;

//判断时候是正确的日期
+(BOOL)iscCorrectDate:(NSString *)date;

//判断是否是闰年
+(BOOL)isLeapYear:(NSInteger)strYear;

//判断身份证
+(BOOL)isIdCardNumber:(NSString *)idCardNumber;

//判断银行卡号  算法存在少许误差。最好这是用于提示用户输入的银行卡可能有误
+(BOOL)isBankCardNumber:(NSString *)bankCardNumber;

@end
