<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="pageTitle" value="게시글 수정" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="row mb-4">
    <div class="col">
        <h2><i class="bi bi-pencil"></i> 게시글 수정</h2>
    </div>
</div>

<div class="card">
    <div class="card-body">
        <form role="form" action="/board/modify" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
            <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
            <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
            <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
            
            <div class="mb-3">
                <label for="bno" class="form-label">번호</label>
                <input type="text" class="form-control" id="bno" name="bno" 
                       value='<c:out value="${board.bno}"/>' readonly>
            </div>
            
            <div class="mb-3">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" name="title" 
                       value='<c:out value="${board.title}"/>' required>
            </div>
            
            <div class="mb-3">
                <label for="content" class="form-label">내용</label>
                <textarea class="form-control" id="content" name="content" 
                          rows="10" required><c:out value="${board.content}"/></textarea>
            </div>
            
            <div class="mb-3">
                <label for="writer" class="form-label">작성자</label>
                <input type="text" class="form-control" id="writer" name="writer" 
                       value='<c:out value="${board.writer}"/>' readonly>
            </div>
            
            <div class="mb-3">
                <label class="form-label">등록일</label>
                <p class="form-control-plaintext">
                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}"/>
                </p>
            </div>
            
            <div class="mb-3">
                <label class="form-label">수정일</label>
                <p class="form-control-plaintext">
                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updatedate}"/>
                </p>
            </div>
            
            <sec:authentication property="principal" var="pinfo"/>
            
            <div class="d-flex gap-2">
                <c:if test="${pinfo.username eq board.writer}">
                    <button type="submit" data-oper="modify" class="btn btn-warning">
                        <i class="bi bi-check-lg"></i> 수정
                    </button>
                    <button type="submit" data-oper="remove" class="btn btn-danger">
                        <i class="bi bi-trash"></i> 삭제
                    </button>
                </c:if>
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <c:if test="${pinfo.username ne board.writer}">
                        <button type="submit" data-oper="modify" class="btn btn-warning">
                            <i class="bi bi-check-lg"></i> 수정(관리자)
                        </button>
                        <button type="submit" data-oper="remove" class="btn btn-danger">
                            <i class="bi bi-trash"></i> 삭제(관리자)
                        </button>
                    </c:if>
                </sec:authorize>
                <button type="button" data-oper="list" class="btn btn-secondary">
                    <i class="bi bi-list"></i> 목록
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var formObj = document.querySelector('form');
    
    document.querySelectorAll('button').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var oper = this.getAttribute('data-oper');
            
            if (!oper) return;
            
            e.preventDefault();
            
            if (oper === 'remove') {
                if (!confirm('정말 삭제하시겠습니까?')) {
                    return;
                }
                formObj.action = '/board/remove';
            } else if (oper === 'list') {
                formObj.action = '/board/list';
                formObj.method = 'get';
                
                var hiddenInputs = formObj.querySelectorAll('input[type="hidden"]');
                hiddenInputs.forEach(function(input) {
                    if (input.name === 'bno' || input.name.startsWith('_csrf')) {
                        input.disabled = true;
                    }
                });
            } else if (oper === 'modify') {
                // default action
            }
            
            formObj.submit();
        });
    });
});
</script>

<%@ include file="../includes/footer.jsp" %>
