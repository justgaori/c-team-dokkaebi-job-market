# c-team-dokkaebi-job-market

도깨비 구인구직 프로젝트 (Spring MVC 5.2.7 + MyBatis + Oracle XE, JDK 8, Tomcat 8.5/9).

## 개발환경
- JDK 1.8, STS 3.x(Lombok 설치), Tomcat 8.5/9 (Context Path `/`), Oracle XE (`localhost:1521:XE`)
- DB 계정: `sql/00_create_user.sql` 실행 (book_ex / book_ex)
- 업로드 임시 폴더 `C:\upload\temp` 생성

## 시작
1. STS → Import → Existing Maven Projects
2. Maven → Update Project
3. `DataSourceTests` 실행으로 DB 연결 확인
4. Tomcat 실행 후 http://localhost:8080/ 확인

## 구조
`com.dokkaebi.{controller,domain,mapper,service}`, 매퍼 XML은 `src/main/resources/com/dokkaebi/mapper/`
