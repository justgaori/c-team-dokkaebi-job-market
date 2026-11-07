-- ============================================
-- Board Schema for Dokkaebi Job Market
-- Execute with book_ex user
-- Version: 1.0 (FUN-002 Board CRUD)
-- ============================================

-- Board sequence
CREATE SEQUENCE seq_board;

-- Board table
CREATE TABLE tbl_board (
    bno         NUMBER(10,0)     PRIMARY KEY,
    title       VARCHAR2(200)    NOT NULL,
    content     CLOB             NOT NULL,
    writer      VARCHAR2(50)     NOT NULL,
    regdate     DATE             DEFAULT SYSDATE,
    updatedate  DATE             DEFAULT SYSDATE,
    replycnt    NUMBER           DEFAULT 0
);

-- Index for performance
CREATE INDEX idx_board_regdate ON tbl_board(regdate DESC);
CREATE INDEX idx_board_writer ON tbl_board(writer);

-- Sample data (optional, for testing)
INSERT INTO tbl_board (bno, title, content, writer)
VALUES (seq_board.NEXTVAL, '테스트 게시글 1', '테스트 내용입니다.', 'admin');

INSERT INTO tbl_board (bno, title, content, writer)
VALUES (seq_board.NEXTVAL, '테스트 게시글 2', '두 번째 테스트 내용입니다.', 'user1');

COMMIT;
