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

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
