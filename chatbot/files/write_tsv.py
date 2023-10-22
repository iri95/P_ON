tsv_file = open('user_dic.tsv', 'w', encoding='utf-8')

# 애들 등 NNG로 등록
tsv_file.write("애들\tNNG\n")

# 일정명, 친구이름 -> NNP로 등록
tsv_file.write("3차 회식\tNNP\n")
tsv_file.write("구희영\tNNP\n")

# 필요한 데이터 행 작성

tsv_file.close()  # 파일 닫기
