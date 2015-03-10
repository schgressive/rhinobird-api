CREATE TABLE `active_admin_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` varchar(255) DEFAULT NULL,
  `body` text,
  `resource_id` varchar(255) NOT NULL,
  `resource_type` varchar(255) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `author_type` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_active_admin_comments_on_namespace` (`namespace`),
  KEY `index_active_admin_comments_on_author_type_and_author_id` (`author_type`,`author_id`),
  KEY `index_active_admin_comments_on_resource_type_and_resource_id` (`resource_type`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admin_users_on_email` (`email`),
  UNIQUE KEY `index_admin_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `likes` int(11) DEFAULT NULL,
  `stream_likes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `channels_streams` (
  `channel_id` int(11) DEFAULT NULL,
  `stream_id` int(11) DEFAULT NULL,
  KEY `index_channels_streams_on_channel_id_and_stream_id` (`channel_id`,`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vj_id` int(11) DEFAULT NULL,
  `stream_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT '0',
  `track_type` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_events_on_vj_id_and_stream_id` (`vj_id`,`stream_id`)
) ENGINE=InnoDB AUTO_INCREMENT=995 DEFAULT CHARSET=latin1;

CREATE TABLE `follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `followed_user_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_follows_on_user_id_and_followed_user_id` (`user_id`,`followed_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `likeable_id` int(11) DEFAULT NULL,
  `likeable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_likes_on_user_id_and_likeable_type_and_likeable_id` (`user_id`,`likeable_type`,`likeable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `picks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stream_id` int(11) DEFAULT NULL,
  `vj_id` int(11) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0',
  `fixed_audio` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_picks_on_slug` (`slug`),
  KEY `index_picks_on_stream_id_and_vj_id` (`stream_id`,`vj_id`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `streams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `caption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hash_token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `lat` decimal(18,12) DEFAULT NULL,
  `lng` decimal(18,12) DEFAULT NULL,
  `started_on` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `thumbnail_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_file_size` int(11) DEFAULT NULL,
  `thumbnail_updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `playcount` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `stream_id` decimal(22,0) DEFAULT NULL,
  `archived_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `promoted` tinyint(1) DEFAULT '0',
  `recording_id` decimal(22,0) DEFAULT NULL,
  `fb_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `archive` tinyint(1) DEFAULT '1',
  `likes` int(11) DEFAULT '0',
  `source_id` int(11) DEFAULT NULL,
  `reposts` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_streams_on_hash_token` (`hash_token`),
  KEY `index_streams_on_user_id` (`user_id`),
  FULLTEXT KEY `caption_fulltext` (`caption`)
) ENGINE=MyISAM AUTO_INCREMENT=1168 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `timelines` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `promoted` tinyint(1) DEFAULT '0',
  `status` int(11) DEFAULT NULL,
  `repost` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1050 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fb_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `share_facebook` tinyint(1) DEFAULT '1',
  `api` tinyint(1) DEFAULT '0',
  `tw_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tw_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `share_twitter` tinyint(1) DEFAULT '0',
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custom_tweet` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enable_custom_tweet` tinyint(1) DEFAULT '0',
  `incomplete_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bio` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `background_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `background_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `background_image_file_size` int(11) DEFAULT NULL,
  `background_image_updated_at` datetime DEFAULT NULL,
  `destruction_time` datetime DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `avatar_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_image_file_size` int(11) DEFAULT NULL,
  `avatar_image_updated_at` datetime DEFAULT NULL,
  `mobile_signup` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_authentication_token` (`authentication_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_username` (`username`),
  KEY `index_users_on_slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=215 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `vjs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `archived_url` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `vj_room` varchar(255) DEFAULT NULL,
  `thumbnail_file_name` varchar(255) DEFAULT NULL,
  `thumbnail_content_type` varchar(255) DEFAULT NULL,
  `thumbnail_file_size` int(11) DEFAULT NULL,
  `thumbnail_updated_at` datetime DEFAULT NULL,
  `lat` decimal(18,12) DEFAULT NULL,
  `lng` decimal(18,12) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `likes` int(11) DEFAULT '0',
  `playcount` int(11) DEFAULT '0',
  `source_id` int(11) DEFAULT NULL,
  `reposts` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vjs_on_slug` (`slug`),
  KEY `index_vjs_on_user_id_and_channel_id` (`user_id`,`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20130408152535');

INSERT INTO schema_migrations (version) VALUES ('20130409125048');

INSERT INTO schema_migrations (version) VALUES ('20130603123720');

INSERT INTO schema_migrations (version) VALUES ('20130603183444');

INSERT INTO schema_migrations (version) VALUES ('20130604151852');

INSERT INTO schema_migrations (version) VALUES ('20130604152214');

INSERT INTO schema_migrations (version) VALUES ('20130715152907');

INSERT INTO schema_migrations (version) VALUES ('20130717111044');

INSERT INTO schema_migrations (version) VALUES ('20130731124139');

INSERT INTO schema_migrations (version) VALUES ('20130801120042');

INSERT INTO schema_migrations (version) VALUES ('20130819152632');

INSERT INTO schema_migrations (version) VALUES ('20130819195444');

INSERT INTO schema_migrations (version) VALUES ('20130821195335');

INSERT INTO schema_migrations (version) VALUES ('20130822195433');

INSERT INTO schema_migrations (version) VALUES ('20131112182134');

INSERT INTO schema_migrations (version) VALUES ('20131113125357');

INSERT INTO schema_migrations (version) VALUES ('20131127181949');

INSERT INTO schema_migrations (version) VALUES ('20140102111347');

INSERT INTO schema_migrations (version) VALUES ('20140106143022');

INSERT INTO schema_migrations (version) VALUES ('20140106144642');

INSERT INTO schema_migrations (version) VALUES ('20140110185330');

INSERT INTO schema_migrations (version) VALUES ('20140123130759');

INSERT INTO schema_migrations (version) VALUES ('20140127144727');

INSERT INTO schema_migrations (version) VALUES ('20140221184411');

INSERT INTO schema_migrations (version) VALUES ('20140224140849');

INSERT INTO schema_migrations (version) VALUES ('20140307132954');

INSERT INTO schema_migrations (version) VALUES ('20140312143101');

INSERT INTO schema_migrations (version) VALUES ('20140410135849');

INSERT INTO schema_migrations (version) VALUES ('20140421191901');

INSERT INTO schema_migrations (version) VALUES ('20140421194359');

INSERT INTO schema_migrations (version) VALUES ('20140422140406');

INSERT INTO schema_migrations (version) VALUES ('20140424151600');

INSERT INTO schema_migrations (version) VALUES ('20140425111733');

INSERT INTO schema_migrations (version) VALUES ('20140425152549');

INSERT INTO schema_migrations (version) VALUES ('20140428153400');

INSERT INTO schema_migrations (version) VALUES ('20140522215219');

INSERT INTO schema_migrations (version) VALUES ('20140522215758');

INSERT INTO schema_migrations (version) VALUES ('20140523131839');

INSERT INTO schema_migrations (version) VALUES ('20140612193331');

INSERT INTO schema_migrations (version) VALUES ('20140624185826');

INSERT INTO schema_migrations (version) VALUES ('20140709211255');

INSERT INTO schema_migrations (version) VALUES ('20140709211302');

INSERT INTO schema_migrations (version) VALUES ('20140714175945');

INSERT INTO schema_migrations (version) VALUES ('20140715124155');

INSERT INTO schema_migrations (version) VALUES ('20140715143112');

INSERT INTO schema_migrations (version) VALUES ('20140715171948');

INSERT INTO schema_migrations (version) VALUES ('20140716145434');

INSERT INTO schema_migrations (version) VALUES ('20140812185140');

INSERT INTO schema_migrations (version) VALUES ('20140813141006');

INSERT INTO schema_migrations (version) VALUES ('20140813151021');

INSERT INTO schema_migrations (version) VALUES ('20140820141105');

INSERT INTO schema_migrations (version) VALUES ('20141015154750');

INSERT INTO schema_migrations (version) VALUES ('20141020172445');

INSERT INTO schema_migrations (version) VALUES ('20141113121043');

INSERT INTO schema_migrations (version) VALUES ('20141217113404');

INSERT INTO schema_migrations (version) VALUES ('20141218141619');

INSERT INTO schema_migrations (version) VALUES ('20141224013258');

INSERT INTO schema_migrations (version) VALUES ('20141224113527');

INSERT INTO schema_migrations (version) VALUES ('20150106164925');

INSERT INTO schema_migrations (version) VALUES ('20150120140528');

INSERT INTO schema_migrations (version) VALUES ('20150121130233');

INSERT INTO schema_migrations (version) VALUES ('20150126163643');

INSERT INTO schema_migrations (version) VALUES ('20150129124313');

INSERT INTO schema_migrations (version) VALUES ('20150216173456');

INSERT INTO schema_migrations (version) VALUES ('20150216193814');

INSERT INTO schema_migrations (version) VALUES ('20150223170130');

INSERT INTO schema_migrations (version) VALUES ('20150304142008');

INSERT INTO schema_migrations (version) VALUES ('20150310130207');