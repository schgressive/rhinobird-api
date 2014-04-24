CREATE TABLE `channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `channels_streams` (
  `channel_id` int(11) DEFAULT NULL,
  `stream_id` int(11) DEFAULT NULL,
  KEY `index_channels_streams_on_channel_id_and_stream_id` (`channel_id`,`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `picks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stream_id` int(11) DEFAULT NULL,
  `vj_id` int(11) DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0',
  `active_audio` tinyint(1) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_picks_on_slug` (`slug`),
  KEY `index_picks_on_stream_id_and_vj_id` (`stream_id`,`vj_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_streams_on_hash_token` (`hash_token`),
  KEY `index_streams_on_user_id` (`user_id`),
  FULLTEXT KEY `caption_fulltext` (`caption`)
) ENGINE=MyISAM AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `streams_tags` (
  `tag_id` int(11) DEFAULT NULL,
  `stream_id` int(11) DEFAULT NULL,
  KEY `index_streams_tags_on_tag_id` (`tag_id`),
  KEY `index_streams_tags_on_stream_id` (`stream_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `share_facebook` tinyint(1) DEFAULT NULL,
  `tw_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tw_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `share_twitter` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_authentication_token` (`authentication_token`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `vjs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `archived_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_vjs_on_slug` (`slug`),
  KEY `index_vjs_on_user_id_and_channel_id` (`user_id`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

INSERT INTO schema_migrations (version) VALUES ('20140414150701');

INSERT INTO schema_migrations (version) VALUES ('20140421191901');

INSERT INTO schema_migrations (version) VALUES ('20140421194359');

INSERT INTO schema_migrations (version) VALUES ('20140422140406');

INSERT INTO schema_migrations (version) VALUES ('20140424151600');