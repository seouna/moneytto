<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>머니머니머니또</title>
<script src="https://kit.fontawesome.com/b2ab45b73f.js" crossorigin="anonymous"></script>
<link href="${path }/resources/css/auction.css" rel="stylesheet">
<link href="${path }/resources/css/inc.css" rel="stylesheet">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<style type="text/css">
.contentImage {
	height: 250px;
	
}
.OpponentChat__Wrapper-qv8pn4-0 {
	margin-left: 10px;
}

.auction_input_button {
	font-size: 20px;
	width: 300px;
	height: 40px;
    margin: auto;
    display: block;
}

#auction_input_title {
	color: #bb2649;
    font-weight: bold;
}

#message {
  width: 70%;
  height: 60px;
  font-size: 15px;
  margin-left: 10px;
  border: 0;
  border-radius: 15px;
  outline: none;
  padding-left: 10px;
  background-color: rgb(233, 233, 233);
}

#message::placeholder {
  color: black;
  font-family: 'Pretendard-Regular';
}

</style>
<script type="text/javascript">
	// 경매 타이머
	window.onload = function(){
		let clock = null;
		var time = window.setInterval(function(){
			
				now = new Date();
				let year = now.getFullYear();
				let month = now.getMonth() < 10 ? "0" + (now.getMonth() + 1) : now.getMonth() + 1;
				let day = now.getDate();
				let hours = now.getHours();
				let minutes = now.getMinutes() < 10 ? "0" + now.getMinutes() : now.getMinutes();  
				let seconds = now.getSeconds() < 10 ? "0" + now.getSeconds() : now.getSeconds();  
				
				
				clock = year + "."
						+ month + "."
						+ day + " "
						+ hours + ":"
						+ minutes + ":"
						+ seconds
				
				let start_time = new Date("${auction.get('auction_start_date') }");	// 경매 시작 시간
				let current_time = new Date(clock); // 현재시간
				
				
				// 경매 남은시간 분, 초 
				let diffMinutes = 30 - parseInt(((current_time - start_time) / (1000 * 60)));
				let diffSeconds = 60 - (((current_time - start_time) % (1000 * 60)) / 1000);
				let diffSecondsResult = diffSeconds < 10 ? "0" + diffSeconds : diffSeconds; 
				let resultClock = (diffMinutes - 1) + ":" + (diffSecondsResult - 1);
				
				
				// 경매시작 시간 지나면 (시간 카운트)
				if(start_time <= current_time) {
					$("#con_countDown").html(resultClock);
// 					$('#auction_input_after *').prop('disabled', false);
				} 
				
				// 경매 시작 후 (10분 이 지나면 종료)
				if(current_time - start_time > 1800000) {
					
					window.setTimeout(function(){ // setInterval 함수 종료
						window.clearInterval(time);
						$("#con_countDown").html("경매가 종료 되었습니다.");
					});
				}
			
			
			},1000);
		
	};



	$(document).ready(function() {
// 		$('#auction_input_after *').prop('disabled', true);
		// 경매 등록 확인
		if(${auctionEnroll}) {
			$("#auction_input_before").css('display', 'none');
			$("#auction_input_after").css('display', 'block');
			
		}
		
		function chatSend() {
			const data = {
					"auctionCode" :  "${auction.get('auction_code') }",
	                "name" : "${ sessionScope.sId }",
	                "message"   : $('#message').val()
	            };
	        let jsonData = JSON.stringify(data);
			socket.send(jsonData);
			$('#message').val('');
		};
		
		
	
		
		// 버튼 누름 전송
		$('#btnSend').on("click", function(evt) {
			chatSend();
			evt.preventDefault();
		});
		// 엔터 누름 전송
		$("#message").on("keydown",function(key){
	        if(key.keyCode == 13) {
	            chatSend();
	        }
	    });
		
		// 소켓 연결
		connect();
		
		// 경매 입찰 등록
		$("#auctionRegist").on("click", function() {
			location.href="auctionDeposit?auction_code=" + $('input[name=auction_code]').val() 
										+ "&deposit=" + $('input[name=deposit]').val();
		});
		
		
		
		
	});
</script>
<script type="text/javascript">
	// 채팅 시간
	let today = new Date();
	let h = today.getHours();
	let m = today.getMinutes();
	
	let amPm = h < 12 ? "오전" : "오후";
	let hours = h < 13 ? h : h - 12; // 시
	let minutes = m < 10 ? "0" + m : m;  // 분
	
	
	var socket = null;
	function connect() {
		var ws = new WebSocket("ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/auctionChat");
		socket = ws;
		
		ws.onopen = function() {
			console.log('Info: connection opened');
			const data = {
					"auctionCode" :  "${auction.get('auction_code') }",
	                "name" : "${ sessionScope.sId }",
	                "message"   : "ENTER"
	            };
			
	        let jsonData = JSON.stringify(data);
			socket.send(jsonData);
			
		};
		
		// 메세지 수신
		ws.onmessage = function (msg) {
			var data = msg.data;
			var sessionId = null; //데이터를 보낸 사람
			var message = null;
			
			var cur_session = "${sessionScope.sId}"; //현재 세션에 로그인 한 사람
			
			sessionId = data.split(":")[0];
			message = data.split(":")[1];
			
		    // 로그인 한 클라이언트와 타 클라이언트를 분류
			if(sessionId == cur_session) {
				var str = "<div class='chat_myself'>";
				str += "<div class='chat_myself_box'>";
				str += "<div class='chat_myself_message'>";
				str += "<span>" + message + "</span>";
				str += "<div class='chat_myself_timeago'>" + amPm + " " + hours + ":" + minutes + "</div></div></div></div>";
				
				$(".chatBox").append(str);
			} else {
				var str = "<div class='OpponentChat__Wrapper-qv8pn4-0 cFvuGS'>";
				str += "<img src='https://ccimage.hellomarket.com/img/web/common/empty_profile.svg' alt='상대방 프로필 이미지' class='OpponentChat__ProfileImage-qv8pn4-2 eLwuXd'>";
				str += "<div class='OpponentChat__Nick-qv8pn4-3 hYaaYd'>" + sessionId + "</div>";
				str += "<div class='OpponentChat__MyChatList-qv8pn4-1 lecfCu'>";
				str += "<div class='OpponentChat__TextBox-qv8pn4-5 giIZqy'>";
				str += "<span class='OpponentChat__Text-qv8pn4-6 ZPeEt'>" + message + "</span>";
				str += "<div class='OpponentChat__TimeAgo-qv8pn4-7 jXWPOW'>" + amPm + " " + hours + ":" + minutes + "</div></div></div></div>";
				
				$(".chatBox").append(str);
			};
			
			
			
		};
		
		ws.onclose = function (event) { console.log('Info: connection closed'); };
		ws.onerror = function (event) { console.log('Info: connection closed'); };
	}
	
</script>
</head>
<body>
	<jsp:include page="../nav.jsp" />
	<input type="hidden" name="auction_code" value="${auction.get('auction_code')}">
	<input type="hidden" name="image_name" value="${auction.get('image_name')}">
	<input type="hidden" name="deposit" value="${deposit}">
	<div class="container">
		<div class="fullScreen">
				<!-- 왼쪽 -->
				<div class="auction_left">
					<div class="left_main">
						<div class="remainTime"> 
							<span>경매종료 까지 남은시간</span>
							<div id="con_countDown" class="con_countDown"><i class="fa-regular fa-clock fa-xs"></i>&nbsp;경매 시작 전 입니다.</div>
						</div>
						<div class="auction_info">
							<span class="notice_title"><i class="fa-solid fa-bookmark"></i>&nbsp;공지사항</span><br>
							<p class="auction_notice">
							1. 참가 신청을 하셔야 경매에 참여 가능합니다<br>
							2. 경매가의 10%의 보증금을 받습니다<br>
							3. 경매가 끝난 후 낙찰자를 제외하고 보증금을 돌려드립니다<br>
							4. 낙찰 후 구매 취소 시 보증금을 받을 수 없습니다<br>
							5. 즉시 구매 시 경매가 종료됩니다<br>
							6. 현재 페이지를 나가면 기록이 사라집니다
							</p>
							<hr>
							<div class="con_tit">${auction.get("auction_item_name") }</div>
							<div class="con_detail">
								<!-- 상품이미지 -->
								<div class="contentImage" style="background-image:url('http://c3d2212t3.itwillbs.com/images/${auction.get('image_name')}')"></div><br>
								<!-- 상품정보 -->
								<div>
									<div>
										<span>상품정보</span>
										<div class="con_price">상세정보 창 열기</div>
									</div>
									<span>경매날짜</span>
									<div class="con_period">${auction.get('auction_start_date') }</div>
									<div>
										<span>시작가</span>
										<div class="con_price">${auction.get('auction_present_price') }원</div>
									</div>
								</div>
								<hr>
								<div style="float: right;">
								<div class="con_pick"><i class="fas fa-user"></i>&nbsp;<span>입찰자</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<span>명</span></div></div><br>
							</div>
						</div>
					</div>
				</div>
				<!-- 가운데 -->
				<div class="auction_center">
					
					<div class="auction_realTime">
						<span style="font-size: 25px;">실시간 경매</span>
						<div class="auction_price"><span>${auction.auction_present_price }</span>원&nbsp;<i class="fa-solid fa-comment-dollar"></i></div>
						<div class="auction_alert"><span>서버 요청과 3초 정도 느릴수 있습니다.</span></div>
						<div class="auction_id">
						<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
						</div>
					</div>
					<div class="auction_realStatus">
						<div class="auction_log_title">경매로그</div>
						<div class="auction_log">
							<div class="logBox">
								<c:forEach var="auctionLog" items="${auctionLog }">
									<div class='chat_myself'>
										닉네임님&nbsp;&nbsp;<span>${auctionLog.chat_message }원&nbsp;&nbsp;입찰!&nbsp;&nbsp;</span>
<%-- 										<fmt:formatDate value="${auctionLog.chat_time }" pattern="tt hh:mm:ss" /> --%>
<%-- 										<fmt:parseDate var="formattedDate" value="${auctionLog.chat_time }" pattern="yyyy-MM-dd'T'hh:mm:ss" /> --%>
									</div>
								</c:forEach>
<%-- 										ddddddddddddd<fmt:formatDate value="${auctionLog.chat_time }" pattern="hh:mm:ss" /> --%>
<!-- 								<div class="chat_myself"> -->
<!-- 								</div> -->
							</div>
						</div>
					</div>
					<!-- 경매 등록 전 -->
					<div id="auction_input_before" class="auction_input" style="display:block">
						<div id="auction_input_title" class="auction_input_title">경매 입찰 등록</div>
						<hr>
						<br><br><br>
						<input id="auctionRegist" class="auction_input_button" type="button" value="참여하기">
					</div>
					<!-- 경매 등록 후 -->
					<div id="auction_input_after" class="auction_input" style="display:none">
						<div class="auction_input_title">입찰입찰입찰 제목좀바꿔죠</div>
						<hr>
<!-- 						<div style="float: right;"> -->
<!-- 						<div class="con_pick"><i class="fas fa-user"></i>&nbsp;<span>입찰자</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0<span>명</span></div></div><br> -->
						<div class="bid">
							<div class="bid_left">
								<div>MY 보증금</div>
								<div>경매단가로 입찰하기</div>
								<div>입찰가격</div>
								<div>내 입찰가</div>
								<div>즉시구매가</div>
							</div>
							<div class="bid_right">
								<div>${deposit }원</div>
								<div><input type="button" id="btnAskingPrice" value="즉시입찰(+${askingPrice })" style="width: 228px"
										data-price="${askingPrice }" class="btn"></div>
								<div>
									<input type="text" id="logPrice" oninput="this.value = this.value.replace(/[^0-9]/g, '');" placeholder="금액입력">
									<input type="button" value="입찰" id="btnBid" class="btn" data-price="">
								</div>
								<div class="my_bid"></div>
								<div class="buy_now">
									<span style="color:#bb2649">${purchase }원</span>
									<input type="button" id="btnPurchase" value="즉시구매" style="float: right;margin-right: 11px;">
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- 오른쪽 -->
				<div class="auction_right">
					<div class="right_main">
						<div class="chat_header">
							<a href="mypage" target="_blank" rel="noopener noreferrer">
								<div class="image_box">
									<div class="image_table">
										<img src="https://ccimage.hellomarket.com/web/2019/member/img_apply_profile_4x_0419.png" alt="명품인증님의 프로필 이미지">
									</div>
								</div>
								<div class="info">
									<div id="sessionCount">
										<span>${sessionScope.sId }</span>
										<span id="sessionCount2">0/100명</span>
									</div>
								</div>
							</a>
							<div class="declaration">
								<div>
									<img src="https://ccimage.hellomarket.com/web/2019/chat/btn_hellotalk_report_x2.png" alt="신고 이미지">
								</div>
							</div>
							<a href="/messages">
								<div class="chat_close"></div>
							</a>
						</div>
						<div class="chat_description" style="bottom:49px">
							<div class="chatBox">
								<div class="chat_timeago">
									<div class="chat_timeago_box">
										<span class="chat_timeago_text">${formatedNow }</span>
									</div>
								</div>
							</div>
						</div>
						<div class="chat_footer">
							<div class="chat_footer_area">
								<input type="text" id="message" contenteditable="true" placeholder="메세지를 입력해주세요.">
								<button id="btnSend" type="button">전송</button>
							</div>
						</div>
					</div>
				</div>		
			</div>
		</div>
</body>
<script type="text/javascript">

// ==========================================================
$(document).ready(function() {
// 	var message = ${price};
	var chatLog;
	var nowPrice = ${price};
	
	function chatSend2() {
// 		console.log(" 옥션 프라이스 텍스트" + $(".auction_price").text())
		const data = {
			"id" : "${ sessionScope.sId }",
			"name" : "${ sessionScope.nickname }",
			"message"   : chatLog,
// 			"enrollCode" : "${enrollCode}",
			"auctionCode" :  "${auction.auction_code }",
// 				if($('#message').val() != null && $('#message').val() != "") {
// 				$('#message').val()
// 				}
		};
		let jsonData = JSON.stringify(data);
		socket2.send(jsonData);
		$('#chatLog').val('');
		
	};
	

	$(".btn").click(function(){
		
		//버튼을 눌렀을때 data-price가 없으면	
		// data-price 없는게 직접 입력 버튼
		if($(this).attr("data-price") == ""){ // 가격 직접 입력시 
			// id = message 값을 message에
			chatLog = $("#logPrice").val();			
		}else{ // 입찰하기(1%값) 버튼 클릭시 
// 			message = $(".auction_price").find("span").html();
			// 누른 값에 해당하는 data-price 속성의 값을 메시지에
			// 현재 상황 입찰하기 버튼을 눌렀을 때 입찰하기 버튼에 data-price속성이 있어서 그 값을 가져오는것
			console.log("1번" + chatLog);
			console.log("1-1번" + typeof chatLog); // number
// 			if(message == null || message == "") {
// 				message = (parseInt($(this).attr("data-price"), 10) + ${price }) + ""; // 3300
// 				console.log("4번" + message + typeof message); // 303000  string
// 			} else {
// 				console.log("else도착");
				chatLog = (parseInt($(this).attr("data-price"), 10) + parseInt(nowPrice, 10) + "");
				console.log("2번" + chatLog);
// 			}
		}
		
		if(chatLog == ""){
			alert("금액을 입력해주세요")
			return false;
		} else if(chatLog < ${price} ) {
			alert("최소금액 보다 높게 입력해주세요")
			$("#chatLog").val("");
			chatLog = nowPrice;
			return false;
		}
		
		if(nowPrice < chatLog) {
			nowPrice = chatLog;
		}
		
		console.log(chatLog);
		chatSend2();
	})
	
	connect2();
	
});


var socket2 = null;
function connect2() {
	var ws2 = new WebSocket("ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/auctionLog");
	socket2 = ws2;
	
	ws2.onopen = function() {
		console.log('Info: connection opened');
		
	};
	
	// 메세지 수신
	ws2.onmessage = function (msg) {
		var data = msg.data;
		var sessionId = null; //데이터를 보낸 사람
		var sessionName = null; 
		var message = null;
// 		var enrollCode = ${enrollCode};
		var auctionCode = "${auction.auction_code }";
		
		var cur_session = "${sessionScope.sId}"; //현재 세션에 로그인 한 사람
		console.log(data);
		sessionId = data.split(":")[0];
		sessionName = data.split(":")[1];
		message = data.split(":")[2];

		
		// 낙찰 최대금액
	//	var auctionMax = "<span>" + message + "</span>원&nbsp;<i class='fa-solid fa-comment-dollar'></i>";
	//	$(".auction_price").html(auctionMax);
		$(".auction_price").find("span").html(message);
// 		$("#btnAskingPrice").attr("data-price",message);
		//  입찰하기 부분이 현재 최고가 기준으로 변경됨 (속성만)
		// 보여주는 부분을 변경하려면 val()을 수정해야하는것
// 		$("btnAskingPrice").attr("data-price", message);
		
		// 낙찰 최대금액 닉네임
		var auctionNic = "<span>" + sessionName + "님</span>";
		$(".auction_id").html(auctionNic);
		
		// 경매 로그
		var auctionLog = "<div class='chat_myself'>" + sessionName + "님&nbsp;&nbsp;<span>" + message + "원&nbsp;&nbsp;입찰!&nbsp;&nbsp;</span>" + amPm + " " + hours + ":" + minutes + "</div>";
		$(".logBox").append(auctionLog);
		
		if(sessionId == cur_session) { // 세션 ID 와 입력된 금액의 ID가 같을 경우
			// 내가 입력한 낙찰가
			var auctionMyPrice =  message + "원";
			$(".my_bid").html(auctionMyPrice);
		}
	};
	
	ws2.onclose = function (event) { console.log('Info: connection closed'); };
	ws2.onerror = function (event) { console.log('Info: connection closed'); };
}
</script>
</html>
