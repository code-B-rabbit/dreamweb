# ************************************************************
# Host: 127.0.0.1 (MySQL 5.7.29)
# Database: dreamweb
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table user
# ------------------------------------------------------------

drop table IF EXISTS `user`;

create TABLE `user` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `unionid` varchar(100) DEFAULT NULL comment '微信的统一id',
                        `login_name` varchar(100) NOT NULL DEFAULT '' comment '登录名',
                        `login_method` varchar(50) DEFAULT NULL comment '登录类型',
                        `name` varchar(200) DEFAULT '',
                        `email` varchar(200) DEFAULT NULL,
                        `password` varchar(100) DEFAULT NULL,
                        `role` varchar(100) DEFAULT NULL comment '角色',
                        `phone` varchar(100) DEFAULT NULL comment '手机号码',
                        `comment` varchar(1000) DEFAULT NULL,
                        `gmt_create` datetime DEFAULT NULL,
                        `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `login_name` (`login_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

lock TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

insert into `user` (`id`, `unionid`, `login_name`, `name`, `email`, `password`, `role`, `phone`, `comment`, `gmt_create`, `gmt_modified`)
VALUES
(1,NULL,'admin','管理员',NULL,'304213573cbe4ea1304a1d630e3e7322','ROLE_ADMIN',NULL,NULL,NULL,'2021-01-15 13:56:52'),
(2,NULL,'test','测试',NULL,'6791018a83aecc125f4e150ac6acefa9','ROLE_GUEST','11111222','','2021-01-15 14:00:06','2021-01-15 14:00:19');

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user_group
# ------------------------------------------------------------

drop table IF EXISTS `user_group`;

create TABLE `user_group` (
                              `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                              `name` varchar(200) NOT NULL DEFAULT '',
                              `gmt_create` datetime DEFAULT NULL,
                              `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user_group_associate
# ------------------------------------------------------------

drop table IF EXISTS `user_group_associate`;

create TABLE `user_group_associate` (
                                        `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                        `user_id` int(11) NOT NULL,
                                        `user_group_id` int(11) NOT NULL,
                                        `gmt_create` datetime DEFAULT NULL,
                                        `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                                        PRIMARY KEY (`id`),
                                        UNIQUE KEY `u_user_user_group` (`user_group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user_role
# ------------------------------------------------------------

drop table IF EXISTS `user_role`;

create TABLE `user_role` (
                             `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                             `user_group_id` int(11) NOT NULL,
                             `role_name` varchar(100) NOT NULL,
                             `role_value` varchar(200) DEFAULT NULL,
                             `role_type` varchar(100) DEFAULT NULL,
                             `gmt_create` datetime DEFAULT NULL,
                             `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table api_user
# ------------------------------------------------------------

drop table IF EXISTS `api_user`;

create TABLE `api_user` (
                        `id` int(11) NOT NULL AUTO_INCREMENT,
                        `accessKeyId` varchar(100) NOT NULL,
                        `accessKeySecret` varchar(100) NOT NULL,
                        `comment` varchar(1000) DEFAULT NULL,
                        `valid` tinyint(1) NOT NULL comment '是否生效',
                        `gmt_create` datetime DEFAULT NULL,
                        `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `accessKeyId` (`accessKeyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table login_record
# ------------------------------------------------------------

drop table IF EXISTS `login_record`;

create TABLE `login_record` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `client_ip_addr` varchar(100) NOT NULL comment '客户端IP地址',
                            `login_name` varchar(100) NOT NULL comment '登录名',
                            `login_method` varchar(100) NOT NULL comment '登录方式',
                            `comment` varchar(1000) DEFAULT NULL,
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table system_config
# ------------------------------------------------------------

drop table IF EXISTS `system_config`;

create TABLE `system_config` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `config_name` varchar(100) NOT NULL comment '配置名',
                            `config_value` varchar(5000) DEFAULT NULL comment '配置',
                            `comment` varchar(1000) DEFAULT NULL,
                            `changeable` tinyint(1) NOT NULL DEFAULT TRUE comment '是否可修改',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `config_name` (`config_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

lock TABLES `system_config` WRITE;

insert into `system_config` (`config_name`, `config_value`, `comment`, `changeable`, `gmt_create`)
VALUES
('allowWechatLogin','true','是否允许通过微信登录',TRUE,now()),
('allowLDAP','false','是否允许通过LDAP登录',TRUE,now()),
('loginPageTitle','无限梦想','登录页标题',TRUE,now()),
('allowSolutionDemo','false','解决方案Demo开关',TRUE,now()),
('region','','日志服务地区配置',TRUE,now()),
('useVpc','false','是否使用私网地址',TRUE,now());

UNLOCK TABLES;


# Dump of table sls_config
# ------------------------------------------------------------

drop table IF EXISTS `sls_config`;

create TABLE `sls_config` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `config_name` varchar(100) NOT NULL comment '配置名',
                            `config_value` varchar(5000) DEFAULT NULL comment '配置',
                            `config_owner_id` int(11) NOT NULL comment '所有者',
                            `comment` varchar(1000) DEFAULT NULL,
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `config_name` (`config_name`),
                            UNIQUE KEY `config_owner_id` (`config_owner_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table solution_config
# ------------------------------------------------------------

drop table IF EXISTS `solution_config`;

create TABLE `solution_config` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `name` varchar(100) NOT NULL comment '解决方案名称',
                            `intro` varchar(5000) DEFAULT NULL comment '解决方案简介',
                            `web_config` varchar(1000) NOT NULL comment '解决方案网页配置',
                            `creator` varchar(100) NOT NULL comment '解决方案创建人',
                            `module` varchar(100) NOT NULL comment '解决方案所属模块',
                            `customer_num` int(11) NOT NULL DEFAULT 0 comment '客户数量',
                            `is_mvp` tinyint(1) NOT NULL DEFAULT 0 comment '是否是MVP',
                            `has_terraform` tinyint(1) NOT NULL DEFAULT 0 comment '是否有Terraform脚本',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

lock TABLES `solution_config` WRITE;

insert into `solution_config` (`name`, `intro`, `web_config`, `creator`, `module`, `gmt_create`)
VALUES
('自建IDP实现多账号SSO', 'IdP由集团管理，SLA无法满足云运维所需要的响应速度，IdP非标准化无法直接和阿里云配置。本方案通过自建IDP，一次性配置完成多账号的SSO，多账号登录态能在IDP侧统一切换，延续一致的试用体验，延续现有账号管理体系，不存在单独的个人云账号，避免离职等场景的安全隐患',
'{"SSO自动化配置":"/ssoConfig/ssoConfig.html"}', '程超', '身份权限', now()), 
('企业级公有云统一日志', '随着企业信息化的发展，面向云的IT基础设施越来越普遍，如何在庞大的IT基础设施面前管理软件的日志，成为IT稳定性保障的关键环节。本方案主要介绍如何使用SLS对阿里云、专有IDC以及第三方云场景下，进行企业级的日志管理',
'{"SLS自动化配置":"/slsAutoConfig/slsAutoConfig.html", "统一日志查看":"/slsView/slsView.html"}', '青弦', '运维管理', now());

UNLOCK TABLES;

DROP TABLE IF EXISTS `provisioned_product`;
DROP TABLE IF EXISTS `product`;
DROP TABLE IF EXISTS `myAsk`;
DROP TABLE IF EXISTS `userproduct`;

create TABLE `product` (
                            `id` int(11) NOT NULL AUTO_INCREMENT comment '主键',
                            `productid` varchar(100) comment '产品id',
                            `application` varchar(100) NOT NULL comment '应用',
                            `scenes` varchar(100) NOT NULL comment '场景',
                            `productname` varchar(100) NOT NULL comment '产品名称',
                            `productversionid` varchar(100) NOT NULL comment '产品版本ID',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON update CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY (`productversionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

insert into `product` (`productid`, `application`, `scenes`,`productname`, `productversionid`, `gmt_create`)
VALUES
('prod-bp1c6y7y2wj453','application1','日常','asdasda', 'pv-bp15gfhv2px6th', now()),
('prod-bp1c6y7y2wj453','application1','预发','DEMO-创建ECS（选择VPC）','pv-bp11vd4m26h6uh',now()),
('prod-bp1c6y7y2wj453','application1','线上','DEMO-创建ECS（选择VPC）','pv-bp151yxr2we4jw',now()),

('prod-bp1qbazd242511','application2','预发','sdffedxx','asdasdasassd',now()),
('prod-bp18r7q127u45k','application2','线上','DEMO-创建VPC+ECS','pv-bp1wendz2e962y',now()),
('prod-bp1p27wj2c94fg','application2','日常','DEMO-创建RAM角色','pv-bp1zymve23b54q',now()),

('prod-bp1p27wj2c94fg','application3','预发','DEMO-创建RAM角色','pv-bp1z87gw25a4zf',now()),
('prod-bp18r7q127u45k','application3','线上','DEMO-创建VPC+ECS','pv-bp15e79d2614pw',now()),
('prod-bp18r7q127u45k','application3','日常','DEMO-创建VPC+ECS','pv-bp1bjeut29963a',now());


CREATE TABLE `provisioned_product`(
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `examplename` varchar(100) NOT NULL COMMENT '实例名称',
                            `productid` varchar(100) NOT NULL COMMENT '产品ID',
                            `productname` varchar(100) NOT NULL COMMENT '产品名称',
                            `exampleid` varchar(100) NOT NULL COMMENT '实例ID',
                            `roleid` int(11) NOT NULL COMMENT '角色ID',
                            `startname` varchar(100) NOT NULL COMMENT '实例申请人',
                            `status` varchar(100) NOT NULL COMMENT '实例状态',
                            `parameter` varchar(1000)COMMENT '申请参数',
                            `outputs` varchar(1000) COMMENT '输出',
                            `starttime` varchar(100) COMMENT '创建时间',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY (`examplename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `myAsk` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `starterName` varchar(100) NOT NULL COMMENT '申请人',
                            `roleId` int(11) NOT NULL COMMENT '角色ID',
                            `application` varchar(100) NOT NULL COMMENT '应用',
                            `scene` varchar(100) NOT NULL COMMENT '环境',
                            `processTime` varchar(100) NOT NULL COMMENT '申请时间',
                            `processId` varchar(100) COMMENT '流程实例ID',
                            `exampleName` varchar(100) COMMENT '实例名称',
                            `productName` varchar(100) COMMENT '产品名称',
                            `task` varchar(100) COMMENT '当前节点',
                            `processState` varchar(100) NOT NULL COMMENT '流程状态',
                            `portfolioId` varchar(100) NOT NULL COMMENT '产品组合ID',
                            `planResult` varchar(1000) COMMENT '预检结果',
                            `parameters` varchar(1000) NOT NULL COMMENT '流程信息',
                            `productId` varchar(100) NOT NULL COMMENT '产品ID',
                            `planId` varchar(100) NOT NULL COMMENT '启动计划ID',
                            `region` varchar(100) COMMENT '地域',
                            `versionid` varchar(100) COMMENT '版本ID',
                            `cond` varchar(50) COMMENT '是否审批通过',
                            `processDefinitionId` varchar(100) NOT NULL COMMENT '流程定义ID',
                            `opinion` varchar(500) COMMENT '审批拒绝意见',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY (`processId`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `userproduct` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `productid` varchar(100) NOT NULL COMMENT '产品ID',
                            `username` varchar(100) NOT NULL COMMENT '用户名',
                            `portfolioid` varchar(100) NOT NULL COMMENT '产品组合ID',
                            `productname` varchar(100) NOT NULL COMMENT '产品名称',
                            `gmt_create` datetime DEFAULT NULL,
                            `gmt_modified` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `user-product` (`username`, `productid`),
                            UNIQUE KEY `user-product-portfolio` (`username`, `productid`, `portfolioid`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `userproduct` (`productid`, `productname`, `username`, `portfolioid`, `gmt_create`)
VALUES
('prod-bp18r7q127u45k','DEMO-创建VPC+ECS','admin','port-bp1yt7582gn4p7',now()),
('prod-bp18r7q127u45k','DEMO-创建VPC+ECS','dou','port-bp1yt7582gn4p7',now()),
('prod-bp1c6y7y2wj453','创建ECS','admin','port-bp1yt7582gn4p7',now()),
('prod-bp1c6y7y2wj453','创建ECS','dou','port-bp1yt7582gn4p7',now()),
('prod-bp1p27wj2c94fg','创建RAM角色','admin','port-bp1yt7582gn4p7',now()),
('prod-bp1p27wj2c94fg','创建RAM角色','dou','port-bp1yt7582gn4p7',now());


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
