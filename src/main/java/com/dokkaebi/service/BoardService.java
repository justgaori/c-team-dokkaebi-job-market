package com.dokkaebi.service;

import java.util.List;

import com.dokkaebi.domain.BoardVO;
import com.dokkaebi.domain.Criteria;

public interface BoardService {
    
    public void register(BoardVO board);
    
    public BoardVO get(Long bno);
    
    public boolean modify(BoardVO board);
    
    public boolean remove(Long bno);
    
    public List<BoardVO> getList(Criteria cri);
    
    public int getTotal(Criteria cri);
}
