package com.dokkaebi.collector;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.dokkaebi.domain.JobFileVO;
import com.dokkaebi.domain.JobVO;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class AlioJobCollector implements JobCollector {
    
    private static final Logger log = LoggerFactory.getLogger(AlioJobCollector.class);
    private static final String BASE_URL = "https://apis.data.go.kr/1051000/recruitment";
    private static final String SOURCE = "ALIO";
    
    @Value("${alio.serviceKey:}")
    private String serviceKey;
    
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    
    private int lastTotalCount = 0;
    
    public AlioJobCollector() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }
    
    @Override
    public String getSourceName() {
        return SOURCE;
    }
    
    @Override
    public int getTotalCount() {
        return lastTotalCount;
    }
    
    @Override
    @SuppressWarnings("unchecked")
    public List<JobVO> fetchList(int pageNo, int numOfRows) {
        List<JobVO> jobs = new ArrayList<>();
        
        if (serviceKey == null || serviceKey.isEmpty()) {
            log.warn("alio.serviceKey not configured");
            return jobs;
        }
        
        try {
            String url = UriComponentsBuilder.fromHttpUrl(BASE_URL + "/list")
                .queryParam("serviceKey", serviceKey)
                .queryParam("resultType", "json")
                .queryParam("numOfRows", numOfRows)
                .queryParam("pageNo", pageNo)
                .queryParam("ongoingYn", "Y")
                .build(false)
                .toUriString();
            
            log.info("Fetching job list: pageNo={}, numOfRows={}", pageNo, numOfRows);
            
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            Map<String, Object> body = objectMapper.readValue(response.getBody(), Map.class);
            
            Integer resultCode = (Integer) body.get("resultCode");
            if (resultCode == null || resultCode != 200) {
                log.error("API error: {}", body.get("resultMsg"));
                return jobs;
            }
            
            Object totalObj = body.get("totalCount");
            if (totalObj != null) {
                lastTotalCount = totalObj instanceof Integer ? (Integer) totalObj : Integer.parseInt(totalObj.toString());
            }
            
            List<Map<String, Object>> results = (List<Map<String, Object>>) body.get("result");
            if (results == null) {
                return jobs;
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            
            for (Map<String, Object> item : results) {
                JobVO job = new JobVO();
                job.setSource(SOURCE);
                job.setSourceJobId(String.valueOf(item.get("recrutPblntSn")));
                job.setTitle((String) item.get("recrutPbancTtl"));
                job.setOrgName((String) item.get("instNm"));
                job.setInstCd((String) item.get("pblntInstCd"));
                job.setNcsCd((String) item.get("ncsCdLst"));
                job.setNcsNm((String) item.get("ncsCdNmLst"));
                job.setHireTypeCd((String) item.get("hireTypeLst"));
                job.setHireTypeNm((String) item.get("hireTypeNmLst"));
                job.setWorkRgnCd((String) item.get("workRgnLst"));
                job.setWorkRgnNm((String) item.get("workRgnNmLst"));
                job.setRecrutSe((String) item.get("recrutSe"));
                job.setRecrutSeNm((String) item.get("recrutSeNm"));
                job.setAcbgCondCd((String) item.get("acbgCondLst"));
                job.setAcbgCondNm((String) item.get("acbgCondNmLst"));
                
                Object nope = item.get("recrutNope");
                if (nope != null) {
                    job.setHireCnt(nope instanceof Integer ? (Integer) nope : Integer.parseInt(nope.toString()));
                }
                
                job.setSubstYn("Y".equals(item.get("replmprYn")) ? "Y" : "N");
                job.setUrl((String) item.get("srcUrl"));
                
                String startStr = (String) item.get("pbancBgngYmd");
                String endStr = (String) item.get("pbancEndYmd");
                if (startStr != null && startStr.length() == 8) {
                    job.setStartDate(sdf.parse(startStr));
                }
                if (endStr != null && endStr.length() == 8) {
                    job.setEndDate(sdf.parse(endStr));
                }
                
                jobs.add(job);
            }
            
            log.info("Fetched {} jobs (total: {})", jobs.size(), lastTotalCount);
            
        } catch (Exception e) {
            log.error("Error fetching job list", e);
        }
        
        return jobs;
    }
    
    @Override
    @SuppressWarnings("unchecked")
    public JobVO fetchDetail(String sourceJobId) {
        if (serviceKey == null || serviceKey.isEmpty()) {
            log.warn("alio.serviceKey not configured");
            return null;
        }
        
        try {
            String url = UriComponentsBuilder.fromHttpUrl(BASE_URL + "/detail")
                .queryParam("serviceKey", serviceKey)
                .queryParam("resultType", "json")
                .queryParam("sn", sourceJobId)
                .build(false)
                .toUriString();
            
            log.info("Fetching job detail: sn={}", sourceJobId);
            
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            Map<String, Object> body = objectMapper.readValue(response.getBody(), Map.class);
            
            Integer resultCode = (Integer) body.get("resultCode");
            if (resultCode == null || resultCode != 200) {
                log.error("API error: {}", body.get("resultMsg"));
                return null;
            }
            
            Map<String, Object> result = (Map<String, Object>) body.get("result");
            if (result == null) {
                return null;
            }
            
            JobVO job = new JobVO();
            job.setSource(SOURCE);
            job.setSourceJobId(sourceJobId);
            job.setQualifyCn((String) result.get("aplyQlfcCn"));
            job.setPrefCn((String) result.get("prefCn"));
            job.setProcedureCn((String) result.get("scrnprcdrMthdExpln"));
            
            List<Map<String, Object>> files = (List<Map<String, Object>>) result.get("files");
            if (files != null && !files.isEmpty()) {
                List<JobFileVO> fileList = new ArrayList<>();
                for (Map<String, Object> f : files) {
                    JobFileVO file = new JobFileVO();
                    Object fileNo = f.get("recrutAtchFileNo");
                    if (fileNo != null) {
                        file.setFileNo(fileNo instanceof Integer ? (Integer) fileNo : Integer.parseInt(fileNo.toString()));
                    }
                    Object sortNo = f.get("sortNo");
                    if (sortNo != null) {
                        file.setSortNo(sortNo instanceof Integer ? (Integer) sortNo : Integer.parseInt(sortNo.toString()));
                    }
                    file.setFileName((String) f.get("atchFileNm"));
                    file.setFileType((String) f.get("atchFileType"));
                    file.setFileUrl((String) f.get("url"));
                    fileList.add(file);
                }
                job.setFiles(fileList);
            }
            
            log.info("Fetched detail for job: {}", sourceJobId);
            return job;
            
        } catch (Exception e) {
            log.error("Error fetching job detail: {}", sourceJobId, e);
            return null;
        }
    }
}
