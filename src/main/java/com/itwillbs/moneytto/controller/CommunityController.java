package com.itwillbs.moneytto.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.moneytto.service.CommunityService;
import com.itwillbs.moneytto.service.MemberService;

@Controller
public class CommunityController {
	
	@Autowired
	private CommunityService service;
	
	@Autowired
	private MemberService memberService;
	
//	@GetMapping(value = "commBoard")
//	public String commBoard(@RequestParam HashMap<String, String> board, Model model, HttpSession session) {
//	    List<HashMap<String, String>> boardList = service.boardList(board);
//
//	    model.addAttribute("boardList", boardList); // boardList를 모델에 추가
//
//	    return "board/community";
//	}
	
	@GetMapping(value = "commBoard")
	public String commBoard(@RequestParam HashMap<String, String> board, Model model, HttpSession session) {
	    List<HashMap<String, String>> boardList = service.boardList(board);
	    
	    String id = (String)session.getAttribute("sId");
	    if (id != null) {
		    HashMap<String, String> member = memberService.getMember(id);
		    String nickname = member.get("member_nickname");
		    model.addAttribute("nickname",nickname);
		}
	    
	    for (HashMap<String, String> boardItem : boardList) {
	        String comm_code = boardItem.get("comm_code");
	        int commentCount = service.commentCount(comm_code);
	        boardItem.put("comment_count", String.valueOf(commentCount));
	    }

	    model.addAttribute("boardList", boardList);
	  

	    return "board/community";
	}


	
	
	@GetMapping(value = "commBoardWrite")
	public String commBoardWrite(Model model,HttpSession session) {
		String id = (String)session.getAttribute("sId");
		if(id==null) {
			model.addAttribute("msg","로그인이 필요합니다.");
			return "fail_back";
		}
		return "board/commBoardWrite";
	}

	
	@PostMapping(value = "BoardWritePro")
	public String BoardWritePro(@RequestParam HashMap<String, String> board, Model model, HttpSession session) {
	    String id = (String) session.getAttribute("sId");
	    board.put("id", id); // "id" 키와 세션에서 가져온 아이디 값을 추가

	    int insertCount = service.insertBoard(board);

	    if (insertCount > 0) {
	        model.addAttribute("msg", "게시물이 등록되었습니다.");
	        model.addAttribute("target", "commBoard");
	        return "success";
	    } else {
	        // 게시물 삽입 중 오류가 발생했습니다
	        model.addAttribute("msg", "게시물 등록에 실패했습니다."); // 오류 메시지를 모델에 추가
	        return "fail_back";
	    }
	}

	
	
	@GetMapping(value = "commBoardView")
	public String commBoardView(@RequestParam HashMap<String, String> board, Model model, HttpSession session) {
	    String comm_code = board.get("comm_code"); // comm_code 값을 가져옵니다.
	    String id = (String)session.getAttribute("sId");
	    if (id != null) {
		    HashMap<String, String> member = memberService.getMember(id);
		    String member_id = member.get("member_id");
		    String nickname = member.get("member_nickname");
		    model.addAttribute("nickname",nickname);
		    model.addAttribute("member_id", member_id); 
		    
		}
	    // 게시물 조회수 증가 처리
	    service.increaseViews(board.get("comm_code"));

	    HashMap<String, String> boardDetail = service.boardDetail(comm_code); // comm_code에 해당하는 글 내용을 조회합니다.
	    List<HashMap<String, String>> replyList = service.replyList(comm_code);

	    if (boardDetail != null) {
	        model.addAttribute("boardDetail", boardDetail);
	        model.addAttribute("replyList", replyList); // 댓글 리스트를 모델에 추가합니다.
	        return "board/commBoardView";
	    } else {
	        return "fail_back";
	    }
	}

	@PostMapping(value = "addComment")
	public String addComment(@RequestParam HashMap<String, String> comment, @RequestParam("comm_code") String commCode, Model model, HttpSession session) {
	    String id = (String) session.getAttribute("sId");
	    comment.put("id", id);

	    // 댓글 추가 작업
	    comment.put("comm_code", commCode); // comm_code 값을 comment에 추가합니다.
	    int replyCount = service.addComment(comment);

	    if (replyCount > 0) {
	        model.addAttribute("msg", "댓글이 등록되었습니다.");
	        model.addAttribute("target", "commBoardView?comm_code=" + commCode);
	        return "success";
	    } else {
	        model.addAttribute("msg", "댓글 등록에 실패했습니다.");
	        model.addAttribute("target", "main");
	        return "fail_back";
	    }
	}
	
	

	@PostMapping(value = "deleteComment")
	@ResponseBody
	public String deleteComment(HttpSession session, @RequestParam("reply_code") int reply_code) {
	    String id = (String) session.getAttribute("sId");

	    HashMap<String, String> comment = service.getComment(reply_code); // 댓글 정보를 가져옵니다.

	    if (comment != null && comment.get("member_id").equals(id)) {
	        // 댓글 작성자와 로그인한 멤버가 일치하면 삭제 작업 수행
	        int deleteCount = service.deleteComment(reply_code);

	        if (deleteCount > 0) {
	            return "success";
	        }
	    }

	    return "fail_back";
	}

//	@PostMapping(value = "deleteBoard")
//	@ResponseBody
//	public String deleteBoard(@RequestParam HashMap<String, String> board, HttpSession session) {
//		String comm_code = board.get("comm_code"); // comm_code 값을 가져옵니다.
//	    String id = (String)session.getAttribute("sId");
//	    HashMap<String, String> boardDetail = service.boardDetail(comm_code); // 게시글 정보를 가져옵니다.
//
//	    if (boardDetail != null && boardDetail.get("member_id").equals(id)) {
//	        // 게시글 작성자와 로그인한 멤버가 일치하면 삭제 작업 수행
//	        int deleteCount = service.deleteBoard(comm_code);
//
//	        if (deleteCount > 0) {
//	            // 삭제 후 페이지 이동 또는 응답 처리
//	            return "success";
//	        }
//	    }
//
//	    return "fail_back";
//	}
	
	@PostMapping(value = "deleteBoard")
	@ResponseBody
	public String deleteBoard(@RequestParam("comm_code") String comm_code, HttpSession session, Model model) {
	    String id = (String)session.getAttribute("sId");
	    HashMap<String, String> boardDetail = service.boardDetail(comm_code); // 게시글 정보를 가져옵니다.

	    if (boardDetail != null && boardDetail.get("member_id").equals(id)) {
	        // 게시글 작성자와 로그인한 멤버가 일치하면 삭제 작업 수행
	        int deleteCount = service.deleteBoard(comm_code);

	        if (deleteCount > 0) {
	        	
	            return "success";
	        }
	    }

	    return "fail_back";
	}



}
