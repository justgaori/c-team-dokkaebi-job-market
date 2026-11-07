<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="pageTitle" value="글쓰기" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="row mb-4">
    <div class="col">
        <h2><i class="bi bi-pencil-square"></i> 글쓰기</h2>
    </div>
</div>

<div class="card">
    <div class="card-body">
        <form role="form" action="/board/register" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="mb-3">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" name="title" 
                       placeholder="제목을 입력하세요" required>
            </div>
            
            <div class="mb-3">
                <label for="content" class="form-label">내용</label>
                <textarea class="form-control" id="content" name="content" 
                          rows="10" placeholder="내용을 입력하세요" required></textarea>
            </div>
            
            <div class="mb-3">
                <label for="writer" class="form-label">작성자</label>
                <sec:authentication property="principal.username" var="username"/>
                <input type="text" class="form-control" id="writer" name="writer" 
                       value='<c:out value="${username}"/>' readonly>
            </div>
            
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg"></i> 등록
                </button>
                <button type="reset" class="btn btn-secondary">
                    <i class="bi bi-arrow-counterclockwise"></i> 초기화
                </button>
                <a href="/board/list" class="btn btn-outline-secondary">
                    <i class="bi bi-x-lg"></i> 취소
                </a>
            </div>
        </form>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
