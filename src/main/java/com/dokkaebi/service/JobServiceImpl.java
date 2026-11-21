package com.dokkaebi.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dokkaebi.collector.JobCollector;
import com.dokkaebi.domain.JobCriteria;
import com.dokkaebi.domain.JobFileVO;
import com.dokkaebi.domain.JobVO;
import com.dokkaebi.mapper.JobMapper;

@Service
public class JobServiceImpl implements JobService {
    
    private static final Logger log = LoggerFactory.getLogger(JobServiceImpl.class);
    
    @Autowired
    private JobMapper jobMapper;
    
    @Autowired
    private JobCollector jobCollector;
    
    @Override
    public List<JobVO> getList(JobCriteria cri) {
        return jobMapper.getListWithPaging(cri);
    }
    
    @Override
    public int getTotal(JobCriteria cri) {
        return jobMapper.getTotalCount(cri);
    }
    
    @Override
    @Transactional
    public JobVO get(Long jobId) {
        JobVO job = jobMapper.read(jobId);
        if (job == null) {
            return null;
        }
        
        if (!"Y".equals(job.getDetailFetched())) {
            JobVO detail = jobCollector.fetchDetail(job.getSourceJobId());
            if (detail != null) {
                job.setQualifyCn(detail.getQualifyCn());
                job.setPrefCn(detail.getPrefCn());
                job.setProcedureCn(detail.getProcedureCn());
                jobMapper.updateDetail(job);
                
                if (detail.getFiles() != null && !detail.getFiles().isEmpty()) {
                    jobMapper.deleteFilesByJobId(jobId);
                    for (JobFileVO file : detail.getFiles()) {
                        file.setJobId(jobId);
                        jobMapper.insertFile(file);
                    }
                }
            }
        }
        
        job.setFiles(jobMapper.getFilesByJobId(jobId));
        return job;
    }
    
    @Override
    @Transactional
    public int refresh() {
        log.info("Starting job refresh...");
        int totalMerged = 0;
        int pageNo = 1;
        int numOfRows = 100;
        
        try {
            List<JobVO> jobs = jobCollector.fetchList(pageNo, numOfRows);
            
            for (JobVO job : jobs) {
                try {
                    jobMapper.merge(job);
                    totalMerged++;
                } catch (Exception e) {
                    log.error("Error merging job: {}", job.getSourceJobId(), e);
                }
            }
            
            int totalCount = jobCollector.getTotalCount();
            int totalPages = (int) Math.ceil((double) totalCount / numOfRows);
            
            for (pageNo = 2; pageNo <= Math.min(totalPages, 10); pageNo++) {
                jobs = jobCollector.fetchList(pageNo, numOfRows);
                for (JobVO job : jobs) {
                    try {
                        jobMapper.merge(job);
                        totalMerged++;
                    } catch (Exception e) {
                        log.error("Error merging job: {}", job.getSourceJobId(), e);
                    }
                }
            }
            
            log.info("Job refresh completed. Total merged: {}", totalMerged);
            
        } catch (Exception e) {
            log.error("Error during job refresh", e);
        }
        
        return totalMerged;
    }
    
    @Override
    public List<String> getRegions() {
        return jobMapper.getDistinctRegions();
    }
    
    @Override
    public List<String> getJobTypes() {
        return jobMapper.getDistinctJobTypes();
    }
    
    @Override
    public List<String> getEmploymentTypes() {
        return jobMapper.getDistinctEmploymentTypes();
    }
}
