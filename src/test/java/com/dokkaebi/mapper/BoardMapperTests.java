package com.dokkaebi.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.dokkaebi.domain.BoardVO;
import com.dokkaebi.domain.Criteria;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

    @Autowired
    private BoardMapper mapper;

    @Test
    public void testGetList() {
        mapper.getList().forEach(board -> log.info(board));
    }

    @Test
    public void testGetListWithPaging() {
        Criteria cri = new Criteria();
        cri.setPageNum(1);
        cri.setAmount(10);
        
        mapper.getListWithPaging(cri).forEach(board -> log.info(board));
    }

    @Test
    public void testInsert() {
        BoardVO board = new BoardVO();
        board.setTitle("테스트 제목");
        board.setContent("테스트 내용");
        board.setWriter("tester");
        
        mapper.insert(board);
        
        log.info("insert: " + board);
    }

    @Test
    public void testInsertSelectKey() {
        BoardVO board = new BoardVO();
        board.setTitle("테스트 제목 SelectKey");
        board.setContent("테스트 내용 SelectKey");
        board.setWriter("tester");
        
        mapper.insertSelectKey(board);
        
        log.info("insertSelectKey: " + board.getBno());
    }

    @Test
    public void testRead() {
        BoardVO board = mapper.read(1L);
        
        log.info("read: " + board);
    }

    @Test
    public void testUpdate() {
        BoardVO board = mapper.read(1L);
        
        if (board == null) {
            return;
        }
        
        board.setTitle("수정된 제목");
        board.setContent("수정된 내용");
        
        int count = mapper.update(board);
        log.info("update count: " + count);
    }

    @Test
    public void testDelete() {
        log.info("delete count: " + mapper.delete(100L));
    }

    @Test
    public void testGetTotalCount() {
        Criteria cri = new Criteria();
        
        int count = mapper.getTotalCount(cri);
        log.info("total count: " + count);
    }

    @Test
    public void testSearch() {
        Criteria cri = new Criteria();
        cri.setType("T");
        cri.setKeyword("테스트");
        
        mapper.getListWithPaging(cri).forEach(board -> log.info(board));
    }

    @Test
    public void testSearchTW() {
        Criteria cri = new Criteria();
        cri.setType("TW");
        cri.setKeyword("admin");
        
        mapper.getListWithPaging(cri).forEach(board -> log.info(board));
    }
}
