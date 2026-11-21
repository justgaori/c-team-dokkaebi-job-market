package com.dokkaebi.domain;

import lombok.Data;

@Data
public class JobFileVO {
    private Long fileId;
    private Long jobId;
    private Integer fileNo;
    private Integer sortNo;
    private String fileName;
    private String fileType;
    private String fileUrl;
    
    public String getFileTypeText() {
        if (fileType == null) return "";
        switch (fileType) {
            case "A": return "공고문";
            case "B": return "입사지원서";
            case "C": return "직무기술서";
            default: return fileType;
        }
    }
}
