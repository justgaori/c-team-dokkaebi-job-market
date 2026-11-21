package com.dokkaebi.domain;

import lombok.Data;
import org.springframework.web.util.UriComponentsBuilder;

@Data
public class JobCriteria {
    private int pageNum = 1;
    private int amount = 10;
    private String keyword;
    private String region;
    private String jobType;
    private String employmentType;
    private String status;
    
    public int getOffset() {
        return (pageNum - 1) * amount;
    }
    
    public boolean isOngoingOnly() {
        return "ongoing".equals(status);
    }
    
    public String toQueryString() {
        return UriComponentsBuilder.newInstance()
            .queryParam("pageNum", pageNum)
            .queryParam("amount", amount)
            .queryParam("keyword", keyword == null ? "" : keyword)
            .queryParam("region", region == null ? "" : region)
            .queryParam("jobType", jobType == null ? "" : jobType)
            .queryParam("employmentType", employmentType == null ? "" : employmentType)
            .queryParam("status", status == null ? "" : status)
            .toUriString();
    }
}
