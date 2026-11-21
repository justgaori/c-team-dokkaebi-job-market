package com.dokkaebi.collector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.dokkaebi.service.JobService;

@Component
public class JobRefreshScheduler {

    private static final Logger log = LoggerFactory.getLogger(JobRefreshScheduler.class);

    @Autowired
    private JobService jobService;

    /** 하루 2회(09:00, 18:00) 잡알리오 목록 갱신 */
    @Scheduled(cron = "0 0 9,18 * * *")
    public void refreshTwiceDaily() {
        log.info("Scheduled job refresh started");
        try {
            int count = jobService.refresh();
            log.info("Scheduled job refresh done: {} jobs", count);
        } catch (Exception e) {
            log.error("Scheduled job refresh failed", e);
        }
    }
}
