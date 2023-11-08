import csv

# 입력 및 출력 파일 경로
input_csv_file = "data/raw/weather.csv"
output_csv_file = "output.csv"

# 결과를 저장할 리스트
result = []

# CSV 파일 열기
with open(input_csv_file, newline='', encoding='utf-8') as csvfile:
    csv_reader = csv.reader(csvfile)
    for row in csv_reader:
        if len(row) != 2:
            continue  # 유효한 행이 아니면 건너뜁니다.

        text, labels = row
        label_list = labels.split()  # 라벨을 공백으로 분할

        # "S-LOCATION" 및 "S-PLACE" 라벨에 해당하는 토큰을 추출하여 결과 리스트에 추가
        token_list = text.split()
        result_tokens = [token_list[i] for i in range(len(token_list)) if label_list[i] in ["S-LOCATION", "S-PLACE"]]
        result_text = " ".join(result_tokens)

        result.append([result_text, "S-LOCATION S-PLACE"])

# 결과를 새로운 CSV 파일에 저장
with open(output_csv_file, mode='w', newline='', encoding='utf-8' ) as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerows(result)

print("새로운 CSV 파일이 생성되었습니다.")
