<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jquery-3.6.4.js"></script>
<script>
$(document).ready(function() {
	var message = "${msg}";
	swal({
		text : message,
	}).then(function(){
	 	if("${isClose}"){
	 		if("${isReload}"){
	 			window.opener.location.reload()
	 		}
	 		window.close();
	 	}else{
	 		history.back();
	 	}
	});
});
</script>
