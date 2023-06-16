<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript" src="${path }/resources/js/moment.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link href="${path }/resources/css/main_mobile.css" rel="stylesheet">
<link href="${path }/resources/css/market_mobile.css" rel="stylesheet">
<script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<title>Insert title here</title>
</head>
<body style="width: 1200px">
<input type="hidden" id="item_category" name="item_category" value="">
<input type="hidden" id="item_status" name="item_status" value="1">
<input type="hidden" id="item_price_min" name="item_price_min" value="0">
<input type="hidden" id="item_price_max" name="item_price_max" value="999999999999999">
<input type="hidden" id="member_grade" name="member_grade" value="">
<input type="hidden" id="sort" name="sort" value="default">
<input type="hidden" id="item_code" name="item_code" value="">
<input type="hidden" id="tag" name="tag" value="">
  
		<div class="layout__Header-sc-1fg0dfe-0 iSTjqT" style="background-color: #BB2649">
			<div class="TopNavigation__Wrapper-sc-6acoe4-0 iqcBld" style="border-bottom: 1px solid #2f2f2f; ">
				<div class="menu2" style=" display: inline-block;margin-left:5px;margin-top:2px; font-size: 2vh;padding: 27px 10px;color: #fff!important; ">
					<a href="main"><div style="display: inline-block;height: 30px;"><img src="${path }/resources/images/header/mobile_logo.png" style="height: 46px;    margin-bottom: 10px;"></div></a>
					<div class="menu" style=" display: inline-block;    margin-right: 15px; color: #fff">
						<a href="auctionMain" style="color: #fff">경매</a>
					</div>
					<div class="menu" style=" display: inline-block;margin-right: 15px;color: #fff">
						<a href="market_list" style="color: #fff">중고거래</a>
					</div>
					<div class="menu" style=" display: inline-block;margin-right: 15px;color: #fff">
						<a href="commBoard" style="color: #fff">커뮤니티</a>
					</div>
					<div class="menu" style=" display: inline-block;color: #fff ">
						<a href="noticeList" style="color: #fff">공지사항</a>
					</div>
				</div>
				<div class="jCbMwE" style=" margin-top:25px;display: inline-block;margin-right:15px; float: right; padding: 6px;color: #fff ">
					
						
				<c:choose>
					<c:when test="${empty sessionScope.sId }">
						<a href="memLogin_mobile" style="color: #fff;font-size: 45px"><i class="fa-regular fa-circle-user"></i></a>	
					</c:when>
					<c:otherwise>
						<a href="todayAlarm" style="color: #fff;margin-right:15px;  font-size: 40px"><i class="fa-regular fa-bell"></i></a>
						<a href="marketChat" style="color: #fff;margin-right:15px;  font-size: 40px"><i class="fa-regular fa-comment-dots fa-flip-horizontal" ></i></a>
						<a href="logout" style="color: #fff;margin-right:15px;  font-size: 40px"><i class="fa-solid fa-right-from-bracket"></i></a>
						<c:if test="${sessionScope.sId ne 'admin' }">
							<a href="itemRegist_mobile" style="color: #fff;margin-right:15px;  font-size: 40px"><i class="fa-solid fa-boxes-packing"></i></a>
						</c:if>
						<c:if test="${sessionScope.sId eq 'admin' }">
						<a href="admin" style="color: #fff;margin-right:15px;  font-size: 40px"><i class="fa-solid fa-screwdriver-wrench"></i></a>
						</c:if>
					</c:otherwise>
				</c:choose>
			</div>
			</div>
		</div>	


	<div id="__next">
		<div class="layout__Header-sc-1fg0dfe-0 iSTjqT">
			<div class="header__Wrapper-hucg1a-0 dncKiK">
				<div class="header__Gnb-hucg1a-1 fixMZO"></div>
			</div>
		</div>
		<div class="layout__Children-sc-1fg0dfe-2 jjXXzz"></div>
   	    <div class="newSearchWrapper">
   	    <!-- 카테고리 -->
   	    	<div>
   	    	<h1 style="margin-top: 55px;font-size: 30px;display: inline-block;padding-left: 30px;">${city }</h1>
   	    	
   	    		 <!-- 태그 검색 -->	
				<div class="searchIconWrapper marketListSearch" style="display: inline-block;float: right;">
					<img src="${path }/resources/images/main/ico_search.png" alt="돋보기 아이콘" class="searchIcon">
					<div class="searchSearch"><form id="searchForm"><input class="goodsName tag" id="searchTag" type="text" placeholder="태그를 검색해보세요!"></form></div>
			 	</div>
   	    	</div>
			<div class="webWrapper">
				<div class="barWrapper">
					<div class="FilterBoxWrapper FilterCategory">
						<div class="FilterBoxTopic" >
							<div class="FilterBoxName">#카테고리</div>
						</div>
						<img src="https://ccimage.hellomarket.com/img/web/search/filter/blue_arrow.svg" alt="화살표 아래 아이콘" class="FilterBoxArrow">
					</div>
					<div class="FilterBoxWrapper FilterPrice">
						<div class="FilterBoxTopic">
							<div class="FilterBoxName">#가격</div>
						</div>
						<img src="https://ccimage.hellomarket.com/img/web/search/filter/blue_arrow.svg" alt="화살표 아래 아이콘" class="FilterBoxArrow">
					</div>
			
				 	<!-- 자동완성 단어 리스트 -->
					<div class="autocomplete"></div>
               	</div>
	         </div>
	         <!-- 카테고리 end -->
			<div id="__next">
				<div class="layout__Header-sc-1fg0dfe-0 iSTjqT"></div>
				<div class="layout__Children-sc-1fg0dfe-2 jjXXzz"></div>
				<div class="newSearch__Wrapper-sc-1v1g3nr-0 dVIBtK">
					<div class="web__Wrapper-sc-5x22ci-0 jDBdAO">
						<div class="toggle__Wrapper-skglus-0 dEBCMS">
							<!-- 카테고리상세 -->
							<div class="categoryDetail" style="display: none;">
								<div class="category__CategoryBox-sc-187sq7k-1 kGtMUL">
									<div class="List__Wrapper-rd56hw-0 cmyJpu">
										<div class="ListNonSelected" id="all" title="전체">전체</div>
										<div class="ListNonSelected" id="fashion" title="패션/의류/잡화/뷰티">패션/의류/잡화/뷰티</div>
										<div class="ListNonSelected" id="pc" title="가전제품/모바일/PC">가전제품/모바일/PC</div>
										<div class="ListNonSelected" id="interior" title="가구/인테리어">가구/인테리어</div>
										<div class="ListNonSelected" id="book" title="도서/음반/문구/티켓">도서/음반/문구/티켓</div>
										<div class="ListNonSelected" id="game" title="게임/스포츠/취미">게임/스포츠/취미</div>
										<div class="ListNonSelected" id="child" title="유아동/반려동물">유아동/반려동물</div>
										<div class="ListNonSelected" id="etc" title="기타">기타</div>
									</div>
								</div>
							</div>
							<!-- 카테고리상세 end -->
							
							<!-- 가격상세 -->
							<div class="priceDetail fEjcIX" style="display: none;">
								<input type="text" placeholder="최저금액" class="item_price_min cRHAEh" value="" onkeyup="this.value=this.value.replace(/[^-0-9]/g,''); priceInput(this);">
								<div class="price__StartPointText-sc-1yxjw4n-1 cOhRDO">원 부터~</div>
								<input type="text" placeholder="최고금액" class="item_price_max dfgaGw" value=""  onkeyup="this.value=this.value.replace(/[^-0-9]/g,''); priceInput(this);">
								<div class="price__EndPointText-sc-1yxjw4n-4 ecxgoB">원 까지</div>
								<button class="priceApplyBtn ezrKUu">적용하기</button>
							</div>

						</div>
					</div>
				</div>
			</div>


			<div id="hello" class="tagListWrapper">
				<div class="tagListFilterBox">
					<div class="tagListReset">
						<div class="tagListResetText">필터초기화</div>
						<img
							src="https://ccimage.hellomarket.com/img/web/search/filter/refresh.svg" alt="reset" class="tagListResetImg">
					</div>
				</div>
			</div>
			<div class="searchedListWrapper">
				<div class="searchedListTopWrapper">
 					<div class="CountListCount">
						반경 10km 이내에                     
						<span class="Count"></span>개의 상품이 있습니다.                    
					</div>
                    <!-- 정렬 -->
					<div class="SortListWrapper">
						<div class="SortListList" id="default" 	 title="최근 등록순">최근 등록순</div>
						<div class="SortListList" id="lowPrice"  title="낮은 가격순">낮은 가격순</div>
						<div class="SortListList" id="highPrice" title="높은 가격순">높은 가격순</div>
						<div class="SortListList" id="highGrade" title="높은 등급순">높은 등급순</div>
                   	</div>
                   	<!-- 현재 정렬 -->
                    <div class="sortSortBox">
                    	<div class="sortSort">최근 등록순</div>
                        <!-- 정렬버튼 이미지 -->
                        <img src="https://ccimage.hellomarket.com/img/web/search/itemList/ico_sort.png" alt="정렬 아이콘" class="sortSortImg"/>
                        </div>
                </div>
                <div>
                   	<!-- 목록 -->
                    <div class="infinite-scroll-component " style="height:auto;">
						<div class="itemListWrapper">
							<div class="itemWrapper"></div>
						</div>
					</div>
				</div>
            </div>
        </div>
       	<img src="${path }/resources/images/top.jpg" id="toTop">
	</div>
          
<script type="text/javascript">
		function category(categoryId) {
			//기존값에 카테고리 추가
			var category = $("#item_category").val();
			var str = '';
			
			switch(categoryId) {
				case "fashion": str += "패션/의류/잡화/뷰티"; break;
				case "pc": str += "가전제품/모바일/PC"; break;
				case "interior": str += "가구/인테리어"; break;
				case "book": str += "도서/음반/문구/티켓"; break;
				case "game": str += "게임/스포츠/취미"; break;
				case "child": str += "유아동/반려동물"; break;
				case "etc": str += "기타"; break;
				case "all": 
			}
			
			// 중복 카테고리 처리
			if(str != "" && category.includes(str)) return;
			
			
			// 카테고리 필터에 추가
			if(str != "") {
				var title = str;
				var tagStr = '';
				tagStr += '<div class="tagListTag">';
				tagStr += '<div class="tagListName" data-cd="1">';
				tagStr += title;
				tagStr += '</div>';
				tagStr += '<img src="https://ccimage.hellomarket.com/img/web/search/filter/mweb/ico_close_tag.png" alt="remove" class="tagListRemove"></div>';
				$(".tagListFilterBox").append(tagStr);
			}
			

			
			
			// all이면 null 넘김
			if(categoryId == "all") {
				$("#item_category").val("");
				$(".tagListName[data-cd='1']").parent().remove();
			} else {
				if(category != ""){
					category += "/";
				}
				category += str;
				$("#item_category").val(category);
			}
			marketItemList();
		}
		
		
		// 태그 처리
		function tag(input) {
			var tagValue = $("#tag").val();

			if(tagValue.includes(input)) return;
			
			if(tagValue != ""){
				tagValue += "|";
			}
			
			tagValue += input;
			$("#tag").val(tagValue);


			// 태그 필터에 추가
			var tagStr = '';
			tagStr += '<div class="tagSearch">';
			tagStr += '<div class="tagListTag">';
			tagStr += '<div class="tagListName" data-cd="3">';
			tagStr += input;
			tagStr += '</div>';
			tagStr += '<img src="https://ccimage.hellomarket.com/img/web/search/filter/mweb/ico_close_tag.png" alt="remove" class="tagListRemove"></div></div>';
			$(".tagListFilterBox").append(tagStr);
		}
		
		
		// 상세 페이지로 이동
		function marketDetail() {
			var item_code = $(this).parent().parent().data("cd");
			$("#item_code").val(item_code);
			location.href="market_detail_m?item_code=" + $("#item_code").val();
		}
		
		
		// 필터 토글
		function toggleFilter(showClass, hideClass) {
		  $(hideClass).hide();
		  $(showClass).toggle();
		}
		
		// 금액 단위 콤마
		function priceReplace(price) {
			return price.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
		}
		// 금액 단위 언콤마
		function uncomma(price) {
			var price = String(price);
			return price.replace(/[^\d]+/g, '');
	    }
		
		// 금액 입력
		function priceInput(priceInput) {
			priceInput.value = priceReplace(uncomma(priceInput.value));
		}
		
			
		// 조회 결과 없을 때 div 생성
		function makeEmptyDiv() {
			var str = '<div class="EmptyEmptyBox">';
			str += '<div class="EmptyTitle">아쉽게도, 현재 검색된 상품이 없어요</div>';
			str += '<div class="EmptyGuide">필터를 재설정하거나 전체 상품 보기를 선택해주세요</div>';
			str += '<div class="EmptyBtnBox" onclick="location.reload();">';
			str += '<img src="https://ccimage.hellomarket.com/img/web/common/refresh_mark.svg" alt="초기화 마크" class="EmptyResetMark-xvqyzf-4 YrGaN">';
			str += '<div class="EmptyShowAllText">전체 상품 보기</div></div></div>';
			$(".itemWrapper").append(str);
		}
		
		// ajax에서 받은 데이터로 div 생성
		function makeDiv(response) {
			for(let item of response) {
				let category = item.item_category;
				let subject = item.item_subject;
				let price = item.item_price;
				let tags = item.item_tag;
				let tag = tags.split(',');
				let date = item.item_date;
				let code = item.item_code;
				let image = item.image_name;
				let count = item.total_count;
				let status = item.item_status;
				var wish = item.wish_code;
				
				price = priceReplace(price);
				
				var itemDate = date;
				var formattedDate = moment(itemDate).format("YYYY-MM-DD HH:mm");
				
				
				if(image == null) {
					image = "${path }/resources/images/main/noThumbnail.jpg";
				}
				
				if(wish == null) {
					wish = '<img src="${path }/resources/images/main/ico_heart_off_x3.png" alt="좋아요 아이콘" class="WishWishImg wish" onclick="wish.call(this)"/>'
				}else{
					wish = '<img src="${path }/resources/images/main/ico_heart_on_x3.png" alt="좋아요 아이콘" class="WishWishImg" onclick="wish.call(this)" />'
				}

				var str = '<div class="itemThumbnailBox item" data-cd="';
				str += code;
				str +=	'">';
				str += '<div class="itemThumbnailBox">';
				str += '<img src="' + image + '" alt="썸네일" class="itemThumbnail" style="cursor: pointer">';
				str += '<input type="button" value="';
				str += status;
				str += '" class="status active">';
				str += wish;
				str += '</div>';
				str += '<div class="itemTextBox">';
				str += '<div class="itemCategory">';
				str += category;
				str += '</div>';
				str += '<div class="itemText subject">';
				str += subject;
				str += '</div>';
				str += '<div class="itemText">';
				str += price + '원';
				str += '</div>';
				
				
				if(tag != "") {
					str += '<div class="itemTagBox">';
					
					for(var i = 0; i < tag.length; i++) {
						str += '<div class="itemSizeTag">';
						str += tag[i];
						str += '</div>';
					}
					str += '</div>';
				}
				
				str += '<div class="itemTimeTag">';
				str += formattedDate;
				str += '</div></div>';
				
				$(".itemWrapper").append(str);
				$(".Count").empty().append(count);
				
			}
			
				var more = '<div class="chall_more">MORE</div>';
				$(".itemListWrapper").after(more);
				
				$(".itemThumbnailBox").hide();
				$(".itemThumbnailBox").slice(0, 20).show();
				
				if($(".itemThumbnailBox:hidden").length == 0) {
					$(".chall_more").fadeOut(100);
				}
		}
		
		
		// 중복 구분자 제거
		function removeChar(str, character){
			var doubleChar = character + character;
			
			if(str[0] == character){
				str = str.substring(1);
			}

			if(str[str.length - 1] == character){
				str = str.slice(0, -1);
			}
 
			if(str.includes(doubleChar)) {
				str = str.replace(doubleChar, character);
			}

			return str;
		}
		
		
		// 상품 리스트 불러오기
		function marketItemList() {
			$(".itemThumbnailBox").remove();
			$(".chall_more").remove();
			$(".EmptyEmptyBox").remove();

			var item_category = $("#item_category").val();
			var item_tag = $("#tag").val();
			var item_status = $("#item_status").val();
			var item_price_min = $("#item_price_min").val();
			var item_price_max = $("#item_price_max").val();
			var member_grade = $("#member_grade").val();
			var sort = $("#sort").val();
			
			
			// 중복 구분자 제거
			item_category = removeChar(item_category, "/");
			item_tag = removeChar(item_tag, "|");
			$("#item_category").val(item_category);
			$("#tag").val(item_tag);
			
// 			console.log("------ marketItemList 요청 시 들어가는 값 ------")
// 			console.log("item_category : " + item_category);
// 			console.log("item_tag : " + item_tag);
// 			console.log("item_status : " + item_status);
// 			console.log("item_price_min : " + item_price_min);
// 			console.log("item_price_max : " + item_price_max);
// 			console.log("member_grade : " + member_grade);
// 			console.log("sort : " + sort);
			
			$.ajax({													
	 			type: "GET",
	 			url: "marketItemList", 
	 			data: { 
	 				item_category	: item_category,
	 				item_tag		: item_tag, 
	 				item_status 	: item_status,
	 				item_price_min 	: item_price_min,
	 				item_price_max 	: item_price_max,
	 				member_grade 	: member_grade,
	 				sort 			: sort
	 			},
	 			dataType: "json",
	 			success: function(response) { 
	 				console.log("marketItemList : 요청처리성공");
	 				
	 				 if (response.length == 0) {
	 		           let count = 0;
	 		           $(".Count").empty().append(count);
	 		           makeEmptyDiv();
	 		           return;
	 				 } 
	 				 // div 생성
	 				 makeDiv(response);
	 			},
	 			error: function(xhr, textStatus, errorThrown) {
	 				console.log("marketItemList : 요청처리실패");
	 			}
	 		});
		}
		
		
		$(function () {
			marketItemList();
			
			// 상단 이동 버튼
			// 보이기 | 숨기기
			$(window).scroll(function() {
				if ($(this).scrollTop() > 250) {
					$('#toTop').fadeIn();
				} else {
					$('#toTop').fadeOut();
				}
		    });
		    // 버튼 클릭시
		    $("#toTop").click(function() {   
		    $('html, body').animate({scrollTop : 0}, 400);          // 속도 400
		    	return false;
		    });
			
			
			// 더보기
			$(document).on("click", ".chall_more", function(e) {
				e.preventDefault();
				$(".itemThumbnailBox:hidden").slice(0, 20).show();
				if($(".itemThumbnailBox:hidden").length == 0) {
					$(".chall_more").fadeOut(100);
				}
			});

			
			
			// 카테고리 클릭
			$(".FilterCategory").on("click", function(e) {
				toggleFilter(".categoryDetail", ".priceDetail");
			});
			
			// 가격 클릭
			$(".FilterPrice").on("click", function(e) {
				toggleFilter(".priceDetail", ".categoryDetail");
			});
			
			
			// 카테고리 선택
			$(document).on("click", ".ListNonSelected", function(e) {
				$(".ListSelected").attr("class", "ListNonSelected");
				$(this).attr("class", "ListSelected");
				
				var categoryId = $(this).attr("id");
				category(categoryId);
				
				
			});


			// 필터 remove
			$(document).on("click", ".tagListRemove", function(e) {
				let text = this.parentElement.textContent;
				var category = $("#item_category").val();
				var item_tag = $("#tag").val();
				var item_price_min = $("#item_price_min").val();
				var item_price_max = $("#item_price_max").val();
				
				/*
					1: 카테고리
					2: 가격
					3: 태그
				*/
				var data = $(this).parent().find(".tagListName").data("cd");
				
				switch(data) {
					case 1: 
						// 카테고리 처리
						$("#item_category").val(category.replace(text, ""))
						break;
					case 2: 
						// 가격 처리
						$("#item_price_min").val(0);
						$("#item_price_max").val(999999999999999);
						break;
					case 3: 
						// 태그 처리
						$("#tag").val(item_tag.replace(text, ""))
				}
				
				marketItemList();
				
				
				$(this).parent().remove();
			});
			
			
			// 필터 초기화
			$(document).on("click", ".tagListReset", function(e) {
				location.reload();	
			});
			
			
			
			// 가격 설정
			$(document).on("click", ".priceApplyBtn", function(e) {
				var item_price_min = uncomma($(".item_price_min").val());
				var item_price_max = uncomma($(".item_price_max").val());
				
				if(item_price_min == "" && item_price_max == "") return;
				
				if(item_price_min == "") {
					$("#item_price_min").val(0);
				} else {
					$("#item_price_min").val(item_price_min);
				}
				
				if(item_price_max == "") {
					$("#item_price_max").val(999999999999999);
				} else {
					$("#item_price_max").val(item_price_max);
				}
				
				// 가격 필터에 추가
				if($(".tagListFilterBox").find(".tagPrice").length > 0) {
					$(".tagPrice").remove();
				}
				var tagStr = '';
				tagStr += '<div class="tagPrice">';
				tagStr += '<div class="tagListTag">';
				tagStr += '<div class="tagListName" data-cd="2">';
				
				if(item_price_min != "") {
					tagStr += item_price_min;
					tagStr = priceReplace(tagStr);
					tagStr += '원';
				}
				
				tagStr += '~';
				
				if(item_price_max != "") {
					tagStr += item_price_max;
					tagStr = priceReplace(tagStr);
					tagStr += '원';
				}
				
				tagStr += '</div>';
				tagStr += '<img src="https://ccimage.hellomarket.com/img/web/search/filter/mweb/ico_close_tag.png" alt="remove" class="tagListRemove"></div></div>';
				
				
				$(".tagListFilterBox").append(tagStr);
				
				marketItemList();
			});
			
			
			// 거래완료 체크
			$(document).on("click", "#complete", function(e) {
				var completeChecked = $("#complete").prop("checked")
				if(completeChecked) {
					$("#item_status").val("1");
				} else {
					$("#item_status").val("");
				}
				marketItemList();
			});
			
			
			// 등급 체크
			$(document).on("click", "#grade", function(e) {
				var gradeChecked = $("#grade").prop("checked")
				if(gradeChecked) {
					$("#member_grade").val("1");
				} else {
					$("#member_grade").val("");
				}
				marketItemList();
			});
			
			
			// 정렬 박스 열기
			$(document).on("click", ".sortSortBox", function(e) {
				$('.SortListWrapper').toggle();
			});
			
			
			// 정렬 선택
			$(document).on("click", ".SortListList", function(e) {
				$(".sortSortBox").remove();
				var title = $(this).attr("title");
				
				// 정렬 글자 변경
				var str = '';
				str += '<div class="sortSortBox">';
				str += '<div class="sortSort">';
				str += title;
				str += '</div>';
				str += '<img src="https://ccimage.hellomarket.com/img/web/search/itemList/ico_sort.png" alt="정렬 아이콘" class="sortSortImg"/></div>';
				
				$(".SortListWrapper").after(str);
				$('.SortListWrapper').toggle();
				
				var sort = $(this).attr("id");
				$("#sort").val(sort);
				marketItemList();
			});
			
			

			
			// 제목 클릭, 이미지 클릭
			$(document).on("click", ".itemThumbnail, .subject", marketDetail);
			
			
			
			// 태그 검색
			$(document).on("submit", "#searchForm", function(e) {
				event.preventDefault(); // 폼 제출 기본 동작 막기
				var input = $("#searchTag").val();
				var tagValue = $("#tag").val();

				tag(input);
				
				marketItemList();
				return false;
			});
			
			$(".searchSearch input").keydown(function(event) {
	            if(event.which === 13) {
					event.preventDefault(); // 엔터 키 기본 동작 막기
					$("#searchForm").submit(); // 폼 제출
	            }
	        });
			
			
			// tag list 초기화
			var availableTag = [];
			
			// tagList
			function tagList() {
				$.ajax({													
		 			type: "GET",
		 			url: "tagList", 
		 			dataType: "json",
		 			success: function(response) { 
		 				console.log("tagList : 요청처리성공");
		 				for(let item of response) {
							let tags2 = item.item_tag;
		 					let tag2 = tags2.split(',');
		 					
		 					for (let tag of tag2) {
								if (!availableTag.includes(tag)) {
									availableTag.push(tag);
								}
							}
		 				}
		 				// 자동완성
		 			    implementAutocomplete();
		 			},
		 			error: function(xhr, textStatus, errorThrown) {
		 				console.log("tagList : 요청처리실패");
		 			}
		 		});
			}
			// 자동완성
			function implementAutocomplete() {
				$("#searchTag").autocomplete({
					source: availableTag,
					select: function(event, ui) {
					console.log(ui.item);
					},
					focus: function(event, ui) {
					return false;
					}
				});
			}
			tagList();
		});
function wish(){
	
	event.preventDefault();
	
	var $btnWish = $(this);
	var item_code = $btnWish.closest(".item").attr("data-cd");
	
	if(${not empty sessionScope.sId}){
		$.ajax({
	   		url : 'clickWish',
	   		type : 'POST',
	   		data : {item_code : item_code}
		}).done(function(){
			$btnWish.toggleClass("wish");
			
			if($btnWish.hasClass("wish")){
				$btnWish.attr({
					'src' : 'resources/images/main/ico_heart_off_x3.png',
					alt : '찜하기 완료'
				});	
			}else{
				$btnWish.attr({
					'src' : 'resources/images/main/ico_heart_on_x3.png',
					alt : '찜하기'
				});
			}
		}).fail(function(){
			
		})	
	}else{
		swal("로그인 후 이용할 수 있습니다.");
	}
}	
</script>
<jsp:include page="../footer.jsp" />
</body>
</html>
<!-- 페이지 자체가 렉 넘 심해서.. 혹시나 해서 10번 라인에 jQuery 서버경로로 바꿨는데
	좀 빨라진 체감이 있는것 같기도...?? 잘 작동안되면 원래 버전으로 바꿔주세요 ~
 -->