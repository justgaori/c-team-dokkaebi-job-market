package com.dokkaebi.mapper;

import java.util.List;

import com.dokkaebi.domain.BoardVO;
import com.dokkaebi.domain.Criteria;

public interface BoardMapper {
    
    public List<BoardVO> getList();
    
    public List<BoardVO> getListWithPaging(Criteria cri);
    
    public void insert(BoardVO board);
    
    public void insertSelectKey(BoardVO board);
    
    public BoardVO read(Long bno);
    
    public int delete(Long bno);
    
    public int update(BoardVO board);
    
    public int getTotalCount(Criteria cri);
    
    public void updateReplyCnt(Long bno, int amount);
}
