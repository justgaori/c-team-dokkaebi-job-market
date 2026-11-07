<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="pageTitle" value="게시판 목록" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="row mb-4">
    <div class="col">
        <h2><i class="bi bi-list-ul"></i> 자유게시판</h2>
    </div>
    <div class="col-auto">
        <sec:authorize access="isAuthenticated()">
            <a href="/board/register" class="btn btn-primary">
                <i class="bi bi-pencil-square"></i> 글쓰기
            </a>
        </sec:authorize>
    </div>
</div>

<!-- Search Form -->
<div class="card mb-4">
    <div class="card-body">
        <form id="searchForm" action="/board/list" method="get">
            <div class="row g-2">
                <div class="col-auto">
                    <select name="type" class="form-select">
                        <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/>>--</option>
                        <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
                        <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
                        <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
                        <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목+내용</option>
                        <option value="TW" <c:out value="${pageMaker.cri.type eq 'TW' ? 'selected' : ''}"/>>제목+작성자</option>
                        <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ''}"/>>전체</option>
                    </select>
                </div>
                <div class="col">
                    <input type="text" name="keyword" class="form-control" 
                           value='<c:out value="${pageMaker.cri.keyword}"/>' placeholder="검색어 입력">
                </div>
                <div class="col-auto">
                    <button class="btn btn-outline-secondary" type="submit">
                        <i class="bi bi-search"></i> 검색
                    </button>
                </div>
            </div>
            <input type="hidden" name="pageNum" value="1">
            <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        </form>
    </div>
</div>

<!-- Board List -->
<div class="card">
    <div class="card-body p-0">
        <table class="table table-hover mb-0">
            <thead class="table-light">
                <tr>
                    <th style="width:80px;">번호</th>
                    <th>제목</th>
                    <th style="width:120px;">작성자</th>
                    <th style="width:150px;">등록일</th>
                    <th style="width:80px;">조회</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="board">
                    <tr>
                        <td><c:out value="${board.bno}"/></td>
                        <td>
                            <a class="move text-decoration-none" href='<c:out value="${board.bno}"/>'>
                                <c:out value="${board.title}"/>
                                <c:if test="${board.replycnt > 0}">
                                    <span class="badge bg-secondary"><c:out value="${board.replycnt}"/></span>
                                </c:if>
                            </a>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty board.username}">
                                    <c:out value="${board.username}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${board.writer}"/>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                        <td><c:out value="${board.replycnt}"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5" class="text-center py-4">게시글이 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<!-- Pagination -->
<nav class="mt-4">
    <ul class="pagination">
        <c:if test="${pageMaker.prev}">
            <li class="page-item">
                <a class="page-link" href="${pageMaker.startPage - 1}">&laquo;</a>
            </li>
        </c:if>
        
        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
            <li class="page-item ${pageMaker.cri.pageNum == num ? 'active' : ''}">
                <a class="page-link" href="${num}">${num}</a>
            </li>
        </c:forEach>
        
        <c:if test="${pageMaker.next}">
            <li class="page-item">
                <a class="page-link" href="${pageMaker.endPage + 1}">&raquo;</a>
            </li>
        </c:if>
    </ul>
</nav>

<!-- Hidden Form for Page Navigation -->
<form id="actionForm" action="/board/list" method="get">
    <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
    <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
    <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
</form>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var result = '<c:out value="${result}"/>';
    
    if (result) {
        if (result === 'success') {
            alert('처리가 완료되었습니다.');
        } else if (parseInt(result) > 0) {
            alert('게시글 ' + result + '번이 등록되었습니다.');
        }
    }
    
    // Page link click
    document.querySelectorAll('.pagination a').forEach(function(el) {
        el.addEventListener('click', function(e) {
            e.preventDefault();
            var actionForm = document.getElementById('actionForm');
            actionForm.querySelector('[name="pageNum"]').value = this.getAttribute('href');
            actionForm.submit();
        });
    });
    
    // Board title click
    document.querySelectorAll('.move').forEach(function(el) {
        el.addEventListener('click', function(e) {
            e.preventDefault();
            var actionForm = document.getElementById('actionForm');
            actionForm.action = '/board/get';
            
            var bnoInput = document.createElement('input');
            bnoInput.type = 'hidden';
            bnoInput.name = 'bno';
            bnoInput.value = this.getAttribute('href');
            actionForm.appendChild(bnoInput);
            
            actionForm.submit();
        });
    });
});
</script>

<%@ include file="../includes/footer.jsp" %>
