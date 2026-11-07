<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="pageTitle" value="게시글 상세" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="row mb-4">
    <div class="col">
        <h2><i class="bi bi-file-text"></i> 게시글 상세</h2>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <div class="row">
            <div class="col">
                <h5 class="mb-0"><c:out value="${board.title}"/></h5>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-6">
                <small class="text-muted">
                    <i class="bi bi-person"></i> 작성자: 
                    <c:choose>
                        <c:when test="${not empty board.username}">
                            <c:out value="${board.username}"/> (<c:out value="${board.writer}"/>)
                        </c:when>
                        <c:otherwise>
                            <c:out value="${board.writer}"/>
                        </c:otherwise>
                    </c:choose>
                </small>
            </div>
            <div class="col-md-6 text-md-end">
                <small class="text-muted">
                    <i class="bi bi-calendar"></i> 등록일: <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}"/>
                    &nbsp;|&nbsp;
                    <i class="bi bi-pencil"></i> 수정일: <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updatedate}"/>
                </small>
            </div>
        </div>
        <hr>
        <div class="content-area" style="min-height: 200px; white-space: pre-wrap;">
<c:out value="${board.content}"/></div>
    </div>
</div>

<div class="mt-4">
    <sec:authentication property="principal" var="pinfo"/>
    <sec:authorize access="isAuthenticated()">
        <c:if test="${pinfo.username eq board.writer}">
            <button type="button" data-oper="modify" class="btn btn-warning">
                <i class="bi bi-pencil"></i> 수정
            </button>
        </c:if>
    </sec:authorize>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
        <c:if test="${pinfo.username ne board.writer}">
            <button type="button" data-oper="modify" class="btn btn-warning">
                <i class="bi bi-pencil"></i> 수정(관리자)
            </button>
        </c:if>
    </sec:authorize>
    <button type="button" data-oper="list" class="btn btn-secondary">
        <i class="bi bi-list"></i> 목록
    </button>
</div>

<form id="operForm" action="/board/modify" method="get">
    <input type="hidden" name="bno" value='<c:out value="${board.bno}"/>'>
    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var operForm = document.getElementById('operForm');
    
    document.querySelectorAll('button[data-oper]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var oper = this.getAttribute('data-oper');
            
            if (oper === 'modify') {
                operForm.action = '/board/modify';
            } else if (oper === 'list') {
                operForm.action = '/board/list';
                operForm.querySelector('[name="bno"]').remove();
            }
            
            operForm.submit();
        });
    });
});
</script>

<%@ include file="../includes/footer.jsp" %>
