//
//  PublicUtil.m
//  SINOBaseViewController
//
//  Created by 孙瑞 on 16/3/24.
//  Copyright © 2016年 孙瑞. All rights reserved.
//

#import "PublicUtil.h"
#include <CommonCrypto/CommonDigest.h>

@implementation PublicUtil

//显示提示框,只有一个确定按钮
+(void)showInfoAlert:(NSString*)title{
    UIAlertView *tAlert=[[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [tAlert show];
}

//获取当前日期
+(NSString *)getToday{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

//格式化日期
+(NSString *)formatToDay:(NSDate*)aDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:aDate];
}

//格式化日期, 时间
+(NSString*)formatToDayAndTime:(NSDate*)aDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:aDate];
}

//时间戳转字符串
+(NSString*)formatDayAndTimeFrom1970Seconds:(NSString*)aSecond{
    
    NSDate *tDate=[NSDate dateWithTimeIntervalSince1970:[aSecond longLongValue]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:tDate];
}


//正则判断邮箱格式
+(BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//自定义正则判断
/**
 *  自定义正则判断
 *
 *  @param RE     正则式
 *  @param string 字符串
 *
 *  @return 判断结果
 */
+ (BOOL)isTextJudgeWithRE:(NSString *)RE ofString:(NSString *)string{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",RE];
    return [predicate evaluateWithObject:string];
}


/**
 *  String高度
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param width  最大限宽
 *
 *  @return 字符串size
 */
+ (CGFloat)heightWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传入的字体字典
                                       context:nil];
    return rect.size.height;
}

+ (CGFloat)widthOfString:(NSString *)string withFont:(int)font{
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(3750, 9999)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                           context:nil];
    
    CGSize size = textRect.size;
    
    return size.width;
}


//十六进制颜色转化为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}

//MD5
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//判断是否谈有特殊字符
+(BOOL)isHasSpecialcharacters:(NSString*)characters
{
    NSString *  englishNameRule = @"^[(A-Za-z0-9)*(\u4e00-\u9fa5)*(,|\\.|，|。|\\:|;|：|；|!|！|\\*|\\×|\\(|\\)|\\（|\\）|#|#|\\$|&#|\\$|&amp;|\\^|@|&#|\\$|&amp;|\\^|@|＠|＆|\\￥|\\……)*]+$";
    NSPredicate * englishpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", englishNameRule];
    return [englishpredicate evaluateWithObject:characters];
}

//正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString *all = @"^1([3-9][0-9])\\d{8}$";
    NSPredicate *regextestct1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", all];
    if (([regextestct1 evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断字符串是不是纯数字
+(BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }else {
        return YES;
    }
}

//判断是否是日期
+(BOOL)isDate:(NSString *)dateString
{
    NSString *regx = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    if (([predicate evaluateWithObject:dateString] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *  判断时候是正确的日期
 *
 *  @param date 日期字符串 如20160101
 *
 *  @return 是否为正确的日期
 */
+(BOOL)iscCorrectDate:(NSString *)date
{
    //日期必须为纯数字
    if (![self isPureNumandCharacters:date])
    {
        return NO;
    }
    NSString *strYear  = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *strMonth = [date substringWithRange:NSMakeRange(4, 2)];
    NSString *strDay   = [date substringWithRange:NSMakeRange(6, 2)];
    NSString *strDate  = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDay];
    //判断日期
    if (![self isDate:strDate])
    {
        return NO;
    }
    //判断年份
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
    NSDate *fromDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [calender component:NSCalendarUnitYear fromDate:fromDate];
    if (200 <= year - [strYear integerValue] || [strYear integerValue] > year)
    {
        return NO;
    }
    //判断月份
    NSInteger month = [strMonth integerValue];
    if (12 < month || 1 > month)
    {
        return NO;
    }
    //判断日期
    NSInteger day = [strDay integerValue];
    //天数必须大于1
    if (day < 1) {
        return NO;
    }
    NSArray *month31 = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    NSArray *month30 = @[@"4",@"6",@"9",@"11"];
    //31天的月份
    for (NSString *m in month31)
    {
        if (month == [m integerValue] && day > 31)
        {
            return NO;
        }
    }
    //30天的月份
    for (NSString *m in month30)
    {
        if (month == [m integerValue] && day > 30)
        {
            return NO;
        }
    }
    //2月份
    if (2 == month)
    {
        if ([self isLeapYear:year] && day > 29)
        {
            return NO;
        }
        if (![self isLeapYear:year] && day > 28)
        {
            return NO;
        }
    }
    return YES;
}

//判断是否是闰年
+(BOOL)isLeapYear:(NSInteger)strYear
{
    if ((strYear%4==0&&strYear%100!=0)||strYear%400==0)
    {
        return YES;
    } else {
        return NO;
    }
}

/*
 身份证号码验证
 1、号码的结构
 公民身份号码是特征组合码，由十七位数字本体码和一位校验码组成。排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。
 2、地址码(前六位数）
 表示编码对象常住户口所在县(市、旗、区)的行政区划代码，按GB/T2260的规定执行。 
 3、出生日期码（
 第七位至十四位）
 表示编码对象出生的年、月、日，按GB/T7408的规定执行，年、月、日代码之间不用分隔符。 
 4、顺序码（第十五位至十七位）
 表示在同一地址码所标识的区域范围内，对同年、同月、同日出生的人编定的顺序号， 顺序码的奇数分配给男性，偶数分配给女性。 
 5、校验码（第十八位数）
 （1）十七位数字本体码加权求和公式 S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和
    Ai:表示第i位置上的身份证号码数字值 Wi:表示第i位置上的加权因子 Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2
 （2）计算模 Y = mod(S, 11) （3）通过模得到对应的校验码 Y: 0 1 2 3 4 5 6 7 8 9 10 校验码: 1 0 X 9 8 7 6 5 4 3 2
 */
+(BOOL)isIdCardNumber:(NSString *)idCardNumber
{
    
    NSString *Ai = @"";
    idCardNumber = idCardNumber.uppercaseString;
    if (18 == idCardNumber.length || 15 == idCardNumber.length)
    {
        if (18 == idCardNumber.length)
        {
            Ai = [idCardNumber substringWithRange:NSMakeRange(0, 17)];
        }
        if (15 == idCardNumber.length)
        {
            Ai = [NSString stringWithFormat:@"%@19%@",[idCardNumber substringWithRange:NSMakeRange(0, 6) ],[idCardNumber substringWithRange:NSMakeRange(6, 8) ]];
        }
        if (![self isPureNumandCharacters:Ai])
        {
            return NO;
        }
        //判断日期
        if (![self iscCorrectDate:[Ai substringWithRange:NSMakeRange(6, 8)]])
        {
            return NO;
        }
        //区域编码不正确
        NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
        BOOL code = NO;
        NSString *AddCode = [Ai substringWithRange:NSMakeRange(0, 2)];
        for (int i = 0; i < areasArray.count; i++)
        {
            if ([AddCode isEqualToString:areasArray[i]])
            {
                code = YES;
                break;
            }
        }
        if (!code)
        {
            return NO;
        }
        //判断最后一位的值
        NSInteger TotalmulAiWi = 0;
        NSArray *Wi = @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        NSArray *ValCodeArr   = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        for (int i = 0; i < 17; i++)
        {
            NSString *indexAi = [Ai substringWithRange:NSMakeRange(i, 1)];
            TotalmulAiWi += [Wi[i] intValue] * [indexAi intValue];
        }
        NSInteger modValue = TotalmulAiWi % 11;
        NSString *strVerifyCode = ValCodeArr[modValue];
        if ([[idCardNumber substringWithRange:NSMakeRange(17, 1)] isEqualToString:strVerifyCode])
        {
            return YES;
        }else
        {
            return NO;
        }
        
    }else
    {
        return NO;
    }
}

/*
 *  1、从卡号最后一位数字开始，逆向将奇数位(1、3、5等等)相加。
 *  2、从卡号最后一位数字开始，逆向将偶数位数字，先乘以2（如果乘积为两位数，则将其减去9），再求和。
 *  3、将奇数位总和加上偶数位总和，结果应该可以被10整除。
 */

+(BOOL)isBankCardNumber:(NSString *)bankCardNumber
{
    if ([self isPureNumandCharacters:bankCardNumber])
    {
        int sum = 0;
        NSInteger len = bankCardNumber.length;
        for (int i = 0; i < len; i++)
        {
            NSString *tmpStirng = [bankCardNumber substringWithRange:NSMakeRange(len - 1 - i, 1)];
            int tmpVal = tmpStirng.intValue;
            if (0 != i % 2)
            {
                tmpVal *= 2;
                if (tmpVal >= 10)
                {
                    tmpVal -= 9;
                }
            }
            sum += tmpVal;
        }
        
        if (0 == sum % 10)
        {
            return YES;
        }else {
            return NO;
        }
        
    }else {
        return NO;
    }
}

@end
