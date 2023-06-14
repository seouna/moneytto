<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta charset="utf-8">
<script type="text/javascript">
</script>
<title>머니또페이</title>
<link rel="shortcut icon" href="https://img.pay.naver.net/static/images/customer/favicon.ico" />
<link type="text/css" rel="stylesheet" href="//img.pay.naver.net/z/mstatic/css/service/mobile/nsp/order_common.css?1684912786775">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link href="${path }/resources/css/payment.css" rel ="stylesheet">
</head>
<script type="text/javascript">
$(function(){
	$('.button_section').click(function(){
		 swal({
			    title: "포인트 충전",
			    text: "등록된 간편결제 계좌로 충전하시겠습니까?",
			    icon: "info",
			    buttons: {
			      confirm: {
			        text: "확인",
			        value: true,
			        visible: true,
			        className: "",
			        closeModal: true,
			      },
			      cancel: {
			        text: "취소",
			        value: false,
			        visible: true,
			        className: "",
			        closeModal: true,
			      },
			    },
			 }).then((confirmResult) => {
				 if(confirmResult){
					 $("form").submit();					 
			 }
		});
	})
	
	$('#point2').change(function(){
		console.log($('#point2').val());
		console.log($('#point1').text());
		var point1 = Number($('#point1').text());
		var point2 = Number($('#point2').val());
		$('._totalPayAmt').text(point1 + point2)
	})
})
</script>
<body>
<div class="wrap">
	<!-- header -->
	<div class="header">
		<h1 class="h1 recurrent_h1">결제</h1>
		<p class="sp_header gnb_logo"><span class="blind">ttoPay</span></p>
	</div>

<form method="post" autocomplete="off" action="bank_withdraw">
<input type="hidden" name="id" value="${member.member_id }"> 
<input type="hidden" name="trade_type" value="충전">
<input type="hidden" name="member_name" value="${member.member_name }">
<input type="hidden" name="fintech_use_num" value="${fintech_use_num }"> 
<input type="hidden" name="user_name" value="${user_name }">
<div class="container" id="container">
    <div class="info_login">
		<div class="img_area">
			<img src="${member.member_image}" alt="프로필 이미지" width="32" height="32" class="thumb">
		</div>
        <span class="name">${member.member_name }</span>
        <span class="eng_name">(${member.member_id })</span>
	</div>
		<input type="checkbox" class="hidden" checked>
			<div class="fold_wrap">
				<label class="fold_head sp_heading head_nppoint" for="c1">
					<h3 class="fold_h">&#127808; 머니또페이</h3>
				</label>
				<div class="fold_content verification">
					<ul class="form_area box_margin">
					<li class="full_area label_margin button_margin">
						<span class="label" >보유 포인트</span>
						<span class="value number point_green align_right" id = "point1">${member.member_point }</span>
<!-- 						<span class="unit">원</span> -->
					</li>
					<li class="full_area label_margin button_margin2">
						<label for="point2" class="label">충전 포인트</label>
						<input title="사용포인트" id="point2" name="tran_amt" type="tel" class="value number _onlyPriceTarget _naverMileage _payForm _blur(checkout.mobile.nsp.paymentSheet.checkInputTextAmountValue()) _focus(checkout.mobile.nsp.paymentSheet.beforeInputPrice()) _stopDefault" placeholder="0">
						<span class="text_won">원</span>
					</li>
					</ul>
					<div class="amount_total">
						<span class="label">최종 보유포인트</span>
						<span class="value number">
							<span class="_totalPayAmt">${member.member_point }</span>
							<span class="unit">원</span>
						</span>
					</div>
				</div>
			</div>
	<div class="button_section">
		<div class="button_area">
			<div class="button_bottom">
			<a href="#" class="button _click(checkout.mobile.nsp.paymentSheet.create()) _stopDefault _doPayButton"><span class="sp_button_icon icon_check">결제하기</span></a></div>
		</div>
	</div>
</div>
</form>

<div class="_tempLayer"></div>
<div class="ly_bx" id="pointAlert" style="top:200px;display:none;">
    <div class="error_cont sp_ordersheet icon_error_big">
        <dl class="error_tx">
            <dt>잠시 후 다시 시도해 주세요.</dt>
            <dd>
                머니또페이 <em class="point_txt">포인트 정보 확인이 불가</em>하여<br>일시적으로 결제가 불가합니다.
            </dd>
        </dl>
    </div>
    <div class="cls_btn cls_btn_v2">
        <a href="#">확인</a>
    </div>
</div>
<div class="footer">
    <span class="corp">© MONNYTTO FINANCIAL Corp.</span>
</div>
</div>
<div class="_repurchase">&nbsp;</div>
<div class="_repurchaseDtl">
</div>
</body>
</html>
