<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<form:form commandName="encyclopedia" action="${contextPath}/admin/encyclopedia/write" method="POST">
<p>
LANGUAGE : 	<form:input path="language" cssClass="form-control" placeholder="language"/>
</p>
<p>
KIND : 	<form:input path="kind" cssClass="form-control" placeholder="kind"/>
</p>
<p>
SUBJECT : 	<form:input path="subject" cssClass="form-control" placeholder="subject"/>
</p>
<p>
CONTENT : <form:textarea path="content" cols="40" rows="5"/>
</p>
<p>
<input type="submit" value="<spring:message code="common.button.submit"/>" class="btn btn-default"/>
</p>
</form:form>
</body>
</html>