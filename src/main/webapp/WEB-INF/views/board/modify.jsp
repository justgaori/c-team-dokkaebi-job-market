<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>게시글 수정 - 도깨비 구인구직</title>
<link rel="stylesheet" href="/resources/front/css/style.css">
</head>
<body>
<a href="#main" class="skip-link">본문 바로가기</a>

<header class="util-bar">
    <div class="container">
        <p class="util-desc">도깨비의 취업시장</p>
        <div class="acct">
            <sec:authorize access="isAuthenticated()">
                <span class="user-name"><sec:authentication property="principal.username"/>님</span>
                <form action="/logout" method="post" style="display:inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" style="background:none;border:none;color:#fff;cursor:pointer;padding:2px 12px;">로그아웃</button>
                </form>
            </sec:authorize>
        </div>
    </div>
</header>

<header class="gnb-wrap">
    <div class="container">
        <a href="/" class="logo">도깨비 구인구직</a>
        <nav class="nav">
            <a href="/board/list" class="active">자유게시판</a>
        </nav>
    </div>
</header>

<div class="page-head">
    <div class="container">
        <nav class="breadcrumb">
            <ol>
                <li><a href="/">홈</a></li>
                <li><a href="/board/list">자유게시판</a></li>
                <li aria-current="page">게시글 수정</li>
            </ol>
        </nav>
        <h1>게시글 수정</h1>
    </div>
</div>

<main id="main" class="page" tabindex="-1">
    <div class="container">
        <form role="form" action="/board/modify" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
            <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
            <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
            <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>

            <div class="form-table">
                <div class="field">
                    <label for="bno">번호</label>
                    <div class="field-body">
                        <input type="text" id="bno" name="bno" value='<c:out value="${board.bno}"/>' readonly style="background:#f4f6f9;">
                    </div>
                </div>
                <div class="field">
                    <label for="title">제목 <span class="req">*</span></label>
                    <div class="field-body">
                        <input type="text" id="title" name="title" value='<c:out value="${board.title}"/>' required>
                    </div>
                </div>
                <div class="field">
                    <label for="content">내용 <span class="req">*</span></label>
                    <div class="field-body">
                        <textarea id="content" name="content" required><c:out value="${board.content}"/></textarea>
                    </div>
                </div>
                <div class="field">
                    <label for="writer">작성자</label>
                    <div class="field-body">
                        <input type="text" id="writer" name="writer" value='<c:out value="${board.writer}"/>' readonly style="background:#f4f6f9;">
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">등록일</div>
                    <div class="field-body" style="padding-top:22px;">
                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}"/>
                    </div>
                </div>
                <div class="field">
                    <div class="field-label">수정일</div>
                    <div class="field-body" style="padding-top:22px;">
                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updatedate}"/>
                    </div>
                </div>
            </div>

            <sec:authentication property="principal" var="pinfo"/>

            <div class="btn-row form-actions">
                <c:if test="${pinfo.username eq board.writer}">
                    <button type="submit" data-oper="modify" class="btn">수정</button>
                    <button type="submit" data-oper="remove" class="btn danger">삭제</button>
                </c:if>
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <c:if test="${pinfo.username ne board.writer}">
                        <button type="submit" data-oper="modify" class="btn accent">수정(관리자)</button>
                        <button type="submit" data-oper="remove" class="btn danger">삭제(관리자)</button>
                    </c:if>
                </sec:authorize>
                <button type="button" data-oper="list" class="btn secondary">목록</button>
            </div>
        </form>
    </div>
</main>

<footer class="site-footer">
    <div class="container">
        <ul class="footer-links">
            <li><a href="#">이용약관</a></li>
            <li><a href="#">개인정보처리방침</a></li>
        </ul>
        <div class="footer-brand">도깨비 구인구직</div>
        <p class="copyright">&copy; 2024 도깨비 구인구직. All rights reserved.</p>
    </div>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var formObj = document.querySelector('form');

    document.querySelectorAll('button').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var oper = this.getAttribute('data-oper');
            if (!oper) return;

            e.preventDefault();

            if (oper === 'remove') {
                if (!confirm('정말 삭제하시겠습니까?')) return;
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
            }
            formObj.submit();
        });
    });
});
</script>
</body>
</html>
