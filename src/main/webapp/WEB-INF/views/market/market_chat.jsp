<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<c:set var="path" value="${pageContext.request.contextPath}" />
<html>
<head>
<meta charset="UTF-8">
<title>머니또</title>
<link href="${path }/resources/css/market_chat.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
<link href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"   rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<script type="text/javascript">
let target;
let room_code;
let item_code;
// 안되면그냥 바로 결제로 연결
function market_payment() {
	// 	alert("market_payment : " + item_code);
	window.open("market_payment?item_code=" + item_code, "_blank", "width=500,height=650,top=100,left=600");
}
$(function() {
	let isReview = ${isReview};
	item_code = "${item_code}";
	// 거래버튼  
	$(".trade img").attr("src", "${path}/resources/images/chat/btn_trade_x2.png");
	if($("input#tradeButton.active").val() == '거래중') {
		$(".trade").empty();
		$(".declaration").after("<div class='trade' onclick='market_payment()' ><div><span style='position: absolute;font-size: 8px;margin-top: -11px;  margin-left: -2px;'>안전결제</span><img src='${path }/resources/images/chat/btn_trade_x2.png' alt='송금이미지'></div></div>");
	} else {
		$(".trade").remove();
	}
	//리뷰작성
	$(document).on("click", ".reviewForm", function() {
		item_code = $('.item_code').val();
		let options = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=400,height=400,left=350,top=200";
		window.open('reviewForm?item_code=' + item_code, '후기작성', options);
	});
	// 판매상태 버튼 처리 >> db에 상태 업데이트
	$(".trade_status input").on("click", function() {
		let item_status = $(this).val();
		if($('input.sch_box').val() === "" && item_status === "거래중") {
			swal({
				icon: "warning",
				text: "일정을 먼저 잡아주세요"
			});
			return;
		}
		let result = swal({
			icon: "info",
			buttons: {
				confirm: {
					text: "네",
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
				}
			},
			text: item_status + "(으)로 상태를 변경하시겠습니까"
		});
		result.then((confirmed) => {
			if(confirmed) {
				$.ajax({
					type: "GET",
					url: "itemStatus_update",
					dataType: "text",
					data: {
						item_status: item_status,
						room_code: room_code
					},
					success: function(result) {
						location.reload();
					}
				});
			}
		});
	}); //$(".trade_status input").on("click", function() 				
	if($("input.active").val() == "판매중") {
		$(".sch_box").val("");
	}
	$('a.sch_date').on("click", function() {
		sch_date();
	});
	// 탈퇴한회원처리 ( disabled 하기)
	let isExistMember = "${opponentId.opponent_delete_status}"
	if(isExistMember == 'Y') {
		let str = "<div class='disabledChat'><div class='disabledContent'><h2>😮 대화가 불가능한 상태입니다</h2></div></div>"
		$(".chat_header").before(str);
		$(".chat_input").attr("disabled", true);
		$(".chat_input").attr("placeholder", "탈퇴한회원입니다");
	} else {
		$(".chat_input").attr("disabled", false);
		$(".chat_input").attr("placeholder", "메세지를 입력해주세요.");
	}
	$(".exitChatRoom").on("click", function(event) {
		// 부모 선택자의 이벤트 실행 안되게 
		event.stopPropagation();
		let result = swal({
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
				}
			},
			text: "해당방을 나가시겠습니까?"
		});
		result.then((confirmed) => {
			if(confirmed) {
				$.ajax({
					type: "POST",
					url: "exitChatRoom",
					data: {
						room_code: room_code
					},
					dataType: "json",
					success: function(result) {
						console.log(result.result);
						location.reload();
					}
				});
			}
		});
	});
	//============================================================================================
	// 신고관련
	$(document).on("click", ".declaration div", function() {
		$(".ReactModalPortal").show();
	});
	// 신고 상세
	$(document).on("click", ".report_check_icon", function() {
		var originalImage = "${path}/resources/images/chat/ico_unChecked.png";
		var activeImage = "${path}/resources/images/chat/ico_checked.png";
		// 모든 아이콘의 이미지를 원래 이미지로 초기화
		$(".report_check_icon").attr("src", originalImage);
		// 선택한 아이콘의 이미지를 활성화 이미지로 변경
		$(this).attr("src", activeImage);
		var reportType = $(this).attr("id");
		$("#report_type").val(reportType);
		$(".report_btn").css("background", "#bb2649");
	});
	$(document).on("change", "#textarea", function(e) {
		$("#report_content").val($(this).val());
	});
	// 신고하기 버튼
	$(document).on("click", ".report_btn", function() {
		var reportType = $("#report_type").val();
		if(reportType == "") {
			swal({
				icon: "warning",
				text: "신고 사유를 선택해주세요!"
			});
		} else {
			swal({
				icon: "success",
				text: "신고 완료!"
			});
			report();
			$(".ReactModalPortal").remove();
		}
	});
	// 모달창 닫기
	$(document).on("click", ".close", function() {
		$(".ReactModalPortal").remove();
	});

	function report() {
		let id = "<%=(String)session.getAttribute("sId")%>";
		let opponentId = "${opponentId.opponent_id}";
		let reportType = $("#report_type").val();
		let reportContent = $("#report_content").val();
		if(typeof reportContent === "undefined" || reportContent === "") {
			reportContent = reportType;
		}
		$.ajax({
			type: "GET",
			url: "report",
			data: {
				targetId: opponentId,
				reportType: reportType,
				reportContent: reportContent,
				item_code: item_code
			},
			dataType: "json",
			success: function(result) {}
		});
	}
	//============================================================================================
	if($("#buyButton").hasClass("active")) {
		$("#tradeButton").prop("disabled", false);
	}
	if(!$("#tradeButton").hasClass("active")) {
		$("#tradeButton").css({
			"background-color": "#F0F0F0",
			"border": "none",
			"color": "#000"
		});
	}
	//리뷰썼을때 후기 작성 지워지고/ 버튼들 disabled
	if(isReview === 1) {
		$(".reviewForm").remove();
		$("#buyButton").prop("disabled", true);
		$("#tradeButton").css({
			"background": "#fff",
			"border": "1px solid #a3a3a3",
			"color": "#939393"
		});
		$("#tradeButton").prop("disabled", true);
	}
	$('.chat_description').scrollTop($('.chat_description')[0].scrollHeight + 1000);
	let sId = "${sessionScope.sId}";
	room_code = <%= request.getAttribute("room_code") %>;
	// (대화내역이 존재하지않을때) => 최근대화에 active
	// (대화내역이 존재할때 ) => 그 내용에 active
	$('.card_box input.room_code[value="' + room_code + '"]').closest('.card_box').addClass('active');
	//아이템코드의 대화내용이있으면 그 대화에 active 되야함
	$(".card_box").on("click", function() {
		room_code = $(this).find('.room_code').val();
		$(".card_box").removeClass("active");
		$(this).addClass("active");
		//채팅내역을 눌렀을때 > 상세보기
		chatDetail(room_code);
	});

	function sch_date() {
		$(".sch_date").click(function() {
			$(".sch_box").datepicker("setDate", null);
			$(".schdule").remove();
			var schBox = $(".sch_box");
			$(".sch_box").datepicker({
				dateFormat: 'yy-mm-dd',
				showOtherMonths: true,
				showMonthAfterYear: true,
				changeYear: true,
				changeMonth: true,
				yearSuffix: "년",
				monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
				monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
				dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
				dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
				minDate: "0D",
				maxDate: "+30D",
				show: "fast",
				onSelect: function(dateText, inst) {
					let scheduleButton = $("<input type='button' class='schdule' value='확인'>");
					trade_date = dateText;
					$(".scheduling").append(scheduleButton);
					scheduleButton.click(function() {
						let result = swal({
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
								}
							},
							text: trade_date + "\n해당 일자로 일정을 잡으시겠습니까?\n확인 버튼을 누를 시 거래중으로 상태가 바뀝니다.",
						});
						result.then((confirmed) => {
							if(confirmed) {
								$.ajax({
									type: "GET",
									url: "itemStatus_update",
									dataType: "text",
									data: {
										item_status: "거래중",
										room_code: room_code,
										trade_date: trade_date
									},
									success: function(result) {
										$('.trade img').remove();
										$('.card_box input.room_code[value="' + room_code + '"]').closest('.card_box').addClass('active');
										$('.trade_status input.active').removeClass('active');
										$('.trade_status input[value="거래중"]').addClass('active');
										$('.schdule').remove();
										$('.card_box.active .sch_box').val(trade_date);
										$('div.card_box.active .profile div').text("거래중");
										$(".declaration").after("<div class='trade' onclick='market_payment()'><div><span style='position: absolute;font-size: 8px;margin-top: -11px;  margin-left: -2px;'>안전결제</span><img src='${path }/resources/images/chat/btn_trade_x2.png' alt='송금이미지'></div></div>");
									}
								});
							}
						});
					});
				}
			});
		});
		$(".sch_date").click(function() {
			$(".sch_box").datepicker("show");
		});
	}
	let currentDate;
	let tradeDate;
	//왼쪽 list 눌렸을때
	function chatDetail(room_code) {
		//다른채팅방에서 글을쓰고 다른 채팅방 누를경우
		$('.chat_input').val('');
		new Promise((succ, fail) => {
			$.ajax({
				type: "GET",
				url: "chatDetail",
				dataType: "json",
				data: {
					room_code: room_code
				},
				success: function(result) {
					let dateString = result.chatDetail[0].chat_openDate;
					let date = new Date(dateString);
					let year = date.getFullYear();
					let month = (date.getMonth() + 1).toString().padStart(2, '0');
					let day = date.getDate().toString().padStart(2, '0');
					let formatDate = year + '년 ' + month + '월 ' + day + '일';
					// 채팅 헤더 상대방 닉네임
					let buy_nickname = result.chatDetail[0].buy_nickname;
					let item_subject = result.chatDetail[0].item_subject;
					let buy_profileImg = result.chatDetail[0].buy_image;
					let sell_profileImg = result.chatDetail[0].sell_image;
					let buy_id = result.chatDetail[0].buy_member_id;
					let sell_id = result.chatDetail[0].sell_member_id;
					let sell_nickname = result.chatDetail[0].sell_nickname;
					let profileImg = sell_profileImg;
					let trade_date = result.chatDetail[0].trade_date;
					let opponent_delete_status = result.opponentId.opponent_delete_status;
					let opponent_nickname = result.opponentId.opponent_nickname;
					let opponent_grade_img = result.grade_img;
					item_code = result.chatDetail[0].item_code;
					let opponent_id = result.opponentId.opponent_id;
// 					alert(opponent_grade_img);
					//신고
					function report(opponent_id, item_code) {
						let reportType = $("#report_type").val();
						let reportContent = $("#report_content").val();
						$.ajax({
							type: "GET",
							url: "report",
							data: {
								targetId: opponent_id,
								reportType: reportType,
								reportContent: reportContent,
								item_code: item_code
							},
							dataType: "json",
							success: function(result) {}
						});
					}
					//Y일때 탈퇴
					if(opponent_delete_status == 'Y') {
						let str = "<div class='disabledChat'><div class='disabledContent'><h2>😮 대화가 불가능한 상태입니다</h2></div></div>"
						$(".chat_header").before(str);
						$(".chat_input").attr("disabled", true);
						$(".chat_input").attr("placeholder", "탈퇴한회원입니다");
					} else {
						$('.disabledChat').remove();
						$(".chat_input").attr("disabled", false);
						$(".chat_input").attr("placeholder", "메세지를 입력해주세요.");
					}
					let sellButton = $("<input>").attr("type", "button").addClass("sellTrade").val("거래완료");
					// 상품판매상태 버튼
					$(".trade_status").empty();
					$(".trade_status").append("<input type='button' value='판매중' id='buyButton'> <input type='button' value='거래중' id='tradeButton'> ");
					$(".trade_status").append(sellButton);
					$(".trade_status input").each(function() {
						if($(this).val() === result.chatDetail[0].item_status) {
							$(this).addClass('active');
						}
					});
					$(document).on("click", ".reviewForm", function() {
						let item_code = $(this).find('input[type="hidden"]').val();
						let options = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=400,height=400,left=350,top=200";
						window.open('reviewForm?item_code=' + item_code, '후기작성', options);
					});
					if(result.chatDetail[0].item_status === '거래완료') {
						$(".trade_status").append($("<div class='reviewForm' style='text-align: right;font-size: 13px; color: #bbb'><input type='hidden' value='" + item_code + "'><a>후기작성</a></div>"));
					} else {
						$(".reviewForm").remove();
					}
					$("input.sch_box").val(trade_date);
					if(sId == buy_id) {
						$(".trade").empty();
						$('.image_table img').attr('src', sell_profileImg);
						profileImg = sell_profileImg;
						// 파는사람일땐 거래완료를 하면안됨
					} else if(sId == sell_id) {
						let str = "<br><span style='font-size: 11px;  display: inline-block; float:right;margin-top:5px;font-weight: bolder;'><i class='fa-brands fa-bilibili'></i> 판매자는 거래완료버튼을 누를수 없습니다.</span>";
						$('.image_table img').attr('src', sell_profileImg);
						profileImg = buy_profileImg;
						$(".trade").remove();
						sellButton.prop('disabled', true);
						sellButton.after(str);
						if($('.trade_status .active').val() == '거래완료') {
							sellButton.prop('disabled', false);
							$('span').remove();
							$('.reviewForm').remove();
						}
					}
					// 거래버튼  
					$(".trade img").attr("src", "${path}/resources/images/chat/btn_trade_x2.png");
					if(result.chatDetail[0].item_status == '거래중') {
						$(".declaration").after("<div class='trade' onclick='market_payment()' ><div><span style='position: absolute;font-size: 8px;margin-top: -11px;  margin-left: -2px;'>안전결제</span><img src='${path }/resources/images/chat/btn_trade_x2.png' alt='송금이미지'></div></div>");
					} else {
						$(".trade").remove();
					}
					$(".chat_header a .info div").empty();
					// 헤더에 파는사람아이디
					$(".chat_header a .info div").append("<span>[" + sell_nickname + "]<br><i class='fa-regular fa-comment-dots fa-flip-horizontal'></i> " + item_subject + "</span>");
					$('.right_main .info').attr("onclick", "location.href='mypage?member_id=" + sell_id + "'");
					//날짜표시
					$(".chat_wrapper").empty();
					let str = "<div class='chat_timeago'>" +
						"<div class='chat_timeago_box'>" +
						"<span class='chat_timeago_text'>" + formatDate + "</span></div></div>";
					$(".chat_description .chat_wrapper").append(str);
					//대화내역 상대방인지 나인지 구분하며 표시
					for(var i = 0; i < result.chatDetail.length; i++) {
						let time = new Date(result.chatDetail[i].chat_time);
						let hours = time.getHours();
						let minutes = time.getMinutes();
						let formattedMinutes = minutes.toString().padStart(2, '0');
						let amPm = hours < 12 ? "오전" : "오후";
						hours = hours % 12 || 12;
						let formatChatTime = amPm + " " + hours + ":" + formattedMinutes;
						if(sId == result.chatDetail[i].chat_mem_id) {
							let str =
								"<div class='chat_myself'>" +
								"<div class='chat_myself_box'>" +
								"<div class='chat_myself_message'>" +
								"<span>" + result.chatDetail[i].chat_content + "</span>" +
								"<div class='chat_myself_timeago'>" + formatChatTime + "</div></div></div></div>";
							$(".chat_timeago").append(str);
						} else {
							let str =
								"<div class='chat_opponent'>" +
								"<div class='chat_opponent_box'>" +
								"<div class='chat_opponent_image_box'>" +
								"<img class='chat_opponent_profile_image' src='" + profileImg + "' alt='상대방이미지'></div>" +
								"<div class='chat_opponent_title'><img src='"+opponent_grade_img+"' style='display:inline; width: 15px; margin-bottom: -5px'> " + opponent_nickname + "</div>" +
								"<div class='chat_opponent_message'>" +
								"<span>" + result.chatDetail[i].chat_content + "</span>" +
								"<div class='chat_opponent_timeago'>" + formatChatTime + "</div></div></div></div>";
							$(".chat_timeago").append(str);
						}
						$('.chat_description').scrollTop($('.chat_description')[0].scrollHeight + 1000);
						succ(result);
					} //success
				}
			}); //ajax
		}).then((arg) => { // then
			$(".trade_status input").on("click", function() {
				let item_status = $(this).val();
				let clickedButton = $(this);
				if($('input.sch_box').val() === "" && item_status === "거래중") {
					swal({
						icon: "warning",
						text: "일정을 먼저 잡아주세요"
					});
					return;
				}
				swal({
					icon: "info",
					buttons: {
						confirm: {
							text: "네",
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
						}
					},
					text: item_status + "(으)로 상태를 변경하시겠습니까",
				}).then((confirmed) => {
					if(confirmed) {
						if(item_status == '거래중') {
							$(".declaration").after("<div class='trade' onclick='market_payment()'><div><img src='${path }/resources/images/chat/btn_trade_x2.png' alt='송금이미지'></div></div>");
						} else {
							$(".trade").remove();
						}
						if(item_status == '판매중') {
							$('input.sch_box').val("");
						}
						$.ajax({ // 두번째 ajax
							type: "GET",
							url: "itemStatus_update",
							dataType: "text",
							data: {
								item_status: item_status,
								room_code: room_code
							},
							success: function(result2) {
								$('.trade_status input.active').removeClass('active');
								clickedButton.addClass('active');
								$('div.card_box.active .profile div').text(item_status);
								// 거래완료인 경우 후기 작성 영역 보이기
								if(item_status === '거래완료') {
									$(".trade_status").append($("<div class='reviewForm' style='text-align: right;font-size: 13px; color: #bbb'><input type='hidden' value='" + item_code + "'><a>후기작성</a></div>"));
								} else {
									$(".reviewForm").remove();
								}
								swal("처리되었습니다.");
							}
						});
					}
				});
			});
		}).then((arg) => { // then
			$.ajax({
				type: "GET",
				url: "isReview",
				dataType: "json",
				data: {
					room_code: room_code
				},
				success: function(result) {
					if(result === 1) {
						$(".reviewForm").remove();
						$("#buyButton").prop("disabled", true);
						$("#tradeButton").css({
							"background": "#fff",
							"border": "1px solid #a3a3a3",
							"color": "#939393"
						});
						$("#tradeButton").prop("disabled", true);
					}
				}
			});
		}).then((arg) => { // then
			$.ajax({
				type: "GET",
				url: "marketPaid",
				dataType: "json",
				data: {
					room_code: room_code
				},
				success: function(result) {
					// 						alert("일정날짜 : " + result.tradeDate.trade_date);
					// 						alert("거래완료날짜 : " + result.marketPaid.market_date);
					// 						alert("일정날짜 : " + trade_date);
					// 						alert("거래완료날짜 : "+marketPaid_date);
					//거래내역 없을때
					if((result.marketPaid.market_date == null && result.tradeDate.trade_date != null) || (result.marketPaid.market_date == null && result.tradeDate.trade_date == null)) {
						$('.scheduling').empty();
						if(result.tradeDate.trade_date == null) {
							result.tradeDate.trade_date = '';
						}
						let str = '';
						str += '<a class="sch_date">';
						str += '<i class="fa-regular fa-calendar"></i> 일정잡기 ';
						str += '<input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="' + result.tradeDate.trade_date + '"/>';
						str += '</a>';
						$('.scheduling').append(str);
						sch_date();
					} else if((result.marketPaid.market_date != null && result.tradeDate.trade_date == null) || (result.marketPaid.market_date != null && result.tradeDate.trade_date != null)) {
						//거래내역 있을때
						$('.scheduling').empty();
						let str = '';
						str += '<a class="sch_date">';
						str += '<i class="fa-regular fa-circle-check"></i>';
						str += '<input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="' + result.marketPaid.market_date + '"/><strong>거래완료</strong>';
						str += '</a>';
						$('.scheduling').append(str);
					}
				}
			});
		});
	} //function chatDetail()
});
</script>
<script type="text/javascript">
// 채팅 시간
let today = new Date();
let year = today.getFullYear();
let month = today.getMonth() + 1;
let day = today.getDate();
let h = today.getHours();
let m = today.getMinutes();
month = String(month).padStart(2, '0');
day = String(day).padStart(2, '0');
let amPm = h < 12 ? "오전" : "오후";
let hours = h < 13 ? h : h - 12; // 시
let minutes = m < 10 ? "0" + m : m; // 분
hours = String(hours).padStart(2, '0');
minutes = String(minutes).padStart(2, '0');
let formatDate = amPm + " " + hours + ":" + minutes;
var ws = null;
var socket = null;
$(function() {
	ws = new WebSocket("ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/market_chat");
	socket = ws;
	let urlParams = new URLSearchParams(window.location.search);
	let paramItemCode = urlParams.get('item_code');
	room_code = "${room_code}";
	let target;
	let opponent_img;
	let opponent_nickname;
	let opponent_grade_img;
	if(paramItemCode) {
		target = "${sellId}";
		item_code = "${param.item_code}";
		opponent_img = "${chatList.member_image}";
		opponent_nickname = "${chatList.member_nickname}";
		opponent_grade_img = "${opponent_grade.grade_img}";
// 		alert("상품으로  : " + "${chatList.member_image}");
// 		alert("상품으로 : " + opponent_nickname + ", " + opponent_grade_img +", " + opponent_img);
	} else {
		target = "${opponentId.opponent_id}";
		item_code = "${item_code}";
		opponent_img = "${opponentId.opponent_image}";
		opponent_nickname = "${opponentId.opponent_nickname}";
		opponent_grade_img = "${opponent_grade.grade_img}";
// 		alert("nav"+opponent_img);
// 		alert(opponent_nickname + ", " + opponent_grade_img +", " + opponent_img);
	}
	messages(target, opponent_img, opponent_nickname,opponent_grade_img);
	console.log("nav에서 아이템코드: " + item_code + " room_code: " + room_code + " target: " + target);

	function chatSend(target) {
		const data = {
			"room_code": room_code,
			"name": "${sessionScope.sId}",
			"item_code": item_code,
			"message": $('#message').val(),
			"target": target
		};
		let jsonData = JSON.stringify(data);
		socket.send(jsonData);
	}
	$('#btnSend').on("click", function(evt) {
		if($('#message').val() != '') {
			chatSend(target);
		}
		evt.preventDefault();
		$('#message').val('');
	});
	$("#message").on("keydown", function(key) {
		if(key.keyCode == 13 && $('#message').val() != '') {
			chatSend(target);
			$('#message').val('');
			return false;
		}
	});
	let clickCount = 0;
	$(".card_box li").on("click", function() {
		const clickedListItem = $(this);
		room_code = clickedListItem.find('.room_code').val();
		item_code = clickedListItem.find('.item_code').val();
		// 	        console.log("list 에서 눌렀을때 === 방번호: " + room_code + " 아이템코드: " + item_code + " target: " + target);
		$.ajax({
			type: "GET",
			url: "getTarget",
			dataType: "text",
			data: {
				room_code: room_code,
				item_code: item_code
			},
			success: function(result) {
				let parsedObject = JSON.parse(result);
				target = parsedObject.opponentId.opponent_id;
				console.log(parsedObject);
				if(!$(this).parent().is("ul > div:first-child")) {
					opponent_img = parsedObject.opponentId.opponent_image;
					opponent_nickname = parsedObject.opponentId.opponent_nickname;
					opponent_grade_img = parsedObject.grade_img;
				}
				ws.onclose = function(event) {
					console.log('연결종료');
				};
				ws.onerror = function(event) {
					console.log('연결에러');
				};
				console.log("list 에서 눌렀을때 ajax후 === 방번호: " + room_code + " 아이템코드: " + item_code + " target: " + target);
				messages(target, opponent_img, opponent_nickname,opponent_grade_img);
				clickCount = 0;
			}
		});
		clickCount++;
	});

	function messages(target, opponent_img, opponent_nickname,opponent_grade_img) {
// 		alert(target+","+opponent_img+","+opponent_nickname)
		ws = new WebSocket("ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/market_chat");
		socket = ws;
		ws.onopen = function() {
			console.log('연결완료');
			// 	            console.log("방번호: " + room_code + " 아이템코드: " + item_code + " target: " + target);
			const data = {
				"room_code": room_code,
				"item_code": item_code,
				"name": "${sessionScope.sId}",
				"message": "${sessionScope.sId} " + "님접속",
				"target": target
			};
			let jsonData = JSON.stringify(data);
			socket.send(jsonData);
		};
		ws.onmessage = function(msg) {
			var data = msg.data;
			var sessionId = null;
			var message = null;
			var cur_session = "${sessionScope.sId}";
			sessionId = data.split(":")[0];
			message = data.split(":")[1];
			if(sessionId == cur_session) {
				if(!$(".chat_description").text().trim()) {
					var str = "<div class='chat_timeago'>";
					str += "<div class='chat_timeago_box'>";
					str += "<span class='chat_timeago_text'>" + year + "년 " + month + "월 " + day + "일" + "</span></div></div>";
					$(".chat_wrapper").append(str);
				}
				var str = "<div class='chat_myself'>";
				str += "<div class='chat_myself_box'>";
				str += "<div class='chat_myself_message'>";
				str += "<span>" + message + "</span>";
				str += "<div class='chat_myself_timeago'>" + amPm + " " + hours + ":" + minutes + "</div></div></div></div>";
				$(".chat_wrapper").append(str);
				$(".active .description").text(message);
				$(".active .time_ago").text(year + "-" + month + "-" + day + " " + amPm + " " + hours + ":" + minutes);
			} else {
				var str = " <div class='chat_opponent'><div class='chat_opponent_box'><div class='chat_opponent_image_box'>";
				str += "<img class='chat_opponent_profile_image' src='" + opponent_img + "' alt='상대방이미지'> </div>";
				str += "<div class='chat_opponent_title'><img alt='등급이미지' src='"+ opponent_grade_img +"' style='display:inline-block ;width: 15px;margin-bottom: -5px;'> " + opponent_nickname + "</div>";
				str += "<div class='chat_opponent_message'>";
				str += "<span>" + message + "</span>";
				str += "<div class='chat_opponent_timeago'>" + amPm + " " + hours + ":" + minutes + " </div></div></div></div>";
				$(".chat_wrapper").append(str);
				$(".active .description").text(message);
				$(".active .time_ago").text(year + "-" + month + "-" + day + " " + amPm + " " + hours + ":" + minutes);
			}
			$('.chat_description').scrollTop($('.chat_description')[0].scrollHeight + 100);
		};
	}
});
</script>

</head>
<body>
<input type="hidden" id="report_type" name="report_type" value=""/>
<input type="hidden" id="report_content" name="report_content" value=""/>
<jsp:include page="../nav.jsp" />

      <!-- 신고 모달창 -->
      <div class="ReactModalPortal" style="display: none;">
         <div class="detail_report">
            <div class="modal_main" tabindex="-1" role="dialog">
               <div class="modal_parent">
                  <div class="modal_container">
                     <div class="ReportWrapper">
                        <img src="${path }/resources/images/chat/ico_close_modal.png" alt="닫기 아이콘" class="ReportCloseIcon close">
                        <div class="report_title">신고 사유를 선택해 주세요.</div>
                        <div class="report_list_wrapper">
                           <div class="report_list_box">
                              <img src="${path }/resources/images/chat/ico_unChecked.png" id="카톡/오픈채팅 등 머니또채팅밖에서 대화를 유도해요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">카톡/오픈채팅 등 머니또 채팅밖에서 대화를 유도해요</div>
                           </div>
                           <div class="report_list_box">
                              <img src="${path }/resources/images/chat/ico_unChecked.png" id="신분증/계좌와 같은 개인정보를 수집하고, 잠적했어요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">신분증/계좌와 같은 개인정보를 수집하고, 잠적했어요</div>
                           </div>
                           <div class="report_list_box">
                              <img
                                 src="${path }/resources/images/chat/ico_unChecked.png" id="불법적이거나 불건전한 업무를 지시해요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">불법적이거나 불건전한 업무를 지시해요</div>
                           </div>
                           
                           <div class="report_list_box">
                              <img
                                 src="${path }/resources/images/chat/ico_unChecked.png" id="욕설/비하/혐오 발언을 해요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">욕설/비하/혐오 발언을 해요</div>
                           </div>
                           <div class="report_list_box">
                              <img
                                 src="${path }/resources/images/chat/ico_unChecked.png" id="성희롱을 해요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">성희롱을 해요</div>
                           </div>
                           <div class="report_list_box">
                              <img
                                 src="${path }/resources/images/chat/ico_unChecked.png" id="약속을 지키지 않았어요" alt="체크박스 아이콘" class="report_check_icon">
                              <div class="report_list">약속을 지키지 않았어요</div>
                           </div>
                           <div class="report_content">
                              <textarea id="textarea" rows="5" cols="40" placeholder="신고 상세 사유를 입력해주세요." style="resize: none;"></textarea>
                           </div>
                        </div>
                        <div class="report_btn">신고하기</div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>


      <!-- 채팅내역없을때 -->
      <c:if test="${empty param.item_code and empty myChatList and empty opponent_grade}">
         <section class="content">
            <div class="main_area">
               <div class="content_area">
                  <a href="market_list">
                  <p>
                  <span style="font-size: 50px;">🧐</span><br>
                  <span>대화 내역이 존재하지 않습니다</span><br>
                  <span>대화를 시작 하러 가볼까요?</span><br>
                  </p>
                  </a>
               </div>
            </div>
         </section>
      </c:if>
   

      <!-- 대화내역이있을때 -->
      <c:if test="${not empty myChatList and createRoom ne 0}">
         <section class="content">
            <div class="main_area">
               
               <!-- left -->
               <div class="left_main">
                  <div class="left_main_header">
                     <div class="title"><i class="fa-regular fa-face-smile"></i> MY CHAT LIST <i class="fa-regular fa-face-smile"></i></div>
                  </div>
                  <ul>
                  <!-- 채팅방 목록-->
                  <!--  선택된채팅에 active처리  -->
                  <c:forEach var="chatList" items="${myChatList }">
                     <div class="card_box">
                           <li>
                              <div class="profile">
                                 <img src="${chatList.member_image}" alt="프사">
                                 <div style="font-size: 13px;  text-align: center;}">${chatList.get('item_status')}</div>
                              </div>
                              <div class="exitChatRoom" ><i class="fa-solid fa-arrow-right-from-bracket exitChatRoomIcon" ></i></div>
                              <div class="info">
                                 <div class="nick">[${chatList.get('member_nickname') }]</div>
                                 <div class="subject"><i class="fa-regular fa-comment-dots fa-flip-horizontal"></i> ${chatList.get('item_subject') }</div>
                                 <div class="description">${chatList.get('chat_content') }</div>
                                 <div class="time_ago">${chatTime}</div>   
                                 <input type="hidden" value="${chatList.get('room_code')}" class="room_code">
                                 <input type="hidden" value="${chatList.get('item_code')}" class="item_code" data-item-code="${chatList.get('item_code')}">
                              </div>
                           </li>
                     </div>
                  </c:forEach>
                  </ul>
                  
                  
               </div>
               <!-- 나중에 세션아이디로(내아이디) -->
               <input hidden="${id }">
               <!-- 채팅방 -->
               <div class="right_main">
                  <div class="chat_header">
                     <a href="" target="_blank" rel="noopener noreferrer" style="display: inline-block;">
                        <div class="image_box">
                        
                           <div class="image_table">
                              <c:choose>
                                 <c:when test="${empty sellDetail}">
                                    <img src="${chatList.member_image}" alt="프사">
                                 </c:when>
                                 <c:otherwise>
                                    <img src="${sellDetail.sell_image}" alt="프사">
                                 </c:otherwise>                              
                              </c:choose>
                           </div>
                           
                        </div>
                        
                        <div class='info' onclick='location.href="mypage?member_id=${sellDetail.sell_id}"'>
                           <div>
                              <!-- 판매자 닉네임 -->
                              <span>[${sellDetail.sell_nickname }]<br><i class="fa-regular fa-comment-dots fa-flip-horizontal"></i> ${item_subject }</span>
      <%--                         <span>판매아이템 ${sellCount }개</span> --%>
                           </div>
                        </div>
                     </a>
                     
                     
                     
                     <!-- 신고 -->
                     <div class="declaration">
                        <div>
                           <img src="${path }/resources/images/chat/btn_report_x2.png" alt="신고 이미지">
                        </div>
                     </div>
                     
                     <c:if test="${sellDetail.buy_member_id eq sessionScope.sId and chatList.item_status eq '거래중' }">
                        <div class="trade"  >
                           <div class="moneyttoPay" onclick="market_payment()">
								<span style="position: absolute;font-size: 8px;margin-top: -11px;  margin-left: -2px;">안전결제</span>
								<img src="${path }/resources/images/chat/btn_trade_x2.png" alt="송금이미지">
                           </div>
                        </div>
                     </c:if>
                     
                     
                     <div>
                         <div class="scheduling">
                           	<c:choose>
                           		<c:when test="${empty market_paid }">
	                             <a class="sch_date">
	                                 <i class="fa-regular fa-calendar"></i> 일정잡기 
		                             <input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="${trade_date.trade_date }"/>
	                             </a>
                           		</c:when>
                           		<c:otherwise>
		                             <a class="sch_date">
		                             	<i class="fa-regular fa-circle-check"></i>
			                            <input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="${market_paid.market_date }"/>
		                           		<span><strong>거래완료</strong></span>
		                             </a>
                           		</c:otherwise>
                           	</c:choose>
                         </div>
                         <div class="trade_status">
                            <input type="button" class="${chatList.item_status eq '판매중' ? 'active' : ''}" value="판매중" id="buyButton">
                            <c:choose>
                               <c:when test="${trade_date.trade_date eq null }">
                                  <input type="button" class="${chatList.item_status eq '거래중' ? 'active' : ''}" value="거래중" id="tradeButton" disabled="disabled" style="border: none;background-color: #f0f0f0;color: #000" onclick="tradeBtn()">
                               </c:when>
                               <c:otherwise>
                                  <input type="button" class="${chatList.item_status eq '거래중' ? 'active' : ''}" value="거래중" id="tradeButton" >
                               </c:otherwise>
                            </c:choose>
                            <c:choose>
                               <c:when test="${chatList.item_status ne '거래완료' and sellDetail.sell_member_id eq sessionScope.sId }">
                                  <input type="button" class="sellTrade" value="거래완료" disabled="disabled"><br>
                                  <span style="font-size: 11px;  display: inline-block; float:right;margin-top:5px;font-weight: bolder;"><i class="fa-brands fa-bilibili"></i> 판매자는 거래완료버튼을 누를수 없습니다.</span>
                               </c:when>
                               <c:when test="${chatList.item_status eq '거래완료' and sellDetail.sell_member_id eq sessionScope.sId }">
                                  <input type="button" class="${chatList.item_status eq '거래완료' ? 'active' : ''} sellTrade" value="거래완료">
                               </c:when>
                               <c:otherwise>
                                  <input type="button" class="${chatList.item_status eq '거래완료' ? 'active' : ''} sellTrade" value="거래완료">
                               </c:otherwise>
                            </c:choose>
                            <br>
                               <c:if test="${chatList.item_status eq '거래완료' and sellDetail.sell_member_id ne sessionScope.sId }">
                                   <div class="reviewForm" style="text-align: right;font-size: 13px; color: #bbb"><a>후기작성</a></div>
                              		<input type="hidden" value="${sellDetail.item_code }" class="item_code">
                               </c:if>
                         </div>
                     </div>
                     
                  </div>
                  <!-- 채팅영역 -->
                  <div class="chat_description" style="bottom:49px">
                     <div class="chat_wrapper" id="chat_wrapper">
                        
                        <!-- 나 -->
                        <div class="chat_timeago">
                           <div class="chat_timeago_box">
                              <span class="chat_timeago_text">
                                 <fmt:formatDate value="${chatList.chat_openDate }" pattern="yyyy년 MM월 dd일" />
                              </span>
                           </div>
                        </div>
                        <c:forEach var="chatDetail" items="${chatDetail }">
                           <c:choose>
                               <c:when test="${sessionScope.sId eq chatDetail.chat_mem_id}">
                                   <div class="chat_myself">
                                       <div class="chat_myself_box">
                                           <div class="chat_myself_message">
                                               <span>${chatDetail.chat_content }</span>
												<fmt:parseDate var="formattedDate" value="${chatDetail.chat_time}" pattern="yyyy-MM-dd'T'HH:mm:ss" />
												<div class="chat_myself_timeago"><fmt:formatDate value="${formattedDate}" pattern="a hh:mm" /></div>
                                           </div>
                                       </div>
                                   </div>
                               </c:when>
                               <c:otherwise>
                                  <div class="chat_opponent">
                                       <div class="chat_opponent_box">
                                           <div class="chat_opponent_image_box">
                                               <img class="chat_opponent_profile_image" src="${oppProfileImg}" alt="상대방이미지">
                                           </div>
                                           <div class="chat_opponent_title"> 
                                           <img alt="등급이미지" src="${opponent_grade.grade_img}" style="display:inline-block ;width: 15px;margin-bottom: -5px;"> 
                                           ${opponentId.opponent_nickname }</div>
                                           <div class="chat_opponent_message">
                                               <span>${chatDetail.chat_content }</span>
												<fmt:parseDate var="formattedDate" value="${chatDetail.chat_time}" pattern="yyyy-MM-dd'T'HH:mm:ss" />
												<div class="chat_opponent_timeago"><fmt:formatDate value="${formattedDate}" pattern="a hh:mm" /></div>
                                           </div>
                                       </div>
                                   </div>
                               </c:otherwise>
                           </c:choose>
                        </c:forEach>
                     </div>
                  </div>
                  
                  <!-- 전송버튼 -->
                  <div class="chat_footer">
                     <div class="chat_footer_area">
                        <input type="text" class="chat_input" id="message" contenteditable="true" placeholder="메세지를 입력해주세요."></div>
                        <button type="button" id="btnSend">전송</button>
                     </div>
                  </div>
               </div>
            </div>
         </section>         
         
         
      </c:if>
      
      <c:if test="${not empty param.item_code and createRoom eq 0}">
         <section class="content">
            <div class="main_area">
               <!-- left -->
               <div class="left_main">
                  <div class="left_main_header">
                     <div class="title"><i class="fa-solid fa-heart"></i> MY CHAT LIST <i class="fa-solid fa-heart"></i></div>
                  </div>
                  <ul>
                  <!-- 채팅방 목록-->
                  <!--  선택된채팅에 active처리  -->
                  <c:forEach var="chatList" items="${myChatList }">
                     <div class="card_box">
                           <li>
                              <div class="profile">
                                 <img src="${chatList.member_image}" alt="프사">
                                 <div style="font-size: 13px;  text-align: center;}">${chatList.get('item_status')}</div>
                              </div>
                              <div class="exitChatRoom" ><i class="fa-solid fa-arrow-right-from-bracket exitChatRoomIcon"></i></div>
                              <div class="info">
                                 <div class="nick">[${chatList.get('member_nickname') }]</div>
                                 <div class="subject"><i class="fa-regular fa-comment-dots fa-flip-horizontal"></i> ${chatList.get('item_subject') }</div>
                                 <div class="description">${chatList.get('chat_content') }</div>
                                 <!-- 날짜처리 제대로해야함 -->
                                 <fmt:parseDate var="formattedDate" value="${chatList.chat_time}" pattern="yyyy-MM-dd'T'HH:mm:ss" />
                                 <div class="time_ago"><fmt:formatDate value="${formattedDate}" pattern="yyyy-MM-dd a hh:mm" /></div>   
                                 <input type="hidden" value="${chatList.get('room_code')}" class="room_code">
                                 <input type="hidden" value="${chatList.get('item_code')}" class="item_code">
                              </div>
                           </li>
                        <div class="etc_dots" ></div>
                     </div>
                  </c:forEach>
                  </ul>
               </div>
               <!-- 나중에 세션아이디로(내아이디) -->
               <input hidden="${id }">
               <!-- 채팅방 -->
               <div class="right_main">
               
                  <div class="chat_header">
                     <a href="" target="_blank" rel="noopener noreferrer" style="display: inline-block;">
                        <div class="image_box">
                           <div class="image_table">
                              <c:choose>
                                    <c:when test="${empty sellDetail}">
                                       <img src="${chatList.member_image}" alt="프사">
                                    </c:when>
                                    <c:otherwise>
                                       <img src="${sellDetail.sell_image}" alt="프사">
                                    </c:otherwise>                              
                                 </c:choose>
                           </div>
                        </div>
                        <div class="info">
                           <div>
                              <!-- 상대방 닉네임 -->
                              <span>[${chatList.member_nickname }]<br><i class="fa-regular fa-comment-dots fa-flip-horizontal"></i> ${chatList.item_subject }</span>
      <%--                         <span>판매아이템 ${sellCount }개</span> --%>
                           </div>
                        </div>
                     </a>
                     <!-- 신고 -->
                     <div class="declaration">
                        <div>
                           <img src="${path }/resources/images/chat/btn_report_x2.png" alt="신고 이미지">
                        </div>
                     </div>
                     <div>
                         <div class="scheduling">
                         	<c:choose>
                           		<c:when test="${empty market_paid }">
	                             <a class="sch_date">
	                                 <i class="fa-regular fa-calendar"></i> 일정잡기 
		                             <input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="${trade_date.trade_date }"/>
	                             </a>
                           		</c:when>
                           		<c:otherwise>
		                             <a class="sch_date">
		                             	<i class="fa-regular fa-circle-check"></i>
			                            <input type="text" class="sch_box" style="border: none; width: 90px;" readonly value="${market_paid.market_date }"/>
		                           		<span>거래완료</span>
		                             </a>
                           		</c:otherwise>
                           	</c:choose>
                         </div>
                         <div class="trade_status">
      
                            <input type="button" class="${chatList.item_status eq '판매중' ? 'active' : ''}" value="판매중" id="buyButton">
                            <input type="button" class="${chatList.item_status eq '거래중' ? 'active' : ''}" value="거래중" id="tradeButton">
                            <input type="button" class="${chatList.item_status eq '거래완료' ? 'active' : ''}" value="거래완료" id="sellButton">
                            <br>
                            <c:if test="${chatList.item_status eq '거래완료'}">
                                <div class="reviewForm" style="text-align: right;font-size: 13px; color: #bbb"><a>후기작성</a></div>
                            	<input type="hidden" value="${sellDetail.item_code }">
                            </c:if>
                         </div>
                     </div>
                  </div>
                  
                  <!-- 채팅영역 -->
                  <div class="chat_description" style="bottom:49px">
                     <div class="chat_wrapper" id="chat_wrapper">
                     </div>
                  </div>
                  
                  <!-- 전송버튼 -->
                  <div class="chat_footer">
                     <div class="chat_footer_area">
                        <input type="text" class="chat_input" id="message" contenteditable="true" placeholder="메세지를 입력해주세요."></div>
                        <button type="button" id="btnSend">전송</button>
                     </div>
                  </div>
               </div>
            </div>
         </section>
      </c:if>
   <jsp:include page="../footer.jsp" />
</body>
</html>