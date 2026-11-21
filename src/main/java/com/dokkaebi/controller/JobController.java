package com.dokkaebi.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dokkaebi.domain.JobCriteria;
import com.dokkaebi.domain.JobPageDTO;
import com.dokkaebi.domain.JobVO;
import com.dokkaebi.service.JobService;

@Controller
@RequestMapping("/job/*")
public class JobController {
    
    private static final Logger log = LoggerFactory.getLogger(JobController.class);
    
    @Autowired
    private JobService jobService;
    
    @GetMapping("/list")
    public void list(JobCriteria cri, Model model) {
        log.info("job list: {}", cri);
        
        if (cri.getStatus() == null || cri.getStatus().isEmpty()) {
            cri.setStatus("ongoing");
        }
        
        model.addAttribute("list", jobService.getList(cri));
        
        int total = jobService.getTotal(cri);
        model.addAttribute("pageMaker", new JobPageDTO(cri, total));
        
        model.addAttribute("regions", jobService.getRegions());
        model.addAttribute("jobTypes", jobService.getJobTypes());
        model.addAttribute("employmentTypes", jobService.getEmploymentTypes());
    }
    
    @GetMapping("/get")
    public void get(@RequestParam("jobId") Long jobId, JobCriteria cri, Model model) {
        log.info("job get: {}", jobId);
        
        JobVO job = jobService.get(jobId);
        model.addAttribute("job", job);
        model.addAttribute("cri", cri);
    }
    
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PostMapping("/refresh")
    @ResponseBody
    public String refresh() {
        log.info("job refresh requested");
        int count = jobService.refresh();
        return "Refreshed " + count + " jobs";
    }
    
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/admin/refresh")
    public String adminRefresh(RedirectAttributes rttr) {
        log.info("admin job refresh");
        int count = jobService.refresh();
        rttr.addFlashAttribute("message", count + "건의 채용정보를 갱신했습니다.");
        return "redirect:/job/list";
    }
}
