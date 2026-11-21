-- 채용정보 테이블 스키마 (Oracle XE)
-- 출처: 잡알리오(공공데이터포털) API

-- 시퀀스
CREATE SEQUENCE seq_tbl_job START WITH 1 INCREMENT BY 1 NOCACHE;

-- 채용공고 테이블
CREATE TABLE tbl_job (
    job_id          NUMBER          PRIMARY KEY,
    source          VARCHAR2(20)    DEFAULT 'ALIO' NOT NULL,
    source_job_id   VARCHAR2(50)    NOT NULL,
    title           VARCHAR2(500)   NOT NULL,
    org_name        VARCHAR2(200),
    inst_cd         VARCHAR2(50),
    region          VARCHAR2(100),
    job_type        VARCHAR2(200),
    employment_type VARCHAR2(100),
    career          VARCHAR2(100),
    education       VARCHAR2(200),
    ncs_cd          VARCHAR2(500),
    ncs_nm          VARCHAR2(1000),
    hire_type_cd    VARCHAR2(200),
    hire_type_nm    VARCHAR2(500),
    work_rgn_cd     VARCHAR2(100),
    work_rgn_nm     VARCHAR2(200),
    recrut_se       VARCHAR2(20),
    recrut_se_nm    VARCHAR2(50),
    acbg_cond_cd    VARCHAR2(200),
    acbg_cond_nm    VARCHAR2(500),
    hire_cnt        NUMBER,
    subst_yn        CHAR(1),
    start_date      DATE,
    end_date        DATE,
    url             VARCHAR2(1000),
    qualify_cn      CLOB,
    pref_cn         CLOB,
    procedure_cn    CLOB,
    fetched_at      TIMESTAMP       DEFAULT SYSTIMESTAMP,
    detail_fetched  CHAR(1)         DEFAULT 'N',
    CONSTRAINT uk_job_source UNIQUE (source, source_job_id)
);

CREATE INDEX idx_job_end_date ON tbl_job(end_date);
CREATE INDEX idx_job_org_name ON tbl_job(org_name);
CREATE INDEX idx_job_title ON tbl_job(title);

-- 첨부파일 테이블
CREATE TABLE tbl_job_file (
    file_id         NUMBER          PRIMARY KEY,
    job_id          NUMBER          NOT NULL,
    file_no         NUMBER,
    sort_no         NUMBER,
    file_name       VARCHAR2(500),
    file_type       VARCHAR2(20),
    file_url        VARCHAR2(1000),
    CONSTRAINT fk_job_file FOREIGN KEY (job_id) REFERENCES tbl_job(job_id) ON DELETE CASCADE
);

CREATE SEQUENCE seq_tbl_job_file START WITH 1 INCREMENT BY 1 NOCACHE;

CREATE INDEX idx_job_file_job_id ON tbl_job_file(job_id);

COMMENT ON TABLE tbl_job IS '채용공고 정보 (잡알리오 API)';
COMMENT ON COLUMN tbl_job.source IS '데이터 출처 (ALIO 등)';
COMMENT ON COLUMN tbl_job.source_job_id IS '출처별 고유 ID (recrutPblntSn)';
COMMENT ON COLUMN tbl_job.detail_fetched IS '상세 정보 조회 여부 (Y/N)';
COMMENT ON COLUMN tbl_job.subst_yn IS '대체인력 여부';

COMMENT ON TABLE tbl_job_file IS '채용공고 첨부파일';
COMMENT ON COLUMN tbl_job_file.file_type IS '파일 유형 (A:공고문, B:입사지원서, C:직무기술서)';
