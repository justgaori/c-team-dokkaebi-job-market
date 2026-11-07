package com.dokkaebi.mapper;

import com.dokkaebi.domain.MemberVO;

public interface MemberMapper {
    
    public MemberVO read(String userid);
}
