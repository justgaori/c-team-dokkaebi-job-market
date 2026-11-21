package com.dokkaebi.service;

import java.util.List;
import com.dokkaebi.domain.JobVO;
import com.dokkaebi.domain.JobCriteria;

public interface JobService {
    
    List<JobVO> getList(JobCriteria cri);
    
    int getTotal(JobCriteria cri);
    
    JobVO get(Long jobId);
    
    int refresh();
    
    List<String> getRegions();
    
    List<String> getJobTypes();
    
    List<String> getEmploymentTypes();
}
