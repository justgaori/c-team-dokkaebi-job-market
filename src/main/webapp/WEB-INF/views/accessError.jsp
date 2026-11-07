<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="접근 거부" scope="request"/>
<%@ include file="includes/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card border-danger">
            <div class="card-header bg-danger text-white">
                <h4 class="mb-0"><i class="bi bi-exclamation-triangle"></i> 접근 거부</h4>
            </div>
            <div class="card-body text-center">
                <p class="card-text fs-5"><c:out value="${msg}"/></p>
                <p class="text-muted">이 페이지에 접근할 권한이 없습니다.</p>
                <a href="/" class="btn btn-primary">홈으로</a>
                <a href="javascript:history.back()" class="btn btn-secondary">이전 페이지</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jsp" %>
