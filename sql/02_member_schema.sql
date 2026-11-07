-- ============================================
-- Member Schema for Dokkaebi Job Market
-- Execute with book_ex user
-- Version: 1.0 (Member & Security)
-- ============================================

-- Member table
CREATE TABLE tbl_member (
    userid      VARCHAR2(50)     PRIMARY KEY,
    userpw      VARCHAR2(100)    NOT NULL,
    username    VARCHAR2(100)    NOT NULL,
    regdate     DATE             DEFAULT SYSDATE,
    updatedate  DATE             DEFAULT SYSDATE,
    enabled     CHAR(1)          DEFAULT '1'
);

-- Member authority table
CREATE TABLE tbl_member_auth (
    userid      VARCHAR2(50)     NOT NULL,
    auth        VARCHAR2(50)     NOT NULL,
    CONSTRAINT fk_member_auth FOREIGN KEY(userid) REFERENCES tbl_member(userid)
);

-- Index
CREATE INDEX idx_member_auth_userid ON tbl_member_auth(userid);

-- Remember-me persistent_logins (Spring Security)
CREATE TABLE persistent_logins (
    username    VARCHAR2(64)     NOT NULL,
    series      VARCHAR2(64)     PRIMARY KEY,
    token       VARCHAR2(64)     NOT NULL,
    last_used   TIMESTAMP        NOT NULL
);

-- Sample admin user (password: admin123 - BCrypt encoded)
-- Note: Generate actual BCrypt hash using encoder
INSERT INTO tbl_member (userid, userpw, username, enabled) 
VALUES ('admin', '$2a$10$qwH3O6lEa7d2LvzwKsHwAeQJCkKGlO7YS7k7n7Ef7FS7Sz5X7RhFi', '관리자', '1');

INSERT INTO tbl_member_auth (userid, auth) VALUES ('admin', 'ROLE_ADMIN');
INSERT INTO tbl_member_auth (userid, auth) VALUES ('admin', 'ROLE_MEMBER');

-- Sample regular user (password: user123 - BCrypt encoded)
INSERT INTO tbl_member (userid, userpw, username, enabled) 
VALUES ('user1', '$2a$10$qwH3O6lEa7d2LvzwKsHwAeQJCkKGlO7YS7k7n7Ef7FS7Sz5X7RhFi', '홍길동', '1');

INSERT INTO tbl_member_auth (userid, auth) VALUES ('user1', 'ROLE_MEMBER');

COMMIT;
