<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>자유게시판 - 도깨비 구인구직</title>
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
                <li aria-current="page">자유게시판</li>
            </ol>
        </nav>
        <h1>자유게시판</h1>
        <p>자유롭게 의견을 나누는 공간입니다.</p>
    </div>
</div>

<main id="main" class="page" tabindex="-1">
    <div class="container">
        <div class="board-top">
            <p class="total">전체 <b><c:out value="${pageMaker.total}"/></b>건</p>
            <form id="searchForm" class="search-bar" action="/board/list" method="get">
                <select name="type">
                    <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/>>전체</option>
                    <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
                    <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
                    <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
                    <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목+내용</option>
                    <option value="TWC" <c:out value="${pageMaker.cri.type eq 'TWC' ? 'selected' : ''}"/>>전체</option>
                </select>
                <input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>' placeholder="검색어 입력">
                <input type="hidden" name="pageNum" value="1">
                <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                <button type="submit" class="btn">검색</button>
            </form>
        </div>

        <table class="board-table">
            <thead>
                <tr>
                    <th style="width:70px;">번호</th>
                    <th>제목</th>
                    <th style="width:100px;">작성자</th>
                    <th style="width:100px;">등록일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="board">
                    <tr>
                        <td class="num"><c:out value="${board.bno}"/></td>
                        <td class="title">
                            <a class="move" href='<c:out value="${board.bno}"/>'>
                                <c:out value="${board.title}"/>
                                <c:if test="${board.replycnt > 0}">
                                    <span class="badge"><c:out value="${board.replycnt}"/></span>
                                </c:if>
                            </a>
                        </td>
                        <td class="writer">
                            <c:choose>
                                <c:when test="${not empty board.username}"><c:out value="${board.username}"/></c:when>
                                <c:otherwise><c:out value="${board.writer}"/></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr><td colspan="4" class="empty">게시글이 없습니다.</td></tr>
                </c:if>
            </tbody>
        </table>

        <div class="board-bottom">
            <div></div>
            <div class="pagination">
                <c:if test="${pageMaker.prev}">
                    <button type="button" class="pageBtn" data-page="${pageMaker.startPage - 1}">&lt;</button>
                </c:if>
                <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                    <button type="button" class="pageBtn ${pageMaker.cri.pageNum == num ? 'on' : ''}" data-page="${num}">${num}</button>
                </c:forEach>
                <c:if test="${pageMaker.next}">
                    <button type="button" class="pageBtn" data-page="${pageMaker.endPage + 1}">&gt;</button>
                </c:if>
            </div>
            <sec:authorize access="isAuthenticated()">
                <a href="/board/register" class="btn">글쓰기</a>
            </sec:authorize>
        </div>
    </div>
</main>

<form id="actionForm" action="/board/list" method="get">
    <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
    <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
    <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
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
    var result = '<c:out value="${result}"/>';
    if (result) {
        if (result === 'success') {
            alert('처리가 완료되었습니다.');
        } else if (parseInt(result) > 0) {
            alert('게시글 ' + result + '번이 등록되었습니다.');
        }
    }

    document.querySelectorAll('.pageBtn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var actionForm = document.getElementById('actionForm');
            actionForm.querySelector('[name="pageNum"]').value = this.dataset.page;
            actionForm.submit();
        });
    });

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
</body>
</html>
