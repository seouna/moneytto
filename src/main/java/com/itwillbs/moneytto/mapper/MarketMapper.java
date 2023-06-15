 package com.itwillbs.moneytto.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface MarketMapper {

   // 상품등록
   int insertItem(HashMap<String, String> item);

   // 채팅방 item 정보
   HashMap<String, String> getItem(String item_code);
   // 상품판매상세정보
   HashMap<String, String> sellDetail(int item_code);
   
   // item_code 없을때 
   HashMap<String, String> getAllItem();
   
   // 상대방물건판매갯수
   int sellCount(String openentId);
   

   // 채팅방개설가능한지
   int isInsertChatRoom(@Param("item_code") String item_code,@Param("id") String id);

   //채팅방 생성
   int insertChatRoom(@Param("roomCode") String roomCode,@Param("itemCode") String itemCode,@Param("messages") String messages);
   
   
   // 내채팅목록
   List<HashMap<String, String>> myChatList(String id);
   List<HashMap<String, String>> myChatAllList(String id);

   //상대방 아이디알아내기
   HashMap<String, String> opponentId(@Param("room_code") int room_code,@Param("session_id") String session_id);
   
   //아이템상세목록
   HashMap<String, String> itemList(String item_code);

   //채팅상세내용
   List<HashMap<String, String>> chatDetail(int room_code);

   // 마켓 메인 아이템 리스트   //05.27 id 추가
   List<HashMap<String, String>> marketItemList(@Param("item_category") String item_category, 
         @Param("item_tag") String item_tag, 
         @Param("item_status") String item_status, 
         @Param("item_price_min") String item_price_min,
         @Param("item_price_max") String item_price_max, 
         @Param("member_grade") String member_grade,
         @Param("sort") String sort,
         @Param("member_id") String member_id);

   int saveImage(HashMap<String, String> saveImage);

   String selectItem();

   //채팅
   HashMap<String, Integer> chatRecentList(String id);

   //상태업데이트
   int updateStatus(@Param("item_status") String item_status,@Param("item_code") String item_code);

   // 아이템코드 알아내기
   HashMap<String, String> item_code(int room_code);

   // 아이템 상세
   HashMap<String, String> marketItem(String item_code);

   
   // 거래내역업데이트
   int insertMarketPaid(@Param("item_detail") HashMap<String, String> item_detail, @Param("sellId") String sellId,@Param("buyId") String buyId,@Param("trade_date") String trade_date,@Param("str") String str);
   
   // 거래내역 삭제
   int delMarketPaid(@Param("item_detail") HashMap<String, String> item_detail, @Param("sellId") String sellId);

   //업데이트 가능한지
   int isUpdate(String item_detail);

   HashMap<String, Integer> itemDetail(String item_code);

   // 상품수정
   int updateItem(HashMap<String, String> item);

   HashMap<String, String> selectBuyItem(@Param("member_id")String id, @Param("item_code")String item_code);
   // 리뷰 추가 05.28
   int insertReview(HashMap<String, String> review);

   int updateReview(HashMap<String, String> review);
   
   // 다음방번호찾기
   int nextRoomCode();


   //판매자아이디 찾기
   HashMap<String, String> sellId(String item_code);
   
   // 마지막 룸코드
   int lastRoomCode();

   // 채팅내용 insert
   int insertChatMessages(@Param("room_code") String room_code, @Param("sellId") String sellId, @Param("buyId") String buyId, @Param("messages") String message, @Param("myId") String myId);
   // 메인 아이템리스트
   List<HashMap<String, String>> selectItemList(String member_id);

   // 아이템 이미지
   List<HashMap<String, String>> selectItemImage(String item_code);

   // 신고하기
   int insertReport(HashMap<String, String> map);

   // 아이템 이미지 삭제 
   int removeImage(String itemCode);

   //룸코드 존재하는지
   int roomCodeExists(String room_code);

   //룸테이블 업데이트
   int updateChatRoom(@Param("messages") String messages,@Param("room_code") String room_code);

   HashMap<String, String> recentlyMsg(String room_code);

   //대화방있을때 룸코드 찾기
   int roomCode(@Param("item_code") String item_code,@Param("id") String id);

   int deleteItem(HashMap<String, String> item);

   // 거래일정 업데이트
   int tradeDateUpdate(@Param("trade_date") String trade_date,@Param("room_code") int room_code);

   // 거래일정 찾기
   HashMap<String, String> tradeDate(int room_code);

   int updateTradeEnd();

   //나간방
   List<HashMap<String, String>> existChatList(String room_code);
   
   List<HashMap<String, String>> navMarketItemList(@Param("navSearch") String navSearch, @Param("sort") String sort, @Param("id") String id);

   
   
   void increaseViews(String item_code);




   // 태그 리스트
   List<HashMap<String, String>> selectTag();

   //리뷰 있는지 확인
   int isReview(String item_code);
   // 메인리스트 최근 아이템
   List<HashMap<String, String>> selectRecentItemList(String id);

   //거래내역
   HashMap<String, String> marketPaid(String item_code);

   //포인트출금
   int pointWithDraw(@Param("id") String id,@Param("itemPrice") int itemPrice);

   int deleteReview(Map<String, String> paramMap);
   
   int tradeSuccess(String item_code);
   // 포인트입금
   int pointDeposit(@Param("sellId")String sellId,@Param("itemPrice") int itemPrice);
	
   
   //TODO 139번 줄에 id 안받고 existChatList 있긴하던데... service엔 파라미터 두개 받길래 일단 만들어봤어요
   // > 아.. 하다만거였어가지고 ....
   List<HashMap<String, String>> existChatList(@Param("room_code")String room_code, @Param("id") String id);

   int updateExistStatus(String room_code);

   int hideReview(HashMap<String, String> review);

   String getItemTag(String itemCode);

   int displayReview(HashMap<String, String> review);

// 관리자에서 사용하기 위한 시작======================================================================================
   // 관리자 아이템 목록
   List<HashMap<String, String>> selectadminItem(HashMap<String, String> map);
   
   // 관리자 신고 목록
   List<HashMap<String, String>> selectAdminReport(HashMap<String, String> map);

   // 중고거래 아이템 신고 처리
   int updateAdminItemReport(HashMap<String, String> map);
// 관리자에서 사용하기 위한 끝======================================================================================

   int updateMemberGrade(HashMap<String, String> review);
	
}