
CREATE TABLE IF NOT EXISTS `ms_drive` (
  `drive_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文档库ID',
  `drive_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文档库名称',
  `drive_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文档库类型',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `mapping_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '映射状态',
  `owner_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'drive所有者',
  `source` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '来源',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uk_drive` (`drive_id`),
  KEY `idx_site` (`owner_id`),
  KEY `idx_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='微软文档库';

CREATE TABLE IF NOT EXISTS `ms_drive_item` (
  `create_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `creator` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '创建人ID',
  `download_path` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件下载地址',
  `download_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件下载状态',
  `drive_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文档库ID',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `item_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件ID',
  `item_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `item_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '文件ID',
  `last_modify_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '最后一次修改时间',
  `local_path` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '本地路径',
  `mapping_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '映射状态',
  `parent_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '父节点ID',
  `permission_scan_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限扫描状态',
  `reason` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `size` bigint(20) NOT NULL DEFAULT '0' COMMENT '文件大小',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  `change_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '变更类型',
  `fhash` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'MS文件内容哈希值',
  `batch_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '批次ID（企业级别全局流水号）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uk_drive_item_id` (`drive_id`,`item_id`),
  KEY `idx_creator` (`creator`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_task` (`task_id`),
  KEY `idx_task_download_status` (`task_id`, `download_status`),
  KEY `idx_task_batch_download_status` (`task_id`, `batch_id`, `download_status`),
  KEY `idx_batch_id` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='微软文档库文件';

-- 创建 ms_drive_item 分表 (00-31)
CREATE TABLE IF NOT EXISTS `ms_drive_item_00` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_01` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_02` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_03` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_04` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_05` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_06` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_07` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_08` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_09` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_10` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_11` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_12` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_13` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_14` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_15` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_16` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_17` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_18` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_19` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_20` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_21` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_22` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_23` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_24` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_25` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_26` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_27` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_28` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_29` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_30` LIKE `ms_drive_item`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_31` LIKE `ms_drive_item`;

CREATE TABLE IF NOT EXISTS `ms_drive_item_permission` (
  `ctime` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `file_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件ID',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `mtime` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `permission_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '微软权限ID',
  `prevents_download` tinyint(1) NOT NULL DEFAULT '0' COMMENT '禁止下载',
  `range` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '授权范围:user',
  `role` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角色:read,write,owner',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  `user_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '用户ID',
  PRIMARY KEY (`id`),
  KEY `idx_file` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='微软文件权限';

-- 2.2 创建 ms_drive_item_permission 分表 (00-31)
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_00` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_01` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_02` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_03` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_04` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_05` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_06` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_07` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_08` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_09` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_10` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_11` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_12` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_13` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_14` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_15` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_16` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_17` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_18` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_19` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_20` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_21` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_22` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_23` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_24` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_25` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_26` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_27` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_28` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_29` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_30` LIKE `ms_drive_item_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_permission_31` LIKE `ms_drive_item_permission`;

CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission` (
  `ctime` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `file_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件ID',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `mtime` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `raw` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限原始信息',
  PRIMARY KEY (`id`),
  KEY `idx_file` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='微软原始文件权限';

-- 创建 ms_drive_item_raw_permission 分表 (00-31)
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_00` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_01` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_02` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_03` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_04` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_05` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_06` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_07` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_08` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_09` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_10` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_11` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_12` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_13` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_14` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_15` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_16` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_17` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_18` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_19` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_20` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_21` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_22` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_23` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_24` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_25` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_26` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_27` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_28` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_29` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_30` LIKE `ms_drive_item_raw_permission`;
CREATE TABLE IF NOT EXISTS `ms_drive_item_raw_permission_31` LIKE `ms_drive_item_raw_permission`;

CREATE TABLE IF NOT EXISTS `ms_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '团队ID',
  `display_name` varchar(1024) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '团队ID',
  `creator` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '团队名称',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='团队';

CREATE TABLE IF NOT EXISTS `ms_group_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '团队ID',
  `user_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '成员ID',
  `role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '成员名称',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_gid_uid` (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='团队成员';

CREATE TABLE IF NOT EXISTS `ms_site` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点ID',
  `site_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点ID',
  `display_name` varchar(1024) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点名称',
  `last_modify_time` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '站点名称',
  `web_url` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点URL',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '关联的任务ID',
  `scan_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点扫描状态',
  `mapping_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点映射状态',
  `member_scan_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点成员扫描状态',
  `member_mapping_status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点成员映射状态',
  `folder_commit_status` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '目录提交状态',
  `file_migrate_status` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '迁移状态',
  `reason` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '站点失败原因',
  PRIMARY KEY (`id`),
  KEY `idx_gid_sid` (`group_id`,`site_id`),
  KEY `idx_sid` (`site_id`),
  KEY `idx_url` (`web_url`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='站点';

CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `third_union_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '第三方平台用户ID',
  `third_mail` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '第三方平台用户名称',
  `third_name` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '第三方平台用户名称',
  `third_extra` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '扩展配置信息（JSON 格式字符串）',
  `wps_user_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'WPS用户ID',
  `wps_company_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'WPS侧用户所在企业ID',
  `wps_user_name` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'WPS用户名称',
  `wps_role` bigint(20) NOT NULL DEFAULT '0' COMMENT 'WPS侧用户角色',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '关联的任务ID',
  `scan_status` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '账号扫描状态',
  `mapping_status` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '账号映射状态',
  `active_status` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '账号激活状态',
  `folder_commit_status` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '目录提交状态',
  `file_migrate_status` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '迁移状态',
  `reason` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '账号映射失败原因',
  `user_id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'WPS全局用户ID',
  PRIMARY KEY (`id`),
  KEY `idx_third_union_id` (`third_union_id`),
  KEY `idx_wps_user` (`wps_user_id`),
  KEY `idx_third_mail` (`third_mail`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='用户';

  CREATE TABLE IF NOT EXISTS `migrate_stat_entity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  `batch_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '批次ID（企业级别全局流水号）',
  `step_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '步骤名称',
  `entity_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '实体类型: user/site',
  `entity_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '实体ID（用户third_union_id或站点site_id）',
  `metrics_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '指标名称',
  `metrics_val` bigint(20) NOT NULL DEFAULT '0' COMMENT '指标值',
  `created_at` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated_at` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uk_entity_metrics` (`task_id`,`batch_id`,`step_name`,`entity_id`,`metrics_name`),
  KEY `idx_task_batch_type` (`task_id`,`batch_id`,`entity_type`),
  KEY `idx_entity` (`entity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='迁移统计表-实体级别（用户/站点）';

CREATE TABLE IF NOT EXISTS `wps_file` (
  `creator` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS创建者',
  `ctime` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `file_id` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS文件ID',
  `file_local_path` varchar(500) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '文件本地路径',
  `file_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS文件名称',
  `group_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '团队ID（wps_group主键）',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `is_folder` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为文件夹',
  `last_modify_time` bigint(20) NOT NULL DEFAULT '0' COMMENT '文件最近更新时间',
  `wps_upload_time` bigint(20) NOT NULL DEFAULT 0 COMMENT 'WPS文件上传成功后的修改时间',
  `mtime` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `reason` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '失败原因',
  `share_link` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS文件分享链接',
  `sid` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS文件分享链接SID',
  `size` bigint(20) NOT NULL DEFAULT '0' COMMENT '文件大小',
  `status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  `third_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '第三方唯一标识',
  `third_parent_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '父级，第三方唯一标识',
  `fhash` varchar(64) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS文件内容哈希值',
  `batch_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '批次ID',
  PRIMARY KEY (`id`),
  KEY `idx_file_id` (`file_id`),
  KEY `idx_status` (`status`),
  KEY `idx_third` (`third_id`),
  KEY `idx_third_parent` (`third_parent_id`),
  KEY `idx_task_status` (`task_id`,`status`),
  KEY `idx_batch_id` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='wps文件';

-- 批量创建分表
CREATE TABLE IF NOT EXISTS `wps_file_00` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_01` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_02` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_03` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_04` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_05` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_06` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_07` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_08` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_09` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_10` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_11` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_12` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_13` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_14` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_15` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_16` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_17` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_18` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_19` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_20` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_21` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_22` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_23` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_24` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_25` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_26` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_27` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_28` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_29` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_30` LIKE `wps_file`;
CREATE TABLE IF NOT EXISTS `wps_file_31` LIKE `wps_file`;


CREATE TABLE IF NOT EXISTS `wps_file_permission` (
  `ctime` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `file_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '文件ID（文件的主键）',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `mtime` bigint(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
  `permission` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '权限:read,write',
  `range` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '授权范围:user',
  `status` varchar(20) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '状态',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务id',
  `batch_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '批次ID',
  `third_file_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '第三方文件唯一标识',
  `third_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '第三方唯一标识',
  `user_id` varchar(100) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS用户ID',
  PRIMARY KEY (`id`),
  KEY `idx_third` (`third_id`),
  KEY `idx_file` (`file_id`),
  KEY `idx_task_status` (`task_id`,`status`),
  KEY `idx_third_file_id` (`third_file_id`),
  KEY `idx_batch_id` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='wps文件权限';

-- 创建 wps_file_permission 分表 (00-31)
CREATE TABLE IF NOT EXISTS `wps_file_permission_00` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_01` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_02` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_03` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_04` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_05` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_06` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_07` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_08` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_09` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_10` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_11` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_12` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_13` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_14` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_15` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_16` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_17` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_18` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_19` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_20` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_21` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_22` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_23` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_24` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_25` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_26` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_27` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_28` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_29` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_30` LIKE `wps_file_permission`;
CREATE TABLE IF NOT EXISTS `wps_file_permission_31` LIKE `wps_file_permission`;

CREATE TABLE IF NOT EXISTS `wps_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '团队ID',
  `drive_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '驱动盘ID',
  `type` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '第三方平台ID',
  `creator` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '团队创建者ID',
  `name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '团队名称',
  `third_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '团队描述',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '团队成员数量',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
  `task_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '关联的任务ID',
  `commit_status` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '团队创建状态',
  `member_commit_status` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '团队成员创建状态',
  PRIMARY KEY (`id`),
  KEY `idx_third_id` (`third_id`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='WPS团队';

CREATE TABLE IF NOT EXISTS `wps_group_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `group_pk_id` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'wps_group表的id',
  `user_id` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS团队ID',
  `role` varchar(255) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'WPS团队成员角色',
  `created_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'WPS团队成员名称',
  `updated_at` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'WPS团队成员名称',
  PRIMARY KEY (`id`),
  KEY `idx_gid_uid` (`group_pk_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='WPS团队成员';

CREATE TABLE IF NOT EXISTS `migrate_report_detail` (
    `company_id` BIGINT(20) NOT NULL DEFAULT '0' COMMENT '企业id',
    `created_at` BIGINT(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `entity_id` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '实体id',
    `entity_type` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '实体类型',
    `file_key` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '文件存储key',
    `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id',
    `local_path` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '本地地址',
    `notify_status` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '通知状态',
    `report_id` BIGINT(20) NOT NULL DEFAULT '0' COMMENT '报告任务id',
    `report_type` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '报告类型',
    `status` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '状态',
    `updated_at` BIGINT(20) NOT NULL DEFAULT '0' COMMENT '修改时间',
    `wps_file_id` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '文件id',
    PRIMARY KEY (id),
    INDEX idx_entity(report_id,entity_id)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT '报告明细表';

CREATE TABLE IF NOT EXISTS `migrate_import_task_detail` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `import_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '导入任务id',
    `biz_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '业务id,可以是user_id,ms_site_id,import_user_id,import_dept_id',
    `biz_type` varchar(50)  NOT NULL DEFAULT '' COMMENT '业务类型(user/site/import_user/import_dept)',
    `biz_name` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '名称',
    `addr` VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '地址/邮箱',
    PRIMARY KEY (`id`),
    KEY `idx_import_id` (`import_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci  COMMENT='迁移范围数据导入任务详情临时表';

CREATE TABLE IF NOT EXISTS `migrate_import_task` (
    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `company_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '企业ID',
    `project_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '项目ID',
    `batch_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '任务批次id',
    `import_type` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '导入类型：onedrive，sharepoint',
    `status` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '状态',
    `failed_reason` VARCHAR(512) NOT NULL DEFAULT '' COMMENT '失败原因',
    `created_at` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
    `updated_at` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_uk_company_project_id` (`company_id`,`project_id`),
    UNIQUE KEY `idx_uk_batch_id` (`batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='迁移范围数据导入任务';
