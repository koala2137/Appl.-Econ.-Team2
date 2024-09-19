### Replication(dist)

<Setup>
앞으로의 replication과 연구에서 데이터나 코드를 다룰 일이 적지 않을 것 같습니다. 관련해 numpy, pandas, matplotlib, scipy, numba와 같은 python library를 지속적으로 사용할 것으로 예상되는 만큼, 이참에 개발환경을 한 번 설정해보시는 것을 권장드립니다.

첨부한 Replication 파일을 실행하기 위해 필요한 것들은 다음과 같습니다.

1. Visual Studio Code 설치하기
- 취향에 맞는 에디터가 있다면 그걸 사용하셔도 됩니다.
2. Python 설치하기
3. Python library들 설치하기
    - numpy, pandas, matplotlib는 Python을 설치하는 과정에서 함께 다운받아졌을 것이라 생각합니다.
    - scipy와 numba는 직접 설치하셔야 합니다.
    - cmd에 'pip install library_name'과 같이 입력하시면 자동으로 다운받아질 겁니다.

각각의 스텝에 필요한 정보는 온라인에 잘 정리되어 있는 자료가 무척 많으니 그걸 참고하시면 될 것 같습니다.

<Replication>
replication을 위해 깃헙에서 자료를 다운받으실 때는 폴더(디렉토리) 단위로 다운받아주시면 됩니다. 폴더 안에는 데이터와 코드 파일을 함께 넣어둘 것이며, 실행의 편의를 위해 데이터를 불러오는 과정에서 '상대경로'를 사용하게 작성했으므로 가급적 폴더 안에 있는 파일의 위치를 조작하지 않으시는 걸 권장드립니다.