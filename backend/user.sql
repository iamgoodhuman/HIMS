`hims`CREATE TABLE `users` (
  `user_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户唯一ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `email` VARCHAR(100) NOT NULL COMMENT '邮箱（用于登录和通知）',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '加密后的密码',
  `timezone` VARCHAR(50) NOT NULL DEFAULT 'Asia/Shanghai' COMMENT '用户时区',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';
-- 2. 日历/分类表
CREATE TABLE `calendars` (
  `calendar_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日历唯一ID',
  `owner_id` BIGINT NOT NULL COMMENT '创建者ID（关联users.user_id）',
  `name` VARCHAR(50) NOT NULL COMMENT '日历名称（如：家庭事件、保险与还款）',
  `color` VARCHAR(20) NOT NULL COMMENT '颜色标识（如：#F56C6C）',
  `is_default` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否为系统默认日历：0否，1是',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`calendar_id`),
  KEY `idx_owner_id` (`owner_id`),
  CONSTRAINT `fk_cal_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='日历/分类表';
-- 3. 事件表
CREATE TABLE `events` (
  `event_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '事件唯一ID',
  `calendar_id` BIGINT NOT NULL COMMENT '所属日历ID（决定颜色和分类）',
  `creator_id` BIGINT NOT NULL COMMENT '事件创建人ID',
  `title` VARCHAR(100) NOT NULL COMMENT '事件标题',
  `description` TEXT NULL COMMENT '事件备注/描述',
  `location` VARCHAR(100) NULL COMMENT '地点',
  `start_time` DATETIME NOT NULL COMMENT '开始时间（UTC时间）',
  `end_time` DATETIME NOT NULL COMMENT '结束时间（UTC时间）',
  `is_all_day` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否全天事件：0否，1是',
  `recurrence_rule` VARCHAR(255) NULL COMMENT '循环规则（iCalendar RFC 5545标准，如 FREQ=WEEKLY;BYDAY=WE）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`event_id`),
  -- 核心查询索引：用于快速拉取某日历下指定时间范围内的事件
  KEY `idx_calendar_time` (`calendar_id`, `start_time`, `end_time`),
  CONSTRAINT `fk_event_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `calendars` (`calendar_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_event_creator` FOREIGN KEY (`creator_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='日历事件表';
-- 4. 日历共享权限表
CREATE TABLE `calendar_shares` (
  `share_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '共享记录ID',
  `calendar_id` BIGINT NOT NULL COMMENT '被共享的日历ID',
  `shared_with_user_id` BIGINT NOT NULL COMMENT '接收共享的用户ID',
  `permission_level` ENUM('VIEWER', 'EDITOR') NOT NULL DEFAULT 'VIEWER' COMMENT '权限级别：VIEWER仅查看，EDITOR可编辑',
  `status` ENUM('PENDING', 'ACCEPTED', 'REJECTED') NOT NULL DEFAULT 'ACCEPTED' COMMENT '共享状态：待接受/已接受/已拒绝',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`share_id`),
  -- 唯一约束：防止同一日历重复共享给同一用户
  UNIQUE KEY `uk_calendar_user` (`calendar_id`, `shared_with_user_id`),
  CONSTRAINT `fk_share_calendar` FOREIGN KEY (`calendar_id`) REFERENCES `calendars` (`calendar_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_share_user` FOREIGN KEY (`shared_with_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COMMENT='日历共享权限表';


INSERT INTO users(username,email,password_hash)
VALUES ("123","123","123@qq.com")

SELECT * FROM users


ALTER TABLE users MODIFY COLUMN user_id VARCHAR(36) NOT NULL;


CREATE TABLE `tasks` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    
    `task_title` VARCHAR(255) NOT NULL COMMENT '任务标题',
    `task_description` TEXT NULL COMMENT '任务描述',
    
    `start_time` DATETIME NULL COMMENT '开始时间',
    `end_time` DATETIME NULL COMMENT '结束时间',
    
    `creator_id` BIGINT NULL COMMENT '创建人ID (关联用户表)',
    `finisher_id` BIGINT NULL COMMENT '完成人ID (关联用户表)',
    `abandoner_id` BIGINT NULL COMMENT '放弃人ID (关联用户表)',
    
    `is_deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除：0-未删除，1-已删除',
    
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
    
    PRIMARY KEY (`id`),
    INDEX `idx_creator_id` (`creator_id`),
    INDEX `idx_create_time` (`create_time`)
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='任务信息表';

SELECT * FROM tasks


INSERT INTO tasks(

)
















