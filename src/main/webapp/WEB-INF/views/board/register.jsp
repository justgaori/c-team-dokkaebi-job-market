<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글쓰기 - 도깨비 구인구직</title>
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
                <li aria-current="page">글쓰기</li>
            </ol>
        </nav>
        <h1>글쓰기</h1>
        <p>자유게시판에 새 글을 작성합니다.</p>
    </div>
</div>

<main id="main" class="page" tabindex="-1">
    <div class="container">
        <form role="form" action="/board/register" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-table">
                <div class="field">
                    <label for="title">제목 <span class="req">*</span></label>
                    <div class="field-body">
                        <input type="text" id="title" name="title" placeholder="제목을 입력하세요" required>
                    </div>
                </div>
                <div class="field">
                    <label for="content">내용 <span class="req">*</span></label>
                    <div class="field-body">
                        <textarea id="content" name="content" placeholder="내용을 입력하세요" required></textarea>
                    </div>
                </div>
                <div class="field">
                    <label for="writer">작성자</label>
                    <div class="field-body">
                        <sec:authentication property="principal.username" var="username"/>
                        <input type="text" id="writer" name="writer" value='<c:out value="${username}"/>' readonly style="background:#f4f6f9;">
                    </div>
                </div>
            </div>

            <div class="btn-row form-actions">
                <button type="submit" class="btn">등록</button>
                <button type="reset" class="btn secondary">초기화</button>
                <a href="/board/list" class="btn secondary">취소</a>
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
</body>
</html>
