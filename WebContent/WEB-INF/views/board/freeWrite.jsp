<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="freeWriteApp">
<head>
<jsp:include page="../include/html-header.jsp"></jsp:include>

  <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet">

  <!--summernote-->
  <link href="<%=request.getContextPath()%>/web-resources/summernote/css/summernote.css" rel="stylesheet">

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

</head>
<body>
<div class="container" ng-controller="FreeWriteCtrl">
<jsp:include page="../include/navigation-header.jsp"/>

<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<form:form commandName="boardFree" name="boardFree" action="${contextPath}/board/free/write" method="POST"
	ng-submit="onSubmit(boardFree, $event)">
	<legend><spring:message code="board.write"/></legend>
	<div class="form-group" ng-class="{'has-success':boardFree.categoryId.$valid, 'has-error':boardFree.categoryId.$invalid}">
		<div class="row">	
			<div class="col-sm-3">
			<label for="categoryId" class="control-label"><abbr title="required">*</abbr> <spring:message code="board.category"/></label>
			<form:select path="categoryId" cssClass="form-control" 
			ng-model="categoryId" ng-init="categoryId='${boardFree.categoryId}'" ng-blur="onCategoryId(boardFree)" ng-required="true">
				<form:option value=""><fmt:message key="board.category.init"/></form:option>
				<c:forEach items="${boardCategorys}" var="category">
					<form:option value="${category.categoryId}"><fmt:message key="${category.name}"/></form:option>
				</c:forEach>
			</form:select>
			<form:errors path="categoryId" cssClass="text-danger" element="span" ng-hide="errorCategoryId"/>
			<span class="text-danger" ng-model="errorCategoryId" ng-show="errorCategoryId">{{errorCategoryId}}</span>
			</div>
		</div>
	</div>

  <div class="form-group" ng-class="{'has-success':boardFree.subject.$valid, 'has-error':boardFree.subject.$invalid}">
		<div class="row">
			<div class="col-sm-12">
				<label for="subject" class="control-label"><abbr title="required">*</abbr> <spring:message code="board.subject"/></label>
				<form:input path="subject" cssClass="form-control" placeholder="Subject"
				ng-model="subject" ng-init="subject='${boardFree.subject}'" ng-blur="onSubject(boardFree)"
				ng-required="true" ng-minlength="1" ng-maxlength="50"/>
				<form:errors path="subject" cssClass="text-danger" element="span" ng-hide="errorSubject"/>
				<span class="text-danger" ng-model="errorSubject" ng-show="errorSubject">{{errorSubject}}</span>				
			</div>
		</div>	
  </div>
  
  <div class="form-group" ng-class="{'has-success':content.length > 0, 'has-error':content.length < 1}">
		<div class="row">
			<div class="col-sm-12">
				<label for="content" class="control-label"><abbr title="required">*</abbr> <spring:message code="board.content"/></label>
				<summernote config="options" ng-model="content"></summernote>
				<form:errors path="content" cssClass="text-danger" element="span" ng-hide="errorContent"/>
				<span class="text-danger" ng-model="errorContent" ng-show="errorContent">{{errorContent}}</span>
			</div>
		</div>	
  </div>
  
  <div class="form-group">
		<input class="btn btn-default" name="commit" type="submit" value="<spring:message code="common.button.submit"/>">
		<a class="btn btn-danger" href="<c:url value="/board"/>"><spring:message code="common.button.cancel"/></a>
  </div>

<form:textarea path="content" ng-model="content" ng-init="content='${boardFree.content}'" ng-minlength="1" class="hidden"/>  
</form:form>
    
<jsp:include page="../include/footer.jsp"/>
</div> <!-- /.container -->

<!-- Bootstrap core JavaScript
  ================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="<%=request.getContextPath()%>/web-resources/bootstrap/js/bootstrap.min.js"></script> 
<script src="<%=request.getContextPath()%>/web-resources/summernote/js/summernote.min.js"></script>
<script src="<%=request.getContextPath()%>/web-resources/summernote/lang/summernote-ko-KR.js"></script>
<!--angular-summernote dependencies -->
<script src="<%=request.getContextPath()%>/web-resources/angular-summernote/js/angular-summernote.min.js"></script>
<script type="text/javascript">

angular.module('freeWriteApp', ['summernote'])
	.controller('FreeWriteCtrl', function($scope) {
		$scope.options = {
			height: 150,
			toolbar: [
				['fontname', ['fontname']],
				['fontsize', ['fontsize']],
				['height', ['height']],
				['style', ['bold', 'underline', 'italic', 'strikethrough', 'clear']],
				['color', ['color']],
				['para', ['paragraph']],
				['dot', ['ul', 'ol']],
				['insert', ['link', 'table', 'hr']],
				['misc', ['codeview', 'help']]
				]
		};
		$scope.onSubmit = function(boardFree, event) {
			if (boardFree.$valid && $scope.content.length > 0) {
				
			} else {
				$scope.onCategoryId(boardFree);
				$scope.onSubject(boardFree);
				$scope.onContent(boardFree);
				event.preventDefault();
			}
		};
		
		$scope.onCategoryId = function(boardFree) {
			if (boardFree.categoryId.$invalid) {
				$scope.errorCategoryId = '<spring:message code="common.msg.required"/>';
			} else {
				$scope.errorCategoryId = "";
			}
		};
		
		$scope.onSubject = function(boardFree) {
			if (boardFree.subject.$invalid) {
				if (boardFree.subject.$error.required) {
					$scope.errorSubject = '<spring:message code="common.msg.required"/>';
				} else if (boardFree.subject.$error.minlength || boardFree.subject.$error.maxlength) {
					$scope.errorSubject = '<spring:message code="Size.boardFree.subject"/>';
				}				
			} else {
				$scope.errorSubject = "";
			}
		};		
		
		$scope.onContent = function(boardFree) {
			if ($scope.content.length < 1) {
				$scope.errorContent = '<spring:message code="Size.boardFree.content"/>';
			} else {
				$scope.errorContent = "";
			}
		};	
	});
</script>
</body>
</html>