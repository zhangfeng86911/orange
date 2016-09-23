
/* Dump of table dashboard_user
# ------------------------------------------------------------*/


DROP TABLE IF EXISTS dashboard_user;

CREATE TABLE dashboard_user (
	id smallserial NOT NULL,
	username varchar(60) NOT NULL DEFAULT '' ,
	password varchar(255) NOT NULL DEFAULT '' ,
	is_admin smallint NOT NULL DEFAULT 0 ,
	create_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
	enable smallint NOT NULL DEFAULT 0 ,
	PRIMARY KEY (id),
	unique(username)
);

INSERT INTO dashboard_user (id, username, password, is_admin, create_time, enable)
VALUES
  (1,'admin','1fe832a7246fd19b7ea400a10d23d1894edfa3a5e09ee27e0c4a96eb0136763d',1,'2016-05-09 17:24:47',1);

/* Dump of table divide
# ------------------------------------------------------------*/

DROP TABLE IF EXISTS divide;

CREATE TABLE divide (
  id smallserial  NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL ,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
); 

/* Dump of table meta
# ------------------------------------------------------------*/

DROP TABLE IF EXISTS meta;

CREATE TABLE meta (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value varchar(5000) NOT NULL DEFAULT '',
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE (key)
);

/* Dump of table monitor
# ------------------------------------------------------------*/

DROP TABLE IF EXISTS monitor;

CREATE TABLE monitor (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL ,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
) ;

/* Dump of table redirect
# ------------------------------------------------------------*/

DROP TABLE IF EXISTS redirect;

CREATE TABLE redirect (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
);


/* Dump of table rewrite
# ------------------------------------------------------------*/

DROP TABLE IF EXISTS rewrite;

CREATE TABLE rewrite (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL ,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
) ;



/* Dump of table waf
 ------------------------------------------------------------*/

DROP TABLE IF EXISTS waf;

CREATE TABLE waf (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL ,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
); 




/* Dump of table basic_auth
 ------------------------------------------------------------*/

DROP TABLE IF EXISTS basic_auth;

CREATE TABLE basic_auth (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL, 
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
) ;




/* Dump of table key_auth
 ------------------------------------------------------------*/

DROP TABLE IF EXISTS key_auth;

CREATE TABLE key_auth (
  id smallserial NOT NULL ,
  key varchar(255) NOT NULL DEFAULT '',
  value json NOT NULL ,
  op_time timestamp NULL DEFAULT CURRENT_TIMESTAMP(0)::TIMESTAMP ,
  PRIMARY KEY (id),
  UNIQUE(key)
) ;

/*创建替换函数*/
create or replace function replace_meta_value(k text, v text) returns boolean as
$$ 
begin 
	loop 
		update meta set value = v where key = k; 
		if found then
			return true; 
		end if; 

		begin 
			insert into meta(key,value) values (k, v); 
			return true; 
			exception when unique_violation  then
				return false;

		end; 

	end loop; 
end; 
$$ 
language plpgsql;



