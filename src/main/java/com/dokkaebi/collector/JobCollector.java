package com.dokkaebi.collector;

import java.util.List;
import com.dokkaebi.domain.JobVO;

public interface JobCollector {
    
    List<JobVO> fetchList(int pageNo, int numOfRows);
    
    JobVO fetchDetail(String sourceJobId);
    
    int getTotalCount();
    
    String getSourceName();
}
