<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html ng-app="loginApp">
<head>
<jsp:include page="../include/html-header.jsp"></jsp:include>

<!-- Custom styles for this template -->
<link href="<%=request.getContextPath()%>/web-resources/bootstrap/css/signin.css" rel="stylesheet">
</head>
<body>
<div class="container" ng-controller="loginCtrl">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
        	<a href="<c:url value="/home"/>"><h4><spring:message code="common.jakduk"/></h4></a>
            <div class="login-panel panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><spring:message code="user.sign.in"/></h3>
                </div>
                <div class="panel-body">
                	<c:choose>
                		<c:when test="${status == 1}">
                			<div class="alert alert-danger" role="alert"><spring:message code="user.msg.login.faulure"/></div>
                		</c:when>
                		<c:when test="${status == 2}">
                			<div class="alert alert-success" role="alert"><spring:message code="user.msg.register.success"/></div>
                		</c:when>                		
                	</c:choose>
                    <form action="j_spring_security_check" name="loginForm" method="post" ng-submit="onSubmit(loginForm, $event)">
                        <fieldset>
                            <div class="form-group" 
                            ng-class="{'has-success':loginForm.j_username.$valid, 'has-error':loginForm.j_username.$invalid}">
                                <input type="email" class="form-control" id="j_username" name="j_username" placeholder="E-mail" autofocus
                                ng-model="email" ng-required="true" ng-minlength="6" ng-maxlength="20" ng-pattern="/^[\w]{3,}@[\w]+(\.[\w-]+){1,3}$/">
									<span class="text-danger" ng-model="errorEmail" ng-show="errorEmail">{{errorEmail}}</span>
                            </div>
          
                            <div class="form-group"
                            ng-class="{'has-success':loginForm.j_password.$valid, 'has-error':loginForm.j_password.$invalid}">
                                <input type="password" class="form-control" id="j_password" name="j_password" placeholder="Password"
                                ng-model="password" ng-required="true" ng-minlength="4" ng-maxlength="20">
									<span class="text-danger" ng-model="errorPassword" ng-show="errorPassword">{{errorPassword}}</span>                                    
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" name="remember" ng-model="remember">
                                    <spring:message code="user.email.remember"/>
                                </label>
                            </div>
                            <!-- Change this to a button or input when using this as a form -->
                            <button type="submit" class="btn btn-lg btn-success btn-block"><spring:message code="user.sign.in"/></button>
                        </fieldset>
                    </form>

<p>
 <div class="control-group">
   <div class="controls">
     <spring:message code="user.msg.not.user"/> 
     <a href="<c:url value="/user/write"/>"><spring:message code="user.msg.register.here"/></a>
   </div>
 </div>
</p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="<%=request.getContextPath()%>/web-resources/angular/js/angular.js"></script>
<script src="<%=request.getContextPath()%>/web-resources/angular/js/angular-cookies.min.js"></script>
<script type="text/javascript">
angular.module("loginApp", ["ngCookies"])
.controller("loginCtrl", ["$scope", "$cookieStore", function($scope, $cookieStore) {
	var email = $cookieStore.get("email");
	var remember = $cookieStore.get("remember");
	
	if (remember != null && email != null && remember == "1") {
		$scope.email = email;
		$scope.remember = true;
	}
	
	$scope.onSubmit = function(loginForm, event){
		if (loginForm.$valid) {
		} else {
			if (loginForm.j_username.$error.required) {
				$scope.errorEmail = '<spring:message code="common.msg.required"/>'; 
			} else if (loginForm.j_username.$error.minlength || loginForm.j_username.$error.maxlength) {
				$scope.errorEmail = '<spring:message code="Size.userWrite.email"/>';
			} else if (loginForm.j_username.$error.pattern) {
				$scope.errorEmail = '<spring:message code="user.msg.check.mail.format"/>';
			}
			
			if (loginForm.j_password.$error.required) {
				$scope.errorPassword = '<spring:message code="common.msg.required"/>'; 
			} else if (loginForm.j_password.$error.minlength || loginForm.j_password.$error.maxlength) {
				$scope.errorPassword = '<spring:message code="Size.userWrite.password"/>';
			}
			event.preventDefault();
		}
	};
}]);
</script>
</body>
</html>