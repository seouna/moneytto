<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="listCount" value="${fn:length(itemList)}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${path }/resources/css/market.css">
<link rel="stylesheet" href="${path }/resources/css/member.css">
<link href="${path }/resources/css/board.css"rel="stylesheet">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript" src="${path }/resources/js/wish.js"></script>
<script type="text/javascript" src="${path }/resources/js/common.js"></script>
<script>

$(document).ready(function(){
	
  	$(".itemThumbnail, .itemTextBox").on("click",function(){
  		var item_code = $(this).closest(".item").attr("data-cd");
		location.href="market_detail?item_code="+item_code
	})
	 
	$(".tabTab").on("click",function(){
		var itemType = $(this).attr('data-attr');
		location.href = "mypage?itemList="+ itemType + "&member_id=${member.member_id }" ;
		})
		
	$('#searchInput').on('input', function(){
		var searchKeyword = $(this).val();
		if (searchKeyword === '') {
			$('.item').show();
			$('.listCount').text('전체: ' + ${listCount});
	      	return;
		}
		
		var searchCount = 0;
		
 	 	$('.item').each(function() {
 	      var itemTitle = $(this).find('.itemText.subject').text(); 

 	      if (itemTitle.toLowerCase().indexOf(searchKeyword.toLowerCase()) === -1) {
 	        $(this).hide();
 	      } else {
 	        $(this).show();
 	        searchCount++;
 	      }
 	   });
 	 	
 	 	updateSearchCount(searchCount);
 	});
  	function updateSearchCount(count) {
  	    $('.listCount').text('검색된 항목 수: ' + count);
  	  }
  	
  	
  	
  	
 });
 
function memberAuth(){
	let authWindow = window.open("about:blank","authWindow","width=500, height=700");
	authWindow.location = "https://testapi.openbanking.or.kr/oauth/2.0/authorize"
	+"?response_type=code"
	+"&client_id=${client_id}"
	+"&redirect_uri=http://localhost:8082/moneytto/memberAuth"
	+"&scope=login inquiry transfer oob"
	+"&state=11111111111111111111111111111111"
	+"&auth_type=0";
}
function bankDeposit(){
		window.open("depositForm", "_blank","width=500,height=650,top=100,left=600");
	}
function reviewDelete(item_code){
	event.preventDefault();

	swal({
		text: "리뷰를 삭제하시겠습니까?",
		icon: "warning",
		buttons: {
			confirm: {
				text: "삭제",
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
	}).then((result) => {
		if(result){
			$.ajax({
				url: "deleteReview?item_code=" + item_code,
				method: "GET",
				success: function(response){
					location.reload();
				},
				error: function(xhr, status, error){
					console.error(error);
				}
			});
		}
	});
}
function reviewHide(review_code) {
	event.preventDefault();

	swal({
		title:"리뷰를 숨기시겠습니까?",
		text: "숨긴 리뷰는 작성자만 확인할 수 있습니다.",
		icon: "warning",
		buttons: {
			confirm: {
				text: "숨김",
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
	}).then((result) => {
		if(result){
			location.href="reviewHide?review_code="+review_code;
		}
	});
	    
 }

</script>
</head>
<body>
	<jsp:include page="../nav.jsp" />
							
	<div class="profileWrapper">
		<div class="profileContainer" style="min-height:1120px">
			<div class="memberInfoWrapper">
				<div class="memberInfoInfoArea">
					<div class="userDataWrapper">
							<div class="profile_edit_image">
							<div class="profile_edit_image_box">
								<img src="${member.member_image}" alt="머니또의 프로필 이미지">
							</div>
							</div>
							<div class="userDataNickName">${member.member_nickname }</div>
					</div>
					<div class="memberInfoReviewBox">
						<div class="memberInfoText">등급</div>
						<div class="memberInfoRating">
							<div class="memberInfoCount"><img src="${grade.grade_img }" style="display:inline; width: 25px; height: 25px;">${grade.grade_name }</div>
						</div>
					</div>
					<c:if test= "${sessionScope.sId eq member.member_id }">
						<div class="memberInfoReviewBox">
							<div class="memberInfoText">또머니</div>
							<div class="memberInfoCount"><fmt:formatNumber value="${member.member_point  }" pattern="#,###" /></div>
						</div>
						<div class="memberInfoReviewBox">
							<div class="memberInfoText">또머니페이</div>
							<c:choose>
								
								<c:when test="${member.member_auth_status eq 'Y'  }">
									<div class="memberInfoCount" onclick="openCenteredWindow('bank_userInfo','계좌 관리하기', 1000, 500)">계좌 관리하기</div>
								</c:when>
								<c:otherwise>
									<div class="memberInfoCount" onclick="memberAuth()">계좌 등록하기</div>
								</c:otherwise>
							</c:choose>
						</div>
						
						<div class="memberInfoMyDataBox" onclick='location.href="memberUpdateForm"'>
							<div class="memberInfoSettingMyData">내정보 수정하기</div>
						</div>
						<div class="memberInfoMyDataBox" onclick='payment()' style="margin-top: 10px;">
							<div class="memberInfoSettingMyData">포인트 충전하기</div>
						</div>
						<div class="memberInfoMyDataBox" onclick='bankDeposit()' style="margin-top: 10px;">
							<div class="memberInfoSettingMyData">포인트 환급받기</div>
						</div>
					</c:if>
				</div>
			</div>
			
			<!-- 탭 -->
			<div class="listWrapper">
				<div class="tabWrapper">
					<div class="tabTab" data-attr="sellItem"><a href="#">판매 상품</a></div>
					<div class="tabTab" data-attr="wishItem"><a href="#">찜한 상품</a></div>
					<div class="tabTab" data-attr="buyItem"><a href="#">구매 상품</a></div>
					<c:if test= "${sessionScope.sId eq member.member_id }">
					<div class="tabTab" data-attr="auctionPay"><a href="#">낙찰된 경매</a></div>
					<div class="tabTab" data-attr="writtenReview"><a href="#">나의 리뷰</a></div>
					</c:if>
					<div class="tabTab" data-attr="recivedReview"><a href="#">받은 리뷰</a></div>
				</div>
				
				<div class="filterBarWrapper">
					<div class="tabPcBox">
						<div class="tabFilterTab">
							<form class="SearchWrapper" style="width: 730px">
								<input type="text" placeholder="상품명 검색" id="searchInput"
									class="SearchInput-ukztbj-1 inqgpT" value=""><img
									src="https://ccimage.hellomarket.com/img/web/common/black_glass.svg"
									alt="카테고리 검색 아이콘" class="SearchSearchImg-ukztbj-2 gSfjHN">
							</form>
						</div>
					</div>
					<div class="tagListWrapper-gkczkp-0 geRbir"></div>
					
				</div>
				<div class="listControlBox"><div class="listCount">전체 ${fn:length(itemList) }</div>
				</div>
				
				<div class="itemWrapper">
				
					<c:choose>
					
					<c:when test="${param.itemList eq 'auctionPay'}">
						<table id="board-table">
							<tr>
								<th id="board-header">글번호</th>
								<th id="board-header">경매 이름</th>
								<th id="board-header">낙찰가</th>
								<th id="board-header">날짜</th>
								<th id="board-header">결제상태</th>
							</tr>
						    <c:forEach items="${itemList}" var="item" varStatus="status">
						        <tr>
						            <td id="board-data">${status.index +1}</td>
						           <td id="board-data">
									   <div class="board-info">
									      <a href="auctionMain" class="board-title">${item.auction_item_name}</a>
									   </div>
									</td>
						            <td id="board-data">${item.success_price}</td>
						            <td id="board-data">${item.auction_end_date}</td>
						            <c:choose>
						            	<c:when test="${not empty item.pay_code }">
						            		<td id="board-data">
						            			<a href="auctionPayDetail?auction_code=${item.auction_code}" class="board-title">확인하기</a>
						            		</td>
						            	</c:when>
						            	<c:otherwise>
						       		     	<td id="board-data">
						       		     		<a href="auctionPay?auction_code=${item.auction_code}" class="board-title">결제하기</a>
						       		     	</td>
						            	</c:otherwise>
						            </c:choose>
						        </tr>
						    </c:forEach>
						</table>
					</c:when>
					
					<c:when test="${param.itemList eq 'writtenReview'}">
						<table id="board-table">
							<tr>
								<th id="board-header">리뷰</th>
								<th id="board-header">상세보기</th>
								<th id="board-header" style="width: 4%;">별점</th>
								<th id="board-header" style="width: 10%;">리뷰</th>
								<th id="board-header" style="width: 15%;">날짜</th>
							</tr>
						    <c:forEach items="${itemList}" var="item" varStatus="status">
						        <tr>
						            <td id="board-data">${itemList.size() - status.index}</td>
						            <td id="board-data" style="white-space: nowrap;text-overflow: ellipsis;overflow: hidden;"><a href="market_detail?item_code=${item.item_code}" class="board-title">${item.item_subject}</a></td>
						            <td id="board-data">${item.rating}</td>
						            <c:choose>
						            	<c:when test="${not empty item.rating }">
					            		<td id="board-data">
							            	<a href="javascript:void(0)" onclick="openCenteredWindow('reviewForm?item_code=${item.item_code}' , '머니또', 400 ,400)" class="board-title">
							       		     			수정 </a>|
							       		    <a href="#"class="board-title" onclick="reviewDelete('${item.item_code}')">삭제</a>
					            		</td>
						            	</c:when>
						            	<c:otherwise>
						       		     	<td id="board-data">
						       		     		<a href="javascript:void(0)" onclick="openCenteredWindow('reviewForm?item_code=${item.item_code}' , '머니또', 400 ,400)" class="board-title">
						       		     			리뷰 작성</a>
						       		     	</td>
						            	</c:otherwise>
						            </c:choose>
						            <td id="board-data">${item.review_date}</td>
						        </tr>
						    </c:forEach>
						</table>
					</c:when>
					
					<c:when test="${param.itemList eq 'recivedReview'}">
						<table id="board-table">
							<tr>
								<th id="board-header">리 뷰</th>
								<th id="board-header">상세보기</th>
								<th id="board-header" style="width: 4%;">별점</th>
								<th id="board-header" style="width: 10%;">리뷰</th>
								<th id="board-header" style="width: 15%;">날짜</th>
							</tr>
						    <c:forEach items="${itemList}" var="item" varStatus="status">
						    	<c:if test="${item.hide_review eq 'N' }">
						        <tr>
						            <td id="board-data">${itemList.size() - status.index}</td>
						            <td id="board-data" style="white-space: nowrap;text-overflow: ellipsis;overflow: hidden;"><a href="market_detail?item_code=${item.review_item_code}" class="board-title">${item.review_content}</a></td>
						            <td id="board-data">${item.rating}</td>
				            		<td id="board-data">
				            			<c:if test= "${sessionScope.sId eq member.member_id }">
						       		    <a href="#"class="board-title" onclick="reviewHide('${item.review_code}')">숨김</a>
						       		    </c:if>
				            		</td>
						            <td id="board-data">${item.review_date}</td>
						        </tr>
						        </c:if>
						    </c:forEach>
						</table>
					</c:when>
					
					<c:when test='${not empty itemList }'>
						<c:forEach var="item" items="${itemList }">
						<div class="item" data-cd="${item.item_code }">
							<div class="itemThumbnailBox">
								<c:choose>
	                              	<c:when test="${not empty item.image_name }">
	                              		<img src="${item.image_name }" alt="itemImg" class="itemThumbnail"/>
	                              	</c:when>
	                              	<c:otherwise>
										<img src="${path }/resources/images/main/noThumbnail.jpg" alt="itemImg" class="itemThumbnail" />		                                  		
	                              	</c:otherwise>
	                            </c:choose>
	                            	<input type="button" value="${item.item_status }" class="status active">
								<c:choose>
	                       	 		<c:when test="${not empty item.wish_code }">
	                       	 			<img src="${path }/resources/images/main/ico_heart_on_x3.png" alt="좋아요 아이콘" class="WishWishImg" />
	                           		</c:when>
	                	 		   	<c:otherwise>
	                      	 		   	<img src="${path }/resources/images/main/ico_heart_off_x3.png"  alt="좋아요 아이콘" class="WishWishImg wish" >
	                      	 		</c:otherwise>
	                             </c:choose>
							</div>
							<div class="itemTextBox">
								<div class="itemCategory">${item.item_category }</div>
								<div class="itemText subject">${item.item_subject }</div>
								<div class="itemText"><fmt:formatNumber value="${item.item_price  }" pattern="#,###" />원</div>
								<div class="itemTagBox">
								<c:forEach var="item_tag"
											items="${fn:split(item.item_tag, ',')}">
											<c:choose>
												<c:when test="${not empty item_tag}">
													<div class="itemSizeTag">${item_tag}</div>
												</c:when>
												<c:otherwise>
													<div class="itemSizeTag" style="visibility: hidden;"></div>
												</c:otherwise>
											</c:choose>
										</c:forEach>
								</div>
							</div>
						</div>
						</c:forEach>
					</c:when>
						<c:when test= '${empty itemList }'>
	                      	<div class="EmptyEmptyBox">
								<div class="EmptyTitle">아쉽게도, 현재 검색된 상품이 없어요</div>
								<div class="EmptyGuide">필터를 재설정하거나 전체 상품 보기를 선택해주세요</div>
								<div class="EmptyBtnBox">
									<img
										src="https://ccimage.hellomarket.com/img/web/common/refresh_mark.svg"
										alt="초기화 마크" class="EmptyResetMark-xvqyzf-4 YrGaN">
									<div class="EmptyShowAllText">전체 상품 보기</div>
								</div>
							</div>
						</c:when>
					</c:choose>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../footer.jsp" />
</body>
</html>