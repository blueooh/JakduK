<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<jsp:include page="../include/html-header.jsp"></jsp:include>

</head>
<body>
<div class="container">
<jsp:include page="../include/navigation-header.jsp"/>

<!-- Begin page content -->
<div class="panel panel-default">
  <!-- Default panel contents -->
  <div class="panel-heading">
  	<h4 class="panel-title">
  		${post.subject}
  		<c:if test="${!empty category}">&nbsp;<small><fmt:message key="${category.name}"/></small></c:if>
  	</h4>
  	<div class="row">
  		<div class="col-sm-1">
	  		<small>${post.writer.username}</small>
  		</div>
  		
	<%@page import="java.util.Date"%>
	<%Date CurrentDate = new Date();%>
	<fmt:formatDate var="nowDate" value="<%=CurrentDate %>" pattern="yyyy-MM-dd" />
	<fmt:formatDate var="postDate" value="${createDate}" pattern="yyyy-MM-dd" />
  		
  		<div class="col-md-5 visible-xs">
	  		<small>
			<c:choose>
				<c:when test="${postDate < nowDate}">
					<fmt:formatDate value="${createDate}" pattern="yyyy-MM-dd" />
				</c:when>
				<c:otherwise>
					<fmt:formatDate value="${createDate}" pattern="hh:mm (a)" />
				</c:otherwise>
			</c:choose> 
	    	| <spring:message code="board.views"/> ${post.views} 
	    	</small>
  		</div>
  		<div class="col-md-5 visible-sm visible-md visible-lg">
	  		<small>
	    	<fmt:formatDate value="${createDate}" pattern="yyyy-MM-dd hh:mm (a)" />
	    	| <spring:message code="board.views"/> ${post.views}
	    	</small>
  		</div>  		
  	</div>
  </div>
  
  <div class="panel-body">
    <p>${post.content}</p>
  </div>
  
	<div class="panel-footer text-center" ng-controller="AlertCtrl">
		<button type="button" class="btn btn-primary" ng-click="btnGoodOrBad('good')">
			<spring:message code="board.good"/>
			<span ng-init="numberOfGood=${fn:length(post.goodUsers)}">{{numberOfGood}}</span>
			<span class="glyphicon glyphicon-thumbs-up"></span>
		</button>
		<button type="button" class="btn btn-danger" ng-click="btnGoodOrBad('bad')">		
			<spring:message code="board.bad"/>
			<span ng-init="numberOfBad=${fn:length(post.badUsers)}">{{numberOfBad}}</span>
			<span class="glyphicon glyphicon-thumbs-down"></span>
		</button>
		<p></p>
		<div class="alert {{alert.classType}}" role="alert" ng-show="alert.msg">{{alert.msg}}</div>
	</div>
</div> <!-- /panel -->

<c:url var="listUrl" value="/board/free">
	<c:if test="${!empty listInfo.page}">
		<c:param name="page" value="${listInfo.page}"/>
	</c:if>
	<c:if test="${!empty listInfo.category}">
		<c:param name="category" value="${listInfo.category}"/>
	</c:if>
</c:url>
<a href="${listUrl}" class="btn btn-default" role="button"><spring:message code="board.list"/></a>

</div> <!-- /.container -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="<%=request.getContextPath()%>/web-resources/bootstrap/js/bootstrap.min.js"></script>

<script type="text/javascript">
function AlertCtrl($scope, $http) {
	$scope.alert = {};
	$scope.result = 0;
	$scope.btnGoodOrBad = function(status) {
		
		var bUrl = '<c:url value="/board/' + status + '/${post.seq}.json"/>';
		
		if ($scope.result == 0) {
			
			var reqPromise = $http.get(bUrl);
			
			$scope.result = 1;
			
			reqPromise.success(function(data, status, headers, config) {
				
				if (data.errorCode == 1) {
					message = '<spring:message code="board.msg.select.good"/>';
					mType = "alert-success";
				} else if (data.errorCode == 2) {
					message = '<spring:message code="board.msg.select.bad"/>';
					mType = "alert-success";
				} else if (data.errorCode == 3) {
					message = '<spring:message code="board.msg.select.already.good"/>';
					mType = "alert-warning";
				} else if (data.errorCode == 4) {
					message = '<spring:message code="board.msg.need.login"/>';
					mType = "alert-warning";
				}
				
				$scope.alert.msg = message;
				$scope.alert.classType = mType;
				$scope.numberOfGood = data.numberOfGood;
				$scope.numberOfBad = data.numberOfBad;
				$scope.result = 2;
				
			});
			reqPromise.error(error);
		}
	};
			
	function error(data, status, headers, config) {
		$scope.result = 0;
		$scope.error = '<spring:message code="common.msg.error.network.unstable"/>';
	}
	
}
</script>

</body>
</html>