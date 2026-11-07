<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out value="${board.title}"/> - 도깨비 구인구직</title>
<link rel="stylesheet" href="/resources/front/css/style.css">
</head>
<body>
<a href="#main" class="skip-link">본문 바로가기</a>

<header class="util-bar">
    <div class="container">
        <p class="util-desc">도깨비의 취업시장</p>
        <div class="acct">
            <sec:authorize access="isAnonymous()">
                <a href="/login">로그인</a>
            </sec:authorize>
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
                <li aria-current="page">게시글 상세</li>
            </ol>
        </nav>
        <h1>게시글 상세</h1>
    </div>
</div>

<main id="main" class="page" tabindex="-1">
    <div class="container">
        <div class="post-head">
            <h2><c:out value="${board.title}"/></h2>
            <dl class="post-info">
                <div>
                    <dt>작성자</dt>
                    <dd>
                        <c:choose>
                            <c:when test="${not empty board.username}"><c:out value="${board.username}"/> (<c:out value="${board.writer}"/>)</c:when>
                            <c:otherwise><c:out value="${board.writer}"/></c:otherwise>
                        </c:choose>
                    </dd>
                </div>
                <div>
                    <dt>등록일</dt>
                    <dd><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.regdate}"/></dd>
                </div>
                <div>
                    <dt>수정일</dt>
                    <dd><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${board.updatedate}"/></dd>
                </div>
            </dl>
        </div>

        <div class="post-body"><c:out value="${board.content}"/></div>

        <div class="post-actions">
            <div class="btn-row">
                <button type="button" data-oper="list" class="btn secondary">목록</button>
            </div>
            <div class="btn-row">
                <sec:authentication property="principal" var="pinfo"/>
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${pinfo.username eq board.writer}">
                        <button type="button" data-oper="modify" class="btn">수정</button>
                    </c:if>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <c:if test="${pinfo.username ne board.writer}">
                        <button type="button" data-oper="modify" class="btn accent">수정(관리자)</button>
                    </c:if>
                </sec:authorize>
            </div>
        </div>
    </div>
</main>

<form id="operForm" action="/board/modify" method="get">
    <input type="hidden" name="bno" value='<c:out value="${board.bno}"/>'>
    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

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
</body>
</html>
