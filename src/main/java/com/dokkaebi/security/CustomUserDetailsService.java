package com.dokkaebi.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.dokkaebi.domain.MemberVO;
import com.dokkaebi.mapper.MemberMapper;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private MemberMapper memberMapper;
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        log.warn("Load User By UserName: " + username);
        
        MemberVO vo = memberMapper.read(username);
        
        log.warn("queried by member mapper: " + vo);
        
        if (vo == null) {
            throw new UsernameNotFoundException("User not found: " + username);
        }
        
        return new CustomUser(vo);
    }
}
