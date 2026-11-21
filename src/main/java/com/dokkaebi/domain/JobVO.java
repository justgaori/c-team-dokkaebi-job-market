package com.dokkaebi.domain;

import java.util.Date;
import java.util.List;
import lombok.Data;

@Data
public class JobVO {
    private Long jobId;
    private String source;
    private String sourceJobId;
    private String title;
    private String orgName;
    private String instCd;
    private String region;
    private String jobType;
    private String employmentType;
    private String career;
    private String education;
    private String ncsCd;
    private String ncsNm;
    private String hireTypeCd;
    private String hireTypeNm;
    private String workRgnCd;
    private String workRgnNm;
    private String recrutSe;
    private String recrutSeNm;
    private String acbgCondCd;
    private String acbgCondNm;
    private Integer hireCnt;
    private String substYn;
    private Date startDate;
    private Date endDate;
    private String url;
    private String qualifyCn;
    private String prefCn;
    private String procedureCn;
    private Date fetchedAt;
    private String detailFetched;
    
    private List<JobFileVO> files;
    
    public int getDday() {
        if (endDate == null) return -999;
        long diff = endDate.getTime() - System.currentTimeMillis();
        return (int) Math.ceil(diff / (1000.0 * 60 * 60 * 24));
    }
    
    public String getStatusText() {
        int dday = getDday();
        if (dday < 0) return "마감";
        if (dday == 0) return "오늘마감";
        return "D-" + dday;
    }
    
    public boolean isClosed() {
        return getDday() < 0;
    }
}
