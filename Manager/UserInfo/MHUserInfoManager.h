//
//  MHUserInfoManager.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHProvince,MHCity,MHNativeprovince,MHNativecity, MHUserRole,MHVolUserInfo,MHVolUserInfoAddress;
@interface MHUserInfoManager : NSObject <NSCoding>
 //-------------------------个人信息-----------------------------/
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_img;
@property (nonatomic, copy) NSString *user_s_img;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic,strong) NSNumber *user_type;
@property (nonatomic,strong) NSNumber *user_type_name;
@property (nonatomic, strong) NSNumber  *volunteer_id;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phone_number;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *hobby;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic,copy) NSString *my_introduce;

@property (nonatomic, strong) NSNumber *is_volunteer;
@property (nonatomic, strong) NSNumber *all_integral;
@property (nonatomic, strong) MHUserRole *role;
@property (nonatomic, strong) NSNumber  *volunteer_role;   //0队员  1分队长  2总队长

/** 是否需要提示住户认证，0：不需要提示，1：需要提示 */
@property (nonatomic, strong) NSNumber  *is_need_to_notice;
@property (nonatomic, strong) NSNumber  *is_set_pay_password;   //是否设置支付密码，0表示未设置，1表示已设置


@property (nonatomic, strong) NSNumber  *is_merchant;  // 是否合作商家，0：不是，1：是
@property (nonatomic, assign) BOOL is_enable_mall_merchant; // 是否开放商城权限
@property (nonatomic, copy)   NSString * customer_contact_tel;  // 客服电话

 //-------------------------小区信息-----------------------------/
@property (nonatomic, strong) NSNumber *community_id;
@property (nonatomic, copy) NSString *community_name;

@property (nonatomic, strong) NSNumber *smartdoor_enable;
@property (nonatomic, copy) NSString *community_service_phone;

@property (nonatomic, copy)   NSString * serve_community_name; // 服务区名字
@property (nonatomic, strong)   NSNumber * serve_community_id; // 服务区ID

@property (nonatomic, strong) NSNumber *is_partner_user;
@property (nonatomic, copy) NSString *user_home;

//-------------------------app内部业务信息-----------------------------/
@property (nonatomic, strong) NSNumber *show_all_function;
@property (nonatomic, strong) NSNumber *is_visitor;

/** 住户认证状态，0表示未认证，1表示认证中，2表示已认证*/
@property (nonatomic, strong) NSNumber *validate_status;

// 用于处理首页获取数据逻辑
@property (nonatomic, strong) NSNumber *home_Community_id;
@property (nonatomic, strong) NSString *home_Community_name;
//-------------------------逻辑业务-----------------------------/
/** OSS 配置信息 by Beelin*/
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;

/** 所在城市小区，是否已开通物业服务 */
@property (nonatomic,assign) BOOL is_enable_property;

/** 
 是否登录
 */
@property (nonatomic, assign, getter=isLogin, readonly) BOOL login;

/**
 *  我的资料卡
 */
@property (strong,nonatomic) MHVolUserInfo *volUserInfo;

/**
 *  省份内容
 */
@property (strong,nonatomic) MHProvince *province;

/**
 *  城市内容
 */
@property (strong,nonatomic) MHCity *city;



/**
 *  籍贯省份
 */
@property (strong,nonatomic) MHNativeprovince *nativeprovince;


/**
 *  籍贯城市
 */
@property (strong,nonatomic) MHNativecity *nativecity;


/*-------------------------公有方法-----------------------------*/
/**
 单例
 */
+ (instancetype)sharedManager;

/** 解析 */
- (void)analyzingData:(NSDictionary *)data;

/** 存档 */
- (void)saveUserInfoData;

/** 删档 */
- (void)removeUserInfoData;

@end




@interface MHUserRole : NSObject
@property (nonatomic, strong) NSNumber *role_type;
@property (nonatomic, copy) NSString *role_name;
@end


//-------------------------地理信息-----------------------------/
@interface MHProvince : NSObject
@property (nonatomic, strong) NSNumber *province_id; // 省份id
@property (nonatomic, copy) NSString *province_name;  // 所属省份	广东省
@end

@interface MHCity : NSObject
@property (nonatomic, strong) NSNumber *city_id;       // 城市id	121
@property (nonatomic, copy) NSString *city_name;  // 所属城市	广州
@end



//-------------------------籍贯信息-----------------------------/

@interface MHNativeprovince : NSObject

/**
 * 籍贯省份id
 */
@property (nonatomic, strong) NSNumber *native_province_id;

/**
 * 籍贯所属省份
 */
@property (nonatomic, copy) NSString *native_province_name;
@end


@interface MHNativecity : NSObject

/**
 *  籍贯城市id
 */
@property (nonatomic, strong) NSNumber *native_city_id;

/**
 *  籍贯所属城市
 */
@property (nonatomic, copy) NSString *native_city_name;
@end

//-------------------------我的资料卡-----------------------------/
@interface MHVolUserInfo : NSObject
@property (nonatomic, copy) NSString *user_img;            //照片大图
@property (nonatomic, copy) NSString *user_s_img;          //照片小图
@property (nonatomic, copy) NSString *real_name;           //姓名
@property (nonatomic, copy) NSString *identity_card;       //身份证
@property (nonatomic, copy) NSString *sex;                 //性别
@property (nonatomic, copy) NSString *birthday;            //生日
@property (nonatomic, copy) NSString *phone;               //手机号码
@property (nonatomic, strong) MHVolUserInfoAddress *address;             //住址
@property (nonatomic, copy) NSString *tag;                 //兴趣爱好
@property (nonatomic, copy) NSString *support;             //服务名称
@property (nonatomic, strong)NSArray *volunteer_duty_list; //职务
@end

@interface MHVolUserInfoAddress : NSObject
@property (nonatomic,  copy) NSString *city;            //城市
@property (nonatomic,  copy) NSString *community;       //地区
@property (nonatomic,  copy) NSString *room;           //房间号
@property (nonatomic,assign,getter=isLocalWrite) BOOL localWrite;
@end

/*
 
 /-------------------------个人信息-----------------------------/
 user_id	Long	1213121	用户id
 user_name	String	爱蛇	用户名称(昵称)
 user_img	String	http://	头像原图
 user_s_img	String	http://	头像缩略图
 realname	String	周先生	真实姓名
 user_type	Integer	0 1 2 3 4 5 9	用户类型:
 0-普通用户
 1-认证用户
 user_type_name	String	普通用户	用户类型名称:
 普通用户
 认证用户
 
 sex	String	男,女	性别
 phone_number	String	15800002222	联系电话
 edu	String	本科	学历
 job	String	QQ飞行棋直播	职业
 hobby	String	跑步、飞行棋现场直播、广场大妈舞	爱好
 company	String	广州聚房宝网络科技股份有限公司	公司名称
 birthday	String	1999/11/11 天蝎座	生日/星座
 my_introduce String 象棋，篮球，爬山	技能/兴趣 标签
 is_volunteer	Integer	1	是否志愿者  2017-07-19
 roles	Array<UserRole>     所属角色列表
 all_integral	Integer	880	志愿者总积分  2017-07-19

 
/-------------------------小区信息-----------------------------/
 community_id	Long	12121	所属小区,如果没有所属小区则为0
 community_name	String	XX小区	所属小区名称
  smartdoor_enable	Boolean	1,0	当前小区是否支持智能门禁功能  2017-03-16
 community_service_phone	String	010-xxxx	小区服务电话
 is_partner_user	boolean	true,false	是否合作小区用户
 user_home	String	13栋A区301房	所住位置
  mgrcorp	Json	参考MgrCorp/Get数据	小区所属物管公司数据
 
 
  /-------------------------角色列表-----------------------------/
 
 role_type	Integer	1
 1表示普通用户
 2表示住户
 3表示志愿者队员
 4表示志愿者总队长
 5表示志愿者分队长
 
 role_name	String	普通用户	角色名称
 
 
 /-------------------------地理信息-----------------------------/
 province
 province_id	Long	省份id	199
 province_name	String	所属省份	广东省
 
 city
 city_id	Long	城市id	121
 city_name	String	所属城市	广州
 
 
/-------------------------籍贯信息-----------------------------/
 nativeprovince
 native_province_id	Long	籍贯省份id	121
 native_province_name	String	籍贯所属省份	广东省
 
 nativecity
 native_city_id	Long	籍贯城市id	121
 native_city_name	String	籍贯所属城市	广州市
 
 /-------------------------店铺信息-----------------------------/
 my_studio
 studio_id	Long	123	店铺id
 studio_name	String	我的店铺	店铺名称

 
 /-------------------------app内部业务信息-----------------------------/
  show_all_function	Boolean	0,1	是否显示app所有功能
 is_visitor	Integer	0 | 1	游客标识，0表示是游客，1表示是住户，2表示是商户(暂定)
 validate_status	Integer	0	住户认证状态，0表示未认证，1表示认证中，2表示已认证  2017-07-19
 
 friend_count	Integer	10	好友数量   2017-02-27
 moment_count	Integer	79	动态数量 2017-02-27
 thank_count	Integer	10	感谢数量 2017-02-27
 thank_status	Integer	0 | 1	是否有未读的感谢，0-没有，1-有2017-02-27
 
 lastlogin_datetime	String	2016-05-26 18:00	最近登录时间
 register_datetime	String	2016-05-26 18:00	注册时间
 
 
  /-------------------------app外部业务信息-----------------------------/
 im_username	String	u_1120120121	环信登录账号
 uuid	String	1212131dafasdf	环信用户UUID
 
 
 /-------------------------权限信息-----------------------------/
 allow_friend_view	Boolean	true,false （true可见）	个人信息好友是否可见
 allow_receive_all_moment	Boolean	true,false （true可见）	是否接受周边小区动态
 allow_live	Integer	1	是否允许直播 1 ：允许 0 ：不允许
 

 /-------------------------特异功能信息-----------------------------/
 skillfile_url	String	http://xx.com/1.jpg	技能证书图片url
 my_introduce	String	象棋，篮球，爬山	技能/兴趣 标签
 skill_tags	Array<Tag>	 	技能标签列表
 hobby_tags	Array<Tag>	 	兴趣标签列表
 
 
  /-------------------------用户等级身份信息-----------------------------/
 user_type	Integer	0 1 2 3 4 5 9	用户类型:
 0-普通用户
 1-业主
 2-租客
 3-家庭成员
 4-小区管理员
 5-物管公司
 9-管理员
 user_type_name	String	普通用户	用户类型名称:
 普通用户
 业主
 租客
 家庭成员
 小区管理员
 5-物管公司
 9-管理员
 user_level	Integer	0 1 2 3	用户等级:
 0-初级用户
 1-中级用户
 2-高级用户
 3-VIP用户
 user_level_name	String	初级用户
 初级用户
 中级用户
 高级用户
 VIP用户
 
 
 /-------------------------支付相关信息-----------------------------/
 is_use_alipay	Boolean	true | false	小区设置支付方式，true-允许使用支付宝支付，false-不允许支付(管理后台可以设置支付宝账号信息，如果没有设置支付宝账号，则该字段值为false，此时，前端需要提示用户或者禁用缴费按钮等)
 is_use_weixin	Boolean	true | false	小区设置支付方式，true-允许使用微信支付，false-不允许支付(管理后台可以设置微信支付账号信息，如果没有设置微信支付账号，则该字段值为false，此时，前端需要提示用户或者禁用缴费按钮等)

 alipay_account	String	121212@163.com	绑定支付宝账号
 qrcode_url	String	http://xx.com/1.jpg	二维码url

 


*/
