/* 임시(Mock) 데이터 - 백엔드/API 연결 전까지 화면 확인용 */
var FIELDS = ['IT·개발', '디자인', '마케팅', '영업', '경영·사무', '생산·제조', '교육', '의료·보건', '공공·공기업'];
var REGIONS = ['서울', '경기', '인천', '광주', '전남', '전북', '대전', '부산', '대구', '전국'];
var CAREERS = ['신입', '경력 1~3년', '경력 3~5년', '경력 무관'];
var EMP_TYPES = ['정규직', '계약직', '인턴', '파견직', '아르바이트'];
var SOURCES = ['사람인', '잡코리아', '원티드', '기업 홈페이지', '고용24'];
var COMPANY_TYPES = ['공기업', '대기업', '중견기업', '중소기업'];
var POST_CATS = ['재학생', '졸업생', '일반'];

var SEED_JOBS = [
  { id: 1, title: '백엔드 개발자 (Java/Spring) 신입 채용', company: '(주)모아소프트', companyType: '중소기업', field: 'IT·개발', region: '서울', career: '신입', empType: '정규직', start: '2026-11-01', end: '2026-11-30', source: '원티드', applyUrl: 'https://example.com/apply/1', status: '모집중', collectedAt: '2026-11-02 09:10', summary: 'Spring 기반 웹 서비스 개발 및 운영. Oracle/MyBatis 경험자 우대.' },
  { id: 2, title: '프론트엔드 개발자 (React) 경력 채용', company: '다온테크', companyType: '중견기업', field: 'IT·개발', region: '경기', career: '경력 1~3년', empType: '정규직', start: '2026-11-03', end: '2026-12-10', source: '사람인', applyUrl: 'https://example.com/apply/2', status: '모집중', collectedAt: '2026-11-03 10:00', summary: '반응형 웹 UI 개발, 디자인 시스템 구축.' },
  { id: 3, title: 'UI/UX 디자이너 (앱 서비스)', company: '블루캔버스', companyType: '중소기업', field: '디자인', region: '서울', career: '경력 1~3년', empType: '정규직', start: '2026-10-20', end: '2026-11-20', source: '잡코리아', applyUrl: 'https://example.com/apply/3', status: '모집중', collectedAt: '2026-10-21 11:30', summary: '모바일 앱 UX 설계 및 프로토타이핑(Figma).' },
  { id: 4, title: '디지털 마케터 (퍼포먼스)', company: '그로우랩', companyType: '중소기업', field: '마케팅', region: '서울', career: '신입', empType: '계약직', start: '2026-11-01', end: '2026-11-25', source: '사람인', applyUrl: 'https://example.com/apply/4', status: '모집중', collectedAt: '2026-11-01 14:20', summary: '광고 매체 운영 및 성과 분석 리포트 작성.' },
  { id: 5, title: '전남 지역 중소기업 영업관리 사원', company: '목포수산(주)', companyType: '중소기업', field: '영업', region: '전남', career: '신입', empType: '정규직', start: '2026-10-25', end: '2026-11-15', source: '고용24', applyUrl: 'https://example.com/apply/5', status: '모집중', collectedAt: '2026-10-26 08:50', summary: '거래처 관리 및 수주 업무. 목포 근무.' },
  { id: 6, title: '경영지원 사무직 (인사/총무)', company: '한빛산업', companyType: '대기업', field: '경영·사무', region: '광주', career: '경력 무관', empType: '정규직', start: '2026-10-10', end: '2026-10-31', source: '기업 홈페이지', applyUrl: 'https://example.com/apply/6', status: '마감', collectedAt: '2026-10-11 09:00', summary: '인사·총무 업무 전반 지원.' },
  { id: 7, title: '반도체 장비 생산기술 엔지니어', company: '세진엔지니어링', companyType: '대기업', field: '생산·제조', region: '경기', career: '신입', empType: '정규직', start: '2026-11-02', end: '2026-12-05', source: '잡코리아', applyUrl: 'https://example.com/apply/7', status: '모집중', collectedAt: '2026-11-02 16:40', summary: '장비 셋업 및 공정 개선.' },
  { id: 8, title: '초등 방과후 코딩 강사', company: '꿈나무교육', companyType: '중소기업', field: '교육', region: '전남', career: '경력 무관', empType: '계약직', start: '2026-11-01', end: '2026-11-28', source: '고용24', applyUrl: 'https://example.com/apply/8', status: '모집중', collectedAt: '2026-11-01 13:00', summary: '스크래치/파이썬 기초 수업 진행.' },
  { id: 9, title: '병원 원무행정 직원', company: '목포중앙병원', companyType: '중견기업', field: '의료·보건', region: '전남', career: '신입', empType: '정규직', start: '2026-10-28', end: '2026-11-18', source: '기업 홈페이지', applyUrl: 'https://example.com/apply/9', status: '모집중', collectedAt: '2026-10-29 10:15', summary: '접수·수납·보험청구 업무.' },
  { id: 10, title: '지방공기업 일반행정 청년인턴', company: '전남도시공사', companyType: '공기업', field: '공공·공기업', region: '전남', career: '신입', empType: '인턴', start: '2026-11-04', end: '2026-11-22', source: '고용24', applyUrl: 'https://example.com/apply/10', status: '모집중', collectedAt: '2026-11-04 09:30', summary: '6개월 체험형 인턴. 정규직 전환 기회.' },
  { id: 11, title: '데이터 엔지니어 (ETL/수집 파이프라인)', company: '데이터브릿지', companyType: '중소기업', field: 'IT·개발', region: '대전', career: '경력 3~5년', empType: '정규직', start: '2026-09-15', end: '2026-10-15', source: '원티드', applyUrl: 'https://example.com/apply/11', status: '원문확인불가', collectedAt: '2026-09-16 09:00', summary: '외부 API 수집 파이프라인 구축/운영. (원문 링크 확인 불가)' },
  { id: 12, title: 'SNS 콘텐츠 에디터', company: '핑크플래닛', companyType: '중소기업', field: '마케팅', region: '부산', career: '경력 무관', empType: '아르바이트', start: '2026-11-03', end: '2026-11-30', source: '사람인', applyUrl: 'https://example.com/apply/12', status: '모집중', collectedAt: '2026-11-03 17:05', summary: '인스타/블로그 콘텐츠 제작 (주 3일).' }
];

var SEED_POSTS = [
  { id: 1, category: '졸업생', title: '[졸업생] 네이버 서류·면접 후기 공유합니다', writer: '김가온', writerId: 'alumni1', date: '2026-11-03', content: '작년 하반기에 지원했던 경험을 공유합니다.\n\n1) 서류: 프로젝트 경험 위주로 작성\n2) 코딩테스트: 프로그래머스 레벨 2~3 수준\n3) 면접: 프로젝트 질문 비중이 높았어요.\n\n궁금한 점은 댓글 대신 쪽지로 편하게 물어보세요!' },
  { id: 2, category: '재학생', title: '[재학생] 자소서 첨삭 스터디 모집 (목요일 저녁)', writer: '이서연', writerId: 'student1', date: '2026-11-02', content: '매주 목요일 19시에 도서관 스터디룸에서 자소서 서로 첨삭해주실 분 모집합니다. 4명 정도 생각하고 있어요.' },
  { id: 3, category: '일반', title: '목포 지역 취업박람회 일정 안내', writer: '관리자', writerId: 'admin', date: '2026-11-01', content: '11월 20일(금) 목포대학교 체육관에서 지역 취업박람회가 열립니다.\n참여 기업 30여 곳, 현장 면접 진행.' },
  { id: 4, category: '졸업생', title: '공공기관 NCS 필기 준비 팁', writer: '박도윤', writerId: 'alumni2', date: '2026-10-30', content: '의사소통/수리/문제해결 위주로 3개월 준비했습니다. 모의고사 풀이 후 오답노트 만드는 걸 추천해요.' },
  { id: 5, category: '졸업생', title: 'IT 직무 포트폴리오 이렇게 정리했어요', writer: '김가온', writerId: 'alumni1', date: '2026-10-27', content: '깃허브 README에 아키텍처 다이어그램과 트러블슈팅을 정리하니 면접관 반응이 좋았습니다.' }
];
