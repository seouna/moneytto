

# 🎞 머니또
### 중고거래사이트

<br>

## 📍 프로젝트소개

물가상승으로 인해 영화를 즐기는 고객 수요가낮아짐으로써 <br>
다양한 이벤트(가격할인) 를 열어 고객들의 이용 증대를 바람으로 만들어진 웹사이트 입니다.


## ⏰ 개발기간
![image](https://github.com/seouna/movie-project/assets/117568974/5ce6d79e-379c-4e6d-91b7-8db221acd8af)

##  나의 역할
관리자페이지 대부분 ( 상영등록 / 영화 등록 CRUD )
극장상세 페이지 ( 극상선택페이지 / 상영스케쥴 / 위치표시(구글api) )

## :computer: 개발환경
<div>
	<img src="https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=HTML5&logoColor=white" />
	<img src="https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=CSS3&logoColor=white" />
	<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=JavaScript&logoColor=white" />
	<img src="https://img.shields.io/badge/jQuery-0769AD?style=flat&logo=jQuery&logoColor=white" />	
	<img src="https://img.shields.io/badge/Bootstrap-7952B3?style=flat&logo=Bootstrap&logoColor=white" />
</div>

<div>
	<img src="https://img.shields.io/badge/Java-007396?style=flat&logo=Java&logoColor=white" />
  <img src="https://img.shields.io/badge/MySql-4479A1?style=flat&logo=MySql&logoColor=white">
	<img src="https://img.shields.io/badge/Apache Tomcat-F8DC75?style=flat&logo=Apache Tomcat&logoColor=white" />
  <img src="https://img.shields.io/badge/Spring-6DB33F?style=flat&logo=Spring&logoColor=white">

</div>

<br>

 ## :computer: Tool	
<div>
 <img src="https://img.shields.io/badge/Visual Studio Code-007ACC?style=flat&logo=Visual Studio Code&logoColor=white"/> 
 <img src="https://img.shields.io/badge/GitHub-181717?style=flat&logo=GitHub&logoColor=white"/>
 <img src="https://img.shields.io/badge/Eclipse IDE-2C2255?style=flat&logo=Eclipse IDE&logoColor=white"/>
</div>

<br>

## :book: 프로젝트하면서 느낀점
처음하는 프로젝트여서 그런지 관리자페이지를 하나하나 처음부터 만들고<br> 전체적인 페이지 디자인요소들을 잡으면서 하려니까 시간이 너무 많이 걸렸다.<br>
관리자 페이지를 맡으면서 설계단계에서 생각하지 못했던 기능들을 하나씩 추가하다보니 그랬던거같기도 하다.<br>
혼자서 많은 부분을 맡으려 했던거같아서 좀 힘들었던거같다.<br>
상영 스케쥴을 불러오는 페이지에서는 row to col 하여 쿼리 구문을 짜야했다( 생각 하지도못했던 부분 이였다 )<br>

![image](https://github.com/seouna/movie-project/assets/117568974/c312d8dd-8685-4229-98fd-dde1a643ceb1)
<hr>


그당시엔 이 쿼리가 되게 복잡하다생각했는데 .. <br>
2차프로젝트를 하고난뒤 지금 다시보니까 별거아닌거같다,,<br><br>
![image](https://github.com/seouna/movie-project/assets/117568974/0c675667-04d7-42c3-97a0-f6777bf71f04)


선택한 날짜에 해당영화관의 상영관별 시간들이  표시되어야하고 또 영화별로도 구분되어야해서 고민을 좀 햇던거같다. <br>
group_concat 을 사용하여 상영관별로 시작하는 영화의 시작시간 / 종료시간을 묶어 조회하고<br>
페이지에 출력할때는 split을 하여 표시되게 하였다
<hr>
<br>
그외에도 db테이블을 설계를 좀더 잘했어야했는지 모르겠지만 <br>
다른테이블에서 가져와야할 정보들이 너무 많았다<br> 그래서 쿼리구문들이 점점 길어졌어가지고 이게 맞나 싶었는데<br>
자바선생님께서 테이블설계가 이상한걸수도있지만 원래 하다보면 쿼리구문이 한가득 길어진다고 하셔서<br>
일단 그렇게 넘어갔다....

-- 아 css 파일이 너무많다... ㅎ
 처음에 들고온 파일을 정리하면서 들고왔었어야했는데 처음하는 프로젝트라 팀원들과 소통의 부재탓에,,,
 내가 한부분이아닌건 css 건들이기 좀 애매해서 못건들이겠다.. 😥😥😥😥😥

## 🤍 버전업
> 2023.06.30 관리자 페이지의 영화등록페이지에서 상영중/ 상영예정 / 상영종료 를 구분하는 list 페이지 추가


  


<br><br>

