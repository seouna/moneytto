package com.itwillbs.moneytto.socket;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.itwillbs.moneytto.service.MemberService;

public class AuctionChatSocketHandler extends TextWebSocketHandler {
	
	@Autowired
	MemberService memberService;

	private static final Logger logger = LoggerFactory.getLogger(AuctionChatSocketHandler.class);
	
	// 채팅방 목록 <경매 코드, ArrayList<session> >
	private Map<String, ArrayList<WebSocketSession>> auctionList = new ConcurrentHashMap<String, ArrayList<WebSocketSession>>();
	// 세션, 경매코드
	private Map<WebSocketSession, String> sessionList = new ConcurrentHashMap<WebSocketSession, String>();
	// 세션 수
	private static int i;
	
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		i++;
	}

	@Override  
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
		
		String msg = (String)message.getPayload();
		JSONObject jObject = new JSONObject(msg);
	    String name = jObject.getString("name");
	    String messages = jObject.getString("message");
	    String auctionCode = jObject.getString("auctionCode");
		String image = memberService.selectImage(name);
		
		// 채팅 세션 목록에 채팅방이 존재 X
		if(auctionList.get(auctionCode) == null && messages.equals("ENTER")) {
            
            // 채팅방에 들어갈 sessionList 생성
            ArrayList<WebSocketSession> sessionTwo = new ArrayList<>();
            // session 추가
            sessionTwo.add(session);
            // sessionList에 추가
            sessionList.put(session, auctionCode);
            // RoomList에 추가
            auctionList.put(auctionCode, sessionTwo);
            System.out.println("채팅방 생성");
        }
        
        // 채팅방이 존재 할 때
        else if(auctionList.get(auctionCode) != null && messages.equals("ENTER")) {
            
            // RoomList 코드 확인
            auctionList.get(auctionCode).add(session);
            // sessionList에 추가
            sessionList.put(session, auctionCode);
            System.out.println("생성된 채팅방으로 입장");
        }
        
        // 채팅 메세지 입력 시
        else if(auctionList.get(auctionCode) != null && !messages.equals("ENTER")) {
        	Date nowDate = new Date();
    		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm"); 
    		String chatTime = simpleDateFormat.format(nowDate);
            // 채팅 출력
            TextMessage textMessage = new TextMessage(name + "|" + messages + "|" + image + "|" + chatTime + "|" + i);
            
            int sessionCount = 0;
 
            // 해당 코드에 session에 뿌려줌.
            for(WebSocketSession sess : auctionList.get(auctionCode)) {
                sess.sendMessage(textMessage);
                sessionCount++;
            }
            System.out.println("현재 접속 인원 수 : " + sessionCount);
        }
		
        
		
		
	}
	
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		i--;
        // sessionList에 session이 있다면
        if(sessionList.get(session) != null) {
            // 해당 session의 방 번호를 가져와서, 방을 찾고, 그 방의 ArrayList<session>에서 해당 session을 지운다.
            auctionList.get(sessionList.get(session)).remove(session);
            sessionList.remove(session);
        }
		
		
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
	}

	

	@Override
	public boolean supportsPartialMessages() {
		return false;
	}

}
