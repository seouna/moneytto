package com.itwillbs.moneytto.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.moneytto.service.*;

@Controller
public class AdminController {
	
	@Autowired
	private AdminService service;
	
	@Autowired
	private AuctionService auctionService;
	
	@Autowired
	private BankService bankService;
	
	@Autowired
	private MarketService marketService;
	
	@Autowired
	private MemberService memberService;
	
// 메인=============================================
	@RequestMapping(value = "admin", method = {RequestMethod.GET, RequestMethod.POST})
	public String adminMain(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 1. 수익률 비교 위해 계좌내역 조회
		List<HashMap<String, String>> accountChart = bankService.selectAccountHistory(map); // 좀 있다 수정
		// 2. 카테고리별 차트
		List<HashMap<String, String>> categoryChart = service.selectCategoryChart(map);
		// 3. 직거래, 안전거래 비교 차트
		List<HashMap<String, String>> payTypeChart = service.selectPayTypeChart(map);
		// 4. 리뷰 작성률 차트
		List<HashMap<String, String>> reviewChart = memberService.selectAdminMember(map);  // 좀 있다 수정
		// 중복제거 위해 사용
		HashMap<String, String> countMap = new HashMap<>();
		// 내역이 존재할 경우
		// 1. 
		if(accountChart.size() > 0) {
			// 새로운 이름 필요해서 생성
			HashMap<String, String> accountCnt = new HashMap<>();
			// 인덱스 첫번째
			countMap = accountChart.get(0);
			// 스트링 타입으로 생성한 이름으로 저장
			accountCnt.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
			model.addAttribute("accountCnt", accountCnt);
		}
		// 2. 
		if(categoryChart.size() > 0) {
			// 새로운 이름 필요해서 생성
			HashMap<String, String> categoryCnt = new HashMap<>();
			// 인덱스 첫번째
			countMap = categoryChart.get(0);
			// 스트링 타입으로 생성한 이름으로 저장
			categoryCnt.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
			String cate1 = "0";
			String cate2 = "0";
			String cate3 = "0";
			String cate4 = "0";
			String cate5 = "0";
			String cate6 = "0";
			String cate7 = "0";
			// categoryChart에 저장된 List들 중 맞는 값 찾기 위해 반복
			for (HashMap<String, String> chart : categoryChart) {
				// 중복이라
				String cateResult = chart.get("cate_cnt") != null ? String.valueOf(chart.get("cate_cnt")) : "0";
				// switch 조건
				String categorySwi = chart.get("category");
				switch (categorySwi) {
					case "패션/의류/잡화/뷰티":
						cate1 = cateResult;
						break;
					case "가전제품/모바일/PC":
						cate2 = cateResult;
						break;
					case "가구/인테리어":
						cate3 = cateResult;
						break;
					case "도서/음반/문구/티켓":
						cate4 = cateResult;
						break;
					case "게임/스포츠/취미":
						cate5 = cateResult;
						break;
					case "유아동/반려동물":
						cate6 = cateResult;
						break;
					case "그외기타":
						cate7 = cateResult;
						break;
					default:
						break;
				}
			}
			System.out.println("확인1: " + cate1 + " 2: " + cate2 + " 3: " + cate3 + " 4: " + cate4 + " 5: " + cate5 + " 6: " + cate6 + " 7: " + cate7);
			// categoryCnt에 저장위해
			categoryCnt.put("cate1", cate1);
			categoryCnt.put("cate2", cate2);
			categoryCnt.put("cate3", cate3);
			categoryCnt.put("cate4", cate4);
			categoryCnt.put("cate5", cate5);
			categoryCnt.put("cate6", cate6);
			categoryCnt.put("cate7", cate7);
//			for (int i = 1; i <= 7; i++) {
//				categoryCnt.put("cate" + i, "cate" + i);
//			}
			model.addAttribute("categoryCnt", categoryCnt);
			System.out.println("확인용333333" + model);
		}
		// 3. 
		if(payTypeChart.size() > 0) {
			// 새로운 이름 필요해서 생성
			HashMap<String, String> payTypeCnt = new HashMap<>();
			// 인덱스 첫번째
			countMap = payTypeChart.get(0);
			// 스트링 타입으로 생성한 이름으로 저장
			payTypeCnt.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
			String tradeCnt = "";
			String safeCnt = "";
			// categoryChart에 저장된 List들 중 맞는 값 찾기 위해 반복
			for (HashMap<String, String> chart : payTypeChart) {
				// switch 조건
				String marketPayType = chart.get("market_pay_type");
				switch (marketPayType) {
					case "직접거래":
						tradeCnt = String.valueOf(chart.get("trade_cnt")) != null ? String.valueOf(chart.get("trade_cnt")) : "0";
						break;
					case "안전결제":
						safeCnt = String.valueOf(chart.get("safe_cnt")) != null ? String.valueOf(chart.get("safe_cnt")) : "0";
						break;
					default:
						break;
				}
			}
			// payTypeCnt에 저장
			payTypeCnt.put("tradeCnt", tradeCnt);
			payTypeCnt.put("safeCnt", safeCnt);
			model.addAttribute("payTypeCnt", payTypeCnt);
		}
		// 4. 
		if(reviewChart.size() > 0) {
			// 새로운 이름 필요해서 생성
			HashMap<String, String> reviewCnt = new HashMap<>();
			// 인덱스 첫번째
			countMap = reviewChart.get(0);
			// 스트링 타입으로 생성한 이름으로 저장
			reviewCnt.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
			model.addAttribute("reviewCnt", reviewCnt);
		}
		// 내역을 model에 저장
		model.addAttribute("accountChart", accountChart);
		model.addAttribute("categoryChart", categoryChart);
		model.addAttribute("payTypeChart", payTypeChart);
		model.addAttribute("reviewChart", reviewChart);
		model.addAttribute("pageCnt", map);
		System.out.println("adminMain에서" + accountChart);
		System.out.println("adminMain에서" + model);
		
		return "admin/admin_main";
	}

	
// =============================================
	// ???
	@RequestMapping(value = "adminSocialAccount")
	public String adminSocialAccount(Model model) {
		return "admin/adminSocialAccount";
	}
	
	
// 계좌관리=============================================
	// 관리자 현금 계좌
	@RequestMapping(value = "adminAccount", method = {RequestMethod.GET, RequestMethod.POST})
	public String adminAccount(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 계좌내역 조회
		List<HashMap<String, String>> accountHistory = bankService.selectAccountHistory(map);
		// 내역이 존재할 경우
		if(accountHistory.size() > 0) {
			HashMap<String, String> countMap = accountHistory.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("accountHistory", accountHistory);
		// 
		model.addAttribute("pageCnt", map);
		System.out.println("adminAccount에서" + accountHistory);
		System.out.println("adminAccount에서" + map);
		
		return "admin/adminAccount";
	}

	// 관리자 포인트 계좌
	@RequestMapping(value = "adminPoint", method = {RequestMethod.GET, RequestMethod.POST})
	public String adminPoint(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 계좌내역 조회
		List<HashMap<String, String>> pointHistory = bankService.selectPointHistory(map);
		// 내역이 존재할 경우
		if(pointHistory.size() > 0) {
			HashMap<String, String> countMap = pointHistory.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("pointHistory", pointHistory);
		// 
		model.addAttribute("pageCnt", map);
		System.out.println("adminPoint에서" + pointHistory);
		System.out.println("adminPoint에서" + map);
		
		return "admin/adminPoint";
	}
	
	
// 거래관리=============================================
	// 경매 관리
	@RequestMapping(value = "/adminAuction", method = {RequestMethod.GET, RequestMethod.POST})
	public String adminAuction(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 경매 목록 검색
		List<HashMap<String, String>> auction = auctionService.selectAuction(map);
		// 내역이 존재할 경우
		if(auction.size() > 0) {
			HashMap<String, String> countMap = auction.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("auction", auction);
		model.addAttribute("pageCnt", map);
		System.out.println("adminAuction에서" + auction);
		System.out.println("adminAuction에서" + map);
		
		return "admin/adminAuction";
	}
	
	// 경매 등록
	@PostMapping("/auction_regist")
	public String auction_regist(@RequestParam Map<String, String> auction, HttpSession session, Model model) {
		
		// auction_code 생성, 추가
		String uuid = UUID.randomUUID().toString().substring(0, 8);
		auction.put("auction_code", uuid);
		
		int insertCount = service.registAuction(auction);
		
		if(insertCount > 0) { // 성공
			
			// 이미지 테이블 추가.
			Map<String, String> images = new HashMap<String, String>();
			images.put("image_code", (new Random().nextInt(1000000) + 1) + "");
			images.put("table_code", uuid);
			images.put("image_name", auction.get("image_name"));
			
			int insertImage = service.registImage(images);
			
			// 이미지 등록 성공
			if(insertImage > 0) {
				return "redirect:/adminAuction";
				
			} else {
				model.addAttribute("msg", "이미지 등록 실패!");
				return "fail_back";
			}
			
		} else { // 실패
			model.addAttribute("msg", "경매 등록 실패!");
			return "fail_back";
		}
		
	}
	
	// 중고거래
	@RequestMapping(value = "/adminItem", method = {RequestMethod.GET, RequestMethod.POST})
	public String adminItem(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 중고거래 목록 검색
		List<HashMap<String, String>> adminItem = marketService.selectadminItem(map);
		// 내역이 존재할 경우
		if(adminItem.size() > 0) {
			HashMap<String, String> countMap = adminItem.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("adminItem", adminItem);
		model.addAttribute("pageCnt", map);
		System.out.println("adminItem에서1" + adminItem);
		System.out.println("adminItem에서" + map);
		
		return "admin/adminItem";
	}
	
	
	// 게시판=============================================
		// 공지
		@RequestMapping(value = "adminNoticeBoard")
		public String adminNoticeBoard(Model model) {
			return "admin/adminNoticeBoard";
		}
		
		// 커뮤니티
		@RequestMapping(value = "adminFreeBoard")
		public String adminFreeBoard() {
			
			return "admin/adminFreeBoard";
		}
		
	
// 회원관리=============================================
	@RequestMapping(value = "adminMember")
	public String adminMember(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 계좌내역 조회
		List<HashMap<String, String>> adminMember = memberService.selectAdminMember(map);
		// 내역이 존재할 경우
		if(adminMember.size() > 0) {
			HashMap<String, String> countMap = adminMember.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("adminMember", adminMember);
		// 
		model.addAttribute("pageCnt", map);
		System.out.println("adminMember에서" + adminMember);
		System.out.println("adminMember에서" + map);
		
		return "admin/adminMember";
	}
	
	
// 챗봇=============================================
	@RequestMapping(value = "adminChatBot")
	public String adminChatBot() {
		
		return "admin/adminChatBot";
	}

	
// 신고=============================================
	@RequestMapping(value = "adminReport")
	public String adminReport(@RequestParam HashMap<String, String> map, Model model) {
		// 페이지 번호, 글목록수 제한
		if(map.get("startNum") == null || "".equals(map.get("startNum"))) {
			map.put("pageNum", "1");
			map.put("startNum", "0");
			map.put("endNum", "10");
		}
		// 계좌내역 조회
		List<HashMap<String, String>> adminReport = marketService.selectAdminReport(map);
		// 내역이 존재할 경우
		if(adminReport.size() > 0) {
			HashMap<String, String> countMap = adminReport.get(0);
			map.put("totalCnt", String.valueOf(countMap.get("totalCnt")));
		}
		// 내역을 model에 저장
		model.addAttribute("adminReport", adminReport);
		// 
		model.addAttribute("pageCnt", map);
		System.out.println("adminReport에서1" + adminReport);
		System.out.println("adminReport에서2" + map);
		
		return "admin/adminReport";
	}
	
}
