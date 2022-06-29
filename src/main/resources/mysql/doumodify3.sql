DROP TABLE IF EXISTS `myAsk`;
CREATE TABLE `myAsk` (
                            `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `starterName` varchar(100) NOT NULL COMMENT '申请人',
                            `roleId` int(11) NOT NULL COMMENT '角色ID',
                            `application` varchar(100) NOT NULL COMMENT '应用',
                            `scene` varchar(100) NOT NULL COMMENT '环境',
                            `processTime` varchar(100) NOT NULL COMMENT '申请时间',
                            `processId` varchar(100) COMMENT '流程实例ID',
                            `exampleName` varchar(100) COMMENT '实例名称',
                            `task` varchar(100) COMMENT '当前节点',
                            `processState` varchar(100) NOT NULL COMMENT '流程状态',
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