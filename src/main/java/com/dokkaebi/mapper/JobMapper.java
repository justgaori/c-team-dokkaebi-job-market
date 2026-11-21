package com.dokkaebi.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.dokkaebi.domain.JobVO;
import com.dokkaebi.domain.JobFileVO;
import com.dokkaebi.domain.JobCriteria;

public interface JobMapper {
    
    List<JobVO> getListWithPaging(JobCriteria cri);
    
    int getTotalCount(JobCriteria cri);
    
    JobVO read(@Param("jobId") Long jobId);
    
    JobVO readBySourceId(@Param("source") String source, @Param("sourceJobId") String sourceJobId);
    
    int insert(JobVO job);
    
    int update(JobVO job);
    
    int updateDetail(JobVO job);
    
    int merge(JobVO job);
    
    int insertFile(JobFileVO file);
    
    int deleteFilesByJobId(@Param("jobId") Long jobId);
    
    List<JobFileVO> getFilesByJobId(@Param("jobId") Long jobId);
    
    List<String> getDistinctRegions();
    
    List<String> getDistinctJobTypes();
    
    List<String> getDistinctEmploymentTypes();
}
