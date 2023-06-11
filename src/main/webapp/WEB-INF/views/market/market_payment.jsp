<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!doctype html>
<html lang="ko">
<head>
<style type="text/css">
.info_login {
    position: relative;
    margin: -15px 1px 7px 1px !important;
    padding: 0px 18px 0 9px !important;
    background: #fcfcfd;
    font-size: 14px;
    height: 47px !important;
    line-height: 46px !important;
    border-bottom: 1px solid #e0e3e6;
    box-sizing: border-box;
}

</style>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta charset="utf-8">

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
// 	$('.button_section').click(function(){
// 		if(confirm("등록된 간편결제 계좌로 충전하시겠습니까?")){
// 			$("form").submit();
// 		}
					
// 	})
	
// 	$('#point2').change(function(){
// 		console.log($('#point2').val());
// 		console.log($('#point1').text());
// 		var point1 = Number($('#point1').text());
// 		var point2 = Number($('#point2').val());
// 		$('._totalPayAmt').text(point1 + point2)
// 	})


	$('.getAccountAmt').on("click", function() {
	    let queryString = $("form[name=accountInfo]").serialize();
	    $.ajax({
	        type: 'post',
	        url: 'bank_accountDetail_pay',
	        data: queryString,
	        dataType: 'text',
	        success: function(result) {
	            var parsedResult = JSON.parse(result);
	            let bank_name = parsedResult.bank_name;
	            let balance_amt = parsedResult.balance_amt;
	            $(".accountAmtResult").text(bank_name+" - " + balance_amt+"원");
	            $("input.getAccountAmt").remove();
	        }
	    });
	});

	let today = new Date();
	
	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var dateString = year + '-' + month  + '-' + day;

	$('.item_pay_date span').append('<strong>'+dateString+'</strong>');
	
	
	
	$('.chargePay').on("click",function(){
		let chargePoint = $('#point2').val();
		let fintech_use_num = "${fintech_use_num }";
		let user_name = "${userInfo.user_name}";
		let queryString = $("form[name=withdraw]").serialize();
		let access_token = "${access_token}";
		let id = "${sessionScope.sId}";
		
		$.ajax({
			type: 'post',
			url: 'bank_withdraw',
		 	data: {
		 		fintech_use_num: fintech_use_num,
		 		user_name: user_name,
		 	    chargePoint: chargePoint,
		 	   	tran_amt : chargePoint,
		 	    id: id,
		 	    trade_type:'이체'
		 	},
			success: function(response) {
				swal({	
	        		icon: "success",
	        		text: chargePoint+"point 충전되었습니다"
				}).then(function() {
				    location.reload();
				});
	 	  	}
		});
		
		
	});
	
	let item_price = parseInt("${item.item_price}");
	let my_point = parseInt("${member.member_point}");
	let urlParams = new URLSearchParams(window.location.search);
    let item_code = urlParams.get('item_code');
	let sellId = "${item.member_name }";
	$('.tradeBtn').on("click",function(){
		alert("내포인트 : "+my_point+"아이템가격 : "+item_price);
		alert(my_point >= item_price);
		if(my_point < item_price){
			swal({	
        		icon: "warning",
        		text: "POINT를 충전해주세요"
			});
		} else {
			$.ajax({
		      type: "get",
		      url: "pointTrade",
		      data: {
		        my_point: my_point,
		        item_price: item_price,
		        item_code: item_code,
		        sellId: sellId,
		        trade_date: dateString
		      },
		      success: function(response) {
		    	  swal({	
		        		icon: "success",
		        		text: "송금완료"
		    	  }).then(function() {
					    window.close();
					    opener.parent.location.reload(); 
					});
		    	  
		      }
		    });
		}
	});

})

</script>
<body>
<div class="wrap">
	<!-- header -->
	<div class="header">
		<h1 class="h1 recurrent_h1">안 전 결 제</h1>
		<p class="sp_header gnb_logo"><span class="blind">ttoPay</span></p>
	</div>


<div class="container" id="container">
<!-- 인증받은 핀테크번호 -->
<!-- 등록된 계좌의 핀테크번호를 알아내야함 -->
    <div class="info_login">
    	<div style="display: inline-block;float: left;">
			<div class="img_area">
				<img src="${member.member_image}" alt="프로필 이미지" width="32" height="32" class="thumb">
			</div>
	        <span class="name">${member.member_name }</span>
	        <span class="eng_name">(${member.member_id })</span>
    	</div>
    	
    	<form method="post" name="accountInfo" autocomplete="off" action="bank_accountDetail" accept-charset="UTF-8">
			<input type="hidden" name="fintech_use_num" value="${fintech_use_num }"> 
			<input type="hidden" name="user_name" value="${userInfo.user_name }">
			<input type="hidden" name="id" value="${member.member_id }"> 
			<input type="hidden" name="member_name" value="${member.member_name }">
			<input type="hidden" name="trade_type" value="이체">
			<div>
				<input type="button" value="내계좌 잔고조회" class="getAccountAmt" style="display: block;    float: right;    cursor: pointer;    width: 150px; background-color: #fff;    border: 1px solid #bababa;    height: 30px;    font-size: 15px;    margin-top: 8px;">
				<div class="accountAmtResult" style="display: inline-block;  float: right; font-size: 15px;"></div>
			</div>	
		</form>        
	</div>
	<div class="fold_wrap item_detail">
<!-- 		<label class="fold_head sp_heading head_nppoint" for="c1"> -->
<!-- 		</label> -->
			<div style="height: 215px; display: block; font-size: 16px;padding: 15px; border: 1px solid #ececec;">
				<div style="display: block; width: 45%; float: left; padding: 5px;">
					<img src='${itemImg }' style="position: relative; width: 200px; height: 200px; object-fit: cover;">
				</div>
				<div style="display: block; width:45%;float: right;  padding: 5px 10px;  margin-right: 0;margin-top: 20px;}">
					<h3 style="font-size: 20px; margin-bottom: 15px;text-align: center">&#128196; 상 품 정 보</h3>
					<hr style="display: block !important;">
					<div class="item_pay_date" style="text-align: right;font-size: 14px">결제일  <span></span></div>
					<div class="item_title" style="text-align: right;">${item.item_subject }</div>
					<div class="item_price" style="text-align: right;">${item.item_price } 원</div>
					<div class="item_member_nickname" style="text-align: right;font-size: 14px">받는사람 <strong> ${item.member_name }</strong></div>
				</div>
			</div>
	</div>
	
 <form method="post" name="withdraw" autocomplete="off" action="bank_withdraw" style="display:inline;" accept-charset="UTF-8">
	<input type="hidden" name="fintech_use_num" value="${fintech_use_num}"> 
	<input type="hidden" name="user_name" value="${userInfo.user_name}">
	<input type="hidden" name="id" value="${member.member_id}"> 
	<input type="hidden" name="member_name" value="${member.member_name}">
</form>	
	<div class="fold_wrap">
		<label class="fold_head sp_heading head_nppoint" for="c1">
			<h3 class="fold_h" style="display: inline-block;">&#127808; 머니또페이</h3>
			    <span class="chargePay" style="display: block;float: right;line-height: 25px;margin-right: 25px; cursor: pointer; border: 1px solid #ccc; height: 25px; margin-top: 10px; padding: 3px 13px;">충전하기</span>
		</label> 
<!-- 		<div class="button_section"> -->
<!-- 			<div class="button_area"> -->
<!-- 				<div class="button_bottom"> -->
<!-- 					<a href="#" class="button _click()"><span class="sp_button_icon icon_check">충전하기</span></a> -->
<!-- 				</div> -->
<!-- 			</div> -->
<!-- 		</div> -->
		<div class="fold_content verification">
			<div class="amount_total">
				<span class="label" style="color: #000">보유포인트</span>
				<span class="value number point_green align_right">
					<span class="_totalPayAmt">${member.member_point }</span>
					<span class="unit">원</span>
				</span>
			</div>		
			
			<ul class="form_area box_margin">
<!-- 			<li class="full_area label_margin button_margin" style="padding-left: 10px;   display: block;  height: 50px"> -->
<!-- 				<span class="label"  style="height: 50px; display: block;  width: 300px; line-height: 50px;">ㅇㅇ 은행계좌 잔액조회</span> -->
<!-- 				<input type="button" value="조회하기" class="getAccountAmt" style="    float: right;  display: block;   width: 100px;    height: 30px;   font-size: 15px;   margin-top: 12px;"> -->
<!-- 							<span class="value number point_green align_right" id = "point1"></span> -->
	<!-- 						<span class="unit">원</span> -->
<!-- 			</li> -->
			<li class="full_area label_margin button_margin2">
				<label for="point2" class="label">충전 포인트</label>
<!-- 				<input type="number"  title="사용포인트">  -->
<!-- 				<input title="사용포인트" id="" name="" type="number" class="" placeholder="0"> -->
				<input title="사용포인트" id="point2" name="tran_amt" type="text" class="value number _onlyPriceTarget _naverMileage _payForm _blur(checkout.mobile.nsp.paymentSheet.checkInputTextAmountValue()) _focus(checkout.mobile.nsp.paymentSheet.beforeInputPrice()) _stopDefault" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');">
				<span class="text_won">원</span>
			</li>
			</ul>
		</div>
	</div>
	<!-- 출금하는건 내계좌에서 출금해서 내 포인트로 충전 -->
	<div>
		<div class="tradeBtn" style="text-align: center;padding: 12px; background-color: #bb2649;color: #fff;cursor:pointer;">송금하기</div>
	</div>
</div>


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
