CREATE TABLE `hands` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `mode` varchar(10) NOT NULL DEFAULT '',
  `start` varchar(15) NOT NULL DEFAULT '',
  `end` varchar(15) NOT NULL DEFAULT '',
  `win` varchar(10) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT '',
  `strategy` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sid` varchar(50) DEFAULT NULL,
  `displayName` varchar(80) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `provider` varchar(20) DEFAULT NULL,
  `pic` varchar(256) DEFAULT NULL,
  `classicCreds` int(11) DEFAULT '1000',
  `kiddieCreds` int(11) DEFAULT '1000',
  `trainerCreds` int(11) DEFAULT '1000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
