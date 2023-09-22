###### SJ-Todo,InstagramProfilePage
# ⭐️ Todo,InstagramProfilePage Project
##### Todo 및 InstagramProfilePage 앱 만들기
##### 진행기간 : 2023.09.12~2023.09.22
-----------------------
# 📌 앱 설명

1. 코드베이스
   
2. 메인 controller
<br/> - 버튼을 통해 TodoViewController
<br/> - AddViewController 로 화면 이동
<br/> - URLSession 통해서 API 호출하여 사진 랜덤으로 보여짐
<br/> - UITapGestureRecognizer 사용하여 imageView 터치시 사진 변경 기능 구현

3. TodoViewController
<br/> - UserDefaults 사용하여 데이터 저장,
<br/> - Header와 Footer로 TableView의 Section 나누기,
<br/> - + 버튼 터치 시 AddViewController 로 이동,
<br/> - Edit 버튼 누를 시 삭제 기능 띄우기,
<br/> - 섹션버튼 터치 시 섹션추가 및 섹션 선택 후 글작성 가능
<br/> - 완료목록에 추가하기 위해 셀 터치시 체크마크 표시 후 색상 변경으로 구분

4. AddViewController
<br/> - 제목 및 내용 작성 후 done 버튼 누를시 0.5 로딩 화면 후 데이터 저장

5. DoneViewController
<br/> - 셀에 체크마크 표시될시 tableViewCell에 추가 

6. ProfileDesignViewController
<br/> - 인스타그램 프로필 메인페이지, collectionView 내 선택 이미지 등록 및 이미지 터치시 삭제 알럿

7. PostAddViewController
<br/> - 인스타그램 프로필 메인페이지 collectionView 내 추가될 이미지 저장

8. ProfileViewController
<br/> - 사용자 id, 이름, 소개(설명) 작성 및 수정 페이지


# ● 앱 구성
<img width="689" alt="스크린샷 2023-09-22 오후 12.25.56" src="https://github.com/dnjs012452/SJ-todoList2/assets/139090550/e9b3ea4f-6ebb-4bb8-aa1e-590fe519cb99">
