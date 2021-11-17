-- +migrate Up
CREATE TABLE `restaurant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25000 DEFAULT CHARSET=utf8;

-- +migrate Down
DROP TABLE IF EXISTS restaurant;
